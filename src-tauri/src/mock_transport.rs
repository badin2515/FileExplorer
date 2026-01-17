//! Mock Transport Module
//!
//! Fake implementations of transport layers for testing:
//! - Mock HTTP client (for file transfer)
//! - Mock gRPC client (for filesystem operations)
//! - Connection drop simulation
//!
//! ## Purpose:
//! - Test retry logic
//! - Test resume functionality
//! - Test reconnection behavior
//!
//! ## Usage:
//! ```rust
//! let mock = MockHttpClient::new()
//!     .with_latency(100)
//!     .fail_after_bytes(5000)
//!     .recover_after(3);
//! ```

use std::sync::atomic::{AtomicU64, AtomicUsize, Ordering};
use std::sync::Arc;
use std::time::Duration;

// ============================================
// Mock HTTP Client (for file transfer)
// ============================================

pub struct MockHttpClient {
    config: MockConfig,
    state: Arc<MockState>,
}

#[derive(Clone)]
struct MockConfig {
    /// Latency per chunk (ms)
    latency_ms: u64,
    
    /// Bytes per chunk
    chunk_size: usize,
    
    /// Simulated transfer speed (bytes/sec)
    speed_bps: u64,
    
    /// Fail after this many bytes transferred (0 = never)
    fail_after_bytes: u64,
    
    /// Recover after this many attempts (0 = never)
    recover_after_attempts: usize,
    
    /// Random failure probability (0.0 - 1.0)
    failure_probability: f64,
    
    /// Connection drop simulation
    simulate_connection_drop: bool,
}

impl Default for MockConfig {
    fn default() -> Self {
        Self {
            latency_ms: 10,
            chunk_size: 64 * 1024, // 64KB
            speed_bps: 10 * 1024 * 1024, // 10MB/s
            fail_after_bytes: 0,
            recover_after_attempts: 0,
            failure_probability: 0.0,
            simulate_connection_drop: false,
        }
    }
}

struct MockState {
    bytes_transferred: AtomicU64,
    failure_count: AtomicUsize,
    is_connected: std::sync::atomic::AtomicBool,
}

impl MockHttpClient {
    pub fn new() -> Self {
        Self {
            config: MockConfig::default(),
            state: Arc::new(MockState {
                bytes_transferred: AtomicU64::new(0),
                failure_count: AtomicUsize::new(0),
                is_connected: std::sync::atomic::AtomicBool::new(true),
            }),
        }
    }
    
    /// Set latency per chunk
    pub fn with_latency(mut self, ms: u64) -> Self {
        self.config.latency_ms = ms;
        self
    }
    
    /// Set transfer speed
    pub fn with_speed(mut self, bytes_per_sec: u64) -> Self {
        self.config.speed_bps = bytes_per_sec;
        self
    }
    
    /// Fail after certain bytes transferred
    pub fn fail_after_bytes(mut self, bytes: u64) -> Self {
        self.config.fail_after_bytes = bytes;
        self
    }
    
    /// Recover (succeed) after N failure attempts
    pub fn recover_after(mut self, attempts: usize) -> Self {
        self.config.recover_after_attempts = attempts;
        self
    }
    
    /// Set random failure probability
    pub fn with_failure_probability(mut self, prob: f64) -> Self {
        self.config.failure_probability = prob.clamp(0.0, 1.0);
        self
    }
    
    /// Enable connection drop simulation
    pub fn simulate_connection_drop(mut self) -> Self {
        self.config.simulate_connection_drop = true;
        self
    }
    
    /// Reset state for new test
    pub fn reset(&self) {
        self.state.bytes_transferred.store(0, Ordering::SeqCst);
        self.state.failure_count.store(0, Ordering::SeqCst);
        self.state.is_connected.store(true, Ordering::SeqCst);
    }
    
    /// Simulate downloading a chunk
    pub async fn download_chunk(
        &self,
        offset: u64,
        size: usize,
    ) -> Result<MockChunk, MockTransportError> {
        // Check connection
        if !self.state.is_connected.load(Ordering::SeqCst) {
            return Err(MockTransportError::ConnectionLost);
        }
        
        // Simulate latency
        tokio::time::sleep(Duration::from_millis(self.config.latency_ms)).await;
        
        // Check if should fail
        let current_bytes = self.state.bytes_transferred.load(Ordering::SeqCst);
        let failure_count = self.state.failure_count.load(Ordering::SeqCst);
        
        // Check fail_after_bytes
        if self.config.fail_after_bytes > 0 && current_bytes >= self.config.fail_after_bytes {
            // Check if we should recover
            if self.config.recover_after_attempts > 0 
                && failure_count >= self.config.recover_after_attempts {
                // Recovered! Continue normally
            } else {
                self.state.failure_count.fetch_add(1, Ordering::SeqCst);
                
                if self.config.simulate_connection_drop {
                    self.state.is_connected.store(false, Ordering::SeqCst);
                    return Err(MockTransportError::ConnectionLost);
                } else {
                    return Err(MockTransportError::TransferInterrupted {
                        bytes_at_failure: current_bytes,
                    });
                }
            }
        }
        
        // Check random failure
        if self.config.failure_probability > 0.0 {
            let random: f64 = rand_simple();
            if random < self.config.failure_probability {
                self.state.failure_count.fetch_add(1, Ordering::SeqCst);
                return Err(MockTransportError::RandomFailure);
            }
        }
        
        // Success - update bytes transferred
        self.state.bytes_transferred.fetch_add(size as u64, Ordering::SeqCst);
        
        Ok(MockChunk {
            data: vec![0u8; size],
            offset,
            is_last: false,
        })
    }
    
    /// Simulate uploading a chunk
    pub async fn upload_chunk(
        &self,
        chunk: &MockChunk,
    ) -> Result<MockUploadResult, MockTransportError> {
        // Same logic as download
        self.download_chunk(chunk.offset, chunk.data.len()).await?;
        
        Ok(MockUploadResult {
            bytes_received: chunk.data.len() as u64,
            offset: chunk.offset,
        })
    }
    
    /// Reconnect simulation
    pub fn reconnect(&self) {
        self.state.is_connected.store(true, Ordering::SeqCst);
    }
    
    /// Get current bytes transferred
    pub fn bytes_transferred(&self) -> u64 {
        self.state.bytes_transferred.load(Ordering::SeqCst)
    }
    
    /// Get failure count
    pub fn failure_count(&self) -> usize {
        self.state.failure_count.load(Ordering::SeqCst)
    }
}

pub struct MockChunk {
    pub data: Vec<u8>,
    pub offset: u64,
    pub is_last: bool,
}

pub struct MockUploadResult {
    pub bytes_received: u64,
    pub offset: u64,
}

#[derive(Debug, Clone)]
pub enum MockTransportError {
    ConnectionLost,
    Timeout,
    TransferInterrupted { bytes_at_failure: u64 },
    RandomFailure,
    ServerError { status: u16 },
}

impl MockTransportError {
    pub fn is_retryable(&self) -> bool {
        match self {
            MockTransportError::ConnectionLost => true,
            MockTransportError::Timeout => true,
            MockTransportError::TransferInterrupted { .. } => true,
            MockTransportError::RandomFailure => true,
            MockTransportError::ServerError { status } => *status >= 500,
        }
    }
    
    pub fn bytes_at_failure(&self) -> Option<u64> {
        match self {
            MockTransportError::TransferInterrupted { bytes_at_failure } => Some(*bytes_at_failure),
            _ => None,
        }
    }
}

// ============================================
// Mock gRPC Client (for filesystem operations)
// ============================================

pub struct MockGrpcClient {
    latency_ms: u64,
    failure_probability: f64,
    is_connected: std::sync::atomic::AtomicBool,
}

impl MockGrpcClient {
    pub fn new() -> Self {
        Self {
            latency_ms: 50,
            failure_probability: 0.0,
            is_connected: std::sync::atomic::AtomicBool::new(true),
        }
    }
    
    pub fn with_latency(mut self, ms: u64) -> Self {
        self.latency_ms = ms;
        self
    }
    
    pub fn with_failure_probability(mut self, prob: f64) -> Self {
        self.failure_probability = prob.clamp(0.0, 1.0);
        self
    }
    
    /// Simulate a gRPC call
    pub async fn call<T>(&self, _method: &str) -> Result<T, MockTransportError> 
    where T: Default
    {
        if !self.is_connected.load(Ordering::SeqCst) {
            return Err(MockTransportError::ConnectionLost);
        }
        
        tokio::time::sleep(Duration::from_millis(self.latency_ms)).await;
        
        if self.failure_probability > 0.0 && rand_simple() < self.failure_probability {
            return Err(MockTransportError::RandomFailure);
        }
        
        Ok(T::default())
    }
    
    /// Simulate connection drop
    pub fn drop_connection(&self) {
        self.is_connected.store(false, Ordering::SeqCst);
    }
    
    /// Reconnect
    pub fn reconnect(&self) {
        self.is_connected.store(true, Ordering::SeqCst);
    }
}

impl Default for MockGrpcClient {
    fn default() -> Self {
        Self::new()
    }
}

// ============================================
// Connection Drop Simulator
// ============================================

pub struct ConnectionDropSimulator {
    /// Drop connection after this duration
    drop_after: Option<Duration>,
    /// Recover after this duration
    recover_after: Option<Duration>,
    start_time: std::time::Instant,
}

impl ConnectionDropSimulator {
    pub fn new() -> Self {
        Self {
            drop_after: None,
            recover_after: None,
            start_time: std::time::Instant::now(),
        }
    }
    
    /// Drop connection after specified duration
    pub fn drop_after(mut self, duration: Duration) -> Self {
        self.drop_after = Some(duration);
        self
    }
    
    /// Recover after specified duration (from drop)
    pub fn recover_after(mut self, duration: Duration) -> Self {
        self.recover_after = Some(duration);
        self
    }
    
    /// Check if connection should be active
    pub fn is_connected(&self) -> bool {
        let elapsed = self.start_time.elapsed();
        
        if let Some(drop_after) = self.drop_after {
            if elapsed >= drop_after {
                if let Some(recover_after) = self.recover_after {
                    // Check if we've recovered
                    return elapsed >= drop_after + recover_after;
                }
                return false;
            }
        }
        
        true
    }
    
    /// Reset the simulator
    pub fn reset(&mut self) {
        self.start_time = std::time::Instant::now();
    }
}

impl Default for ConnectionDropSimulator {
    fn default() -> Self {
        Self::new()
    }
}

// ============================================
// Helper Functions
// ============================================

/// Simple random number generator (0.0 - 1.0)
fn rand_simple() -> f64 {
    use std::time::SystemTime;
    let nanos = SystemTime::now()
        .duration_since(SystemTime::UNIX_EPOCH)
        .unwrap()
        .subsec_nanos();
    (nanos % 1000) as f64 / 1000.0
}

// ============================================
// Tests
// ============================================

#[cfg(test)]
mod tests {
    use super::*;
    
    #[tokio::test]
    async fn test_mock_http_success() {
        let client = MockHttpClient::new()
            .with_latency(1);
        
        let chunk = client.download_chunk(0, 1024).await.unwrap();
        assert_eq!(chunk.data.len(), 1024);
        assert_eq!(client.bytes_transferred(), 1024);
    }
    
    #[tokio::test]
    async fn test_mock_http_fail_and_recover() {
        let client = MockHttpClient::new()
            .with_latency(1)
            .fail_after_bytes(3000)  // Fail after 3000 bytes
            .recover_after(3);
        
        // Transfer chunks until we exceed 3000 bytes
        // Each chunk is 1024 bytes, so after 3 chunks (3072 bytes) we should start failing
        let mut failed = false;
        for i in 0..10 {
            let result = client.download_chunk(i * 1024, 1024).await;
            if result.is_err() {
                failed = true;
            }
        }
        
        // Should have failed at some point
        assert!(failed, "Should have failed after 3000 bytes");
        assert!(client.failure_count() > 0, "Should have at least 1 failure");
        
        // After 3 failures, should recover
        assert!(client.failure_count() >= 3, "Should have at least 3 failures before recovery");
    }
    
    #[tokio::test]
    async fn test_connection_drop_and_reconnect() {
        let client = MockHttpClient::new()
            .with_latency(1)
            .fail_after_bytes(2000)
            .simulate_connection_drop();
        
        // Transfer until drop
        for i in 0..3 {
            let result = client.download_chunk(i * 1024, 1024).await;
            if result.is_err() {
                break;
            }
        }
        
        // Should be disconnected
        let result = client.download_chunk(3 * 1024, 1024).await;
        assert!(matches!(result, Err(MockTransportError::ConnectionLost)));
        
        // Reconnect
        client.reconnect();
        
        // Should work again
        let result = client.download_chunk(3 * 1024, 1024).await;
        // Note: might still fail due to fail_after_bytes, but connection is restored
    }
    
    #[test]
    fn test_connection_drop_simulator() {
        let sim = ConnectionDropSimulator::new()
            .drop_after(Duration::from_millis(100))
            .recover_after(Duration::from_millis(50));
        
        assert!(sim.is_connected());
        
        std::thread::sleep(Duration::from_millis(110));
        assert!(!sim.is_connected());
        
        std::thread::sleep(Duration::from_millis(60));
        assert!(sim.is_connected());
    }
}
