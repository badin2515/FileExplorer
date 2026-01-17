# HTTP File Transfer API Specification
## Version 2.0

---

## Overview

File transfer ใช้ **HTTP/2** แทน gRPC streaming เพราะ:

| Feature | gRPC Streaming | HTTP/2 |
|---------|---------------|--------|
| Resume support | ❌ ต้อง implement เอง | ✅ Range headers |
| Pause/Resume | ❌ ซับซ้อน | ✅ ง่าย, ตัด connection ได้ |
| Android background | ⚠️ socket อาจโดน kill | ✅ WorkManager + retry |
| Debugging | ❌ ยาก | ✅ standard tools |
| Caching | ❌ ไม่มี | ✅ ETag, Cache-Control |

---

## Base URL

```
http://{device_ip}:{http_port}/api/v1
```

Example: `http://192.168.1.100:8080/api/v1`

---

## Authentication

ทุก request ต้องมี header:

```http
Authorization: Bearer {session_token}
```

Session token ได้จาก gRPC `ConnectionService.VerifyPairing`

---

## Endpoints

### 1. Download File

```http
GET /files/download?path={encoded_path}
```

**Headers:**
```http
Authorization: Bearer {token}
Range: bytes=0-1048575          # Optional: สำหรับ resume
```

**Response:**
```http
HTTP/2 200 OK
Content-Type: application/octet-stream
Content-Length: 15728640
Content-Disposition: attachment; filename="photo.jpg"
Accept-Ranges: bytes
ETag: "abc123"

[binary data]
```

**Resume Support:**
```http
GET /files/download?path=/DCIM/photo.jpg
Range: bytes=5242880-           # Resume from 5MB
```

```http
HTTP/2 206 Partial Content
Content-Range: bytes 5242880-15728639/15728640
Content-Length: 10485760

[binary data from offset]
```

---

### 2. Upload File

```http
POST /files/upload?path={destination_folder}
```

**Headers:**
```http
Authorization: Bearer {token}
Content-Type: application/octet-stream
Content-Length: 15728640
X-Filename: photo.jpg
X-Operation-Id: uuid-for-idempotency
```

**Request Body:**
```
[binary data]
```

**Response:**
```json
{
  "success": true,
  "file": {
    "name": "photo.jpg",
    "path": "/Download/photo.jpg",
    "size": 15728640,
    "modified_time": 1705488000000
  }
}
```

---

### 3. Chunked Upload (Large Files)

สำหรับไฟล์ใหญ่ > 10MB ใช้ chunked upload:

#### 3.1 Initialize Upload

```http
POST /files/upload/init
```

```json
{
  "operation_id": "uuid",
  "destination_path": "/Download",
  "filename": "video.mp4",
  "total_size": 1073741824,
  "chunk_size": 10485760
}
```

**Response:**
```json
{
  "upload_id": "upload-session-id",
  "chunk_size": 10485760,
  "total_chunks": 103
}
```

#### 3.2 Upload Chunk

```http
PUT /files/upload/{upload_id}/chunk/{chunk_index}
```

**Headers:**
```http
Content-Type: application/octet-stream
Content-Length: 10485760
X-Checksum: md5-of-chunk
```

**Response:**
```json
{
  "chunk_index": 0,
  "received_bytes": 10485760,
  "total_received": 10485760,
  "checksum_valid": true
}
```

#### 3.3 Complete Upload

```http
POST /files/upload/{upload_id}/complete
```

```json
{
  "final_checksum": "md5-of-entire-file"
}
```

**Response:**
```json
{
  "success": true,
  "file": {
    "name": "video.mp4",
    "path": "/Download/video.mp4",
    "size": 1073741824
  }
}
```

#### 3.4 Resume Upload (After Failure)

```http
GET /files/upload/{upload_id}/status
```

**Response:**
```json
{
  "upload_id": "upload-session-id",
  "status": "in_progress",
  "chunks_received": [0, 1, 2, 5, 6],
  "chunks_missing": [3, 4, 7, 8, ...],
  "total_chunks": 103,
  "bytes_received": 52428800,
  "expires_at": 1705574400000
}
```

---

### 4. Get Thumbnail

```http
GET /files/thumbnail?path={encoded_path}&size={size}
```

**Query Params:**
- `path`: file path (URL encoded)
- `size`: `small` (64px), `medium` (256px), `large` (512px)

**Response:**
```http
HTTP/2 200 OK
Content-Type: image/webp
Cache-Control: max-age=86400
ETag: "thumb-abc123"

[image data]
```

---

### 5. Stream Media (Preview)

```http
GET /files/stream?path={encoded_path}
```

**Supports Range requests for video seeking.**

---

## Error Responses

```json
{
  "error": {
    "code": "FILE_NOT_FOUND",
    "message": "The requested file does not exist",
    "path": "/DCIM/missing.jpg"
  }
}
```

**Error Codes:**
| Code | HTTP Status | Description |
|------|-------------|-------------|
| `FILE_NOT_FOUND` | 404 | ไม่พบไฟล์ |
| `PERMISSION_DENIED` | 403 | ไม่มีสิทธิ์เข้าถึง |
| `STORAGE_FULL` | 507 | พื้นที่เต็ม |
| `INVALID_TOKEN` | 401 | Token หมดอายุ |
| `UPLOAD_EXPIRED` | 410 | Upload session หมดอายุ |
| `CHECKSUM_MISMATCH` | 422 | ข้อมูลเสียหาย |

---

## Android Implementation Notes

### Background Transfer

ใช้ **WorkManager** สำหรับ upload/download:

```kotlin
class FileUploadWorker(context: Context, params: WorkerParameters) 
    : CoroutineWorker(context, params) {
    
    override suspend fun doWork(): Result {
        val path = inputData.getString("path") ?: return Result.failure()
        val uploadId = inputData.getString("upload_id")
        
        // Resume from last chunk if exists
        val startChunk = if (uploadId != null) {
            getLastCompletedChunk(uploadId)
        } else 0
        
        return try {
            uploadChunks(path, startChunk)
            Result.success()
        } catch (e: Exception) {
            if (runAttemptCount < 3) {
                Result.retry()  // Exponential backoff
            } else {
                Result.failure()
            }
        }
    }
}
```

### Foreground Service

สำหรับ transfer ที่ user เห็น progress:

```kotlin
class TransferForegroundService : Service() {
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val notification = createNotification(progress = 0)
        startForeground(NOTIFICATION_ID, notification)
        
        // Start transfer in coroutine
        serviceScope.launch {
            transferFile()
        }
        
        return START_NOT_STICKY
    }
}
```

---

## Windows Implementation Notes

### Download with Resume

```rust
async fn download_file(
    client: &reqwest::Client,
    url: &str,
    dest: &Path,
    token: &str,
) -> Result<()> {
    // Check if partial file exists
    let start_byte = if dest.exists() {
        std::fs::metadata(dest)?.len()
    } else {
        0
    };

    let mut request = client.get(url)
        .header("Authorization", format!("Bearer {}", token));
    
    if start_byte > 0 {
        request = request.header("Range", format!("bytes={}-", start_byte));
    }

    let response = request.send().await?;
    
    let mut file = OpenOptions::new()
        .create(true)
        .append(true)  // Append for resume
        .open(dest)?;
    
    let mut stream = response.bytes_stream();
    while let Some(chunk) = stream.next().await {
        file.write_all(&chunk?)?;
    }
    
    Ok(())
}
```

---

## Security Considerations

1. **HTTPS in Production**: ใช้ self-signed cert สำหรับ local network
2. **Token Expiry**: Session token หมดอายุใน 24 ชั่วโมง
3. **Rate Limiting**: จำกัด upload/download พร้อมกัน
4. **Path Validation**: ป้องกัน path traversal (`../`)
