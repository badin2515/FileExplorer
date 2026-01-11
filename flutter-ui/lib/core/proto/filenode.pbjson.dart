//
//  Generated code. Do not modify.
//  source: filenode.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use sortByDescriptor instead')
const SortBy$json = {
  '1': 'SortBy',
  '2': [
    {'1': 'SORT_NAME', '2': 0},
    {'1': 'SORT_SIZE', '2': 1},
    {'1': 'SORT_MODIFIED', '2': 2},
    {'1': 'SORT_TYPE', '2': 3},
  ],
};

/// Descriptor for `SortBy`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List sortByDescriptor = $convert.base64Decode(
    'CgZTb3J0QnkSDQoJU09SVF9OQU1FEAASDQoJU09SVF9TSVpFEAESEQoNU09SVF9NT0RJRklFRB'
    'ACEg0KCVNPUlRfVFlQRRAD');

@$core.Deprecated('Use sortOrderDescriptor instead')
const SortOrder$json = {
  '1': 'SortOrder',
  '2': [
    {'1': 'ASC', '2': 0},
    {'1': 'DESC', '2': 1},
  ],
};

/// Descriptor for `SortOrder`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List sortOrderDescriptor = $convert.base64Decode(
    'CglTb3J0T3JkZXISBwoDQVNDEAASCAoEREVTQxAB');

@$core.Deprecated('Use transferStatusDescriptor instead')
const TransferStatus$json = {
  '1': 'TransferStatus',
  '2': [
    {'1': 'QUEUED', '2': 0},
    {'1': 'IN_PROGRESS', '2': 1},
    {'1': 'PAUSED', '2': 2},
    {'1': 'COMPLETED', '2': 3},
    {'1': 'FAILED', '2': 4},
    {'1': 'CANCELLED', '2': 5},
  ],
};

/// Descriptor for `TransferStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List transferStatusDescriptor = $convert.base64Decode(
    'Cg5UcmFuc2ZlclN0YXR1cxIKCgZRVUVVRUQQABIPCgtJTl9QUk9HUkVTUxABEgoKBlBBVVNFRB'
    'ACEg0KCUNPTVBMRVRFRBADEgoKBkZBSUxFRBAEEg0KCUNBTkNFTExFRBAF');

@$core.Deprecated('Use previewTypeDescriptor instead')
const PreviewType$json = {
  '1': 'PreviewType',
  '2': [
    {'1': 'AUTO', '2': 0},
    {'1': 'IMAGE', '2': 1},
    {'1': 'VIDEO', '2': 2},
    {'1': 'AUDIO', '2': 3},
    {'1': 'TEXT', '2': 4},
  ],
};

/// Descriptor for `PreviewType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List previewTypeDescriptor = $convert.base64Decode(
    'CgtQcmV2aWV3VHlwZRIICgRBVVRPEAASCQoFSU1BR0UQARIJCgVWSURFTxACEgkKBUFVRElPEA'
    'MSCAoEVEVYVBAE');

@$core.Deprecated('Use fileEventTypeDescriptor instead')
const FileEventType$json = {
  '1': 'FileEventType',
  '2': [
    {'1': 'CREATED', '2': 0},
    {'1': 'MODIFIED', '2': 1},
    {'1': 'DELETED', '2': 2},
    {'1': 'RENAMED', '2': 3},
  ],
};

/// Descriptor for `FileEventType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List fileEventTypeDescriptor = $convert.base64Decode(
    'Cg1GaWxlRXZlbnRUeXBlEgsKB0NSRUFURUQQABIMCghNT0RJRklFRBABEgsKB0RFTEVURUQQAh'
    'ILCgdSRU5BTUVEEAM=');

@$core.Deprecated('Use emptyDescriptor instead')
const Empty$json = {
  '1': 'Empty',
};

/// Descriptor for `Empty`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emptyDescriptor = $convert.base64Decode(
    'CgVFbXB0eQ==');

@$core.Deprecated('Use operationResultDescriptor instead')
const OperationResult$json = {
  '1': 'OperationResult',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'error_code', '3': 3, '4': 1, '5': 9, '10': 'errorCode'},
  ],
};

/// Descriptor for `OperationResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List operationResultDescriptor = $convert.base64Decode(
    'Cg9PcGVyYXRpb25SZXN1bHQSGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCgdtZXNzYWdlGA'
    'IgASgJUgdtZXNzYWdlEh0KCmVycm9yX2NvZGUYAyABKAlSCWVycm9yQ29kZQ==');

@$core.Deprecated('Use fileEntryDescriptor instead')
const FileEntry$json = {
  '1': 'FileEntry',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'path', '3': 3, '4': 1, '5': 9, '10': 'path'},
    {'1': 'display_path', '3': 4, '4': 1, '5': 9, '10': 'displayPath'},
    {'1': 'is_dir', '3': 5, '4': 1, '5': 8, '10': 'isDir'},
    {'1': 'size', '3': 6, '4': 1, '5': 3, '10': 'size'},
    {'1': 'modified_at', '3': 7, '4': 1, '5': 3, '10': 'modifiedAt'},
    {'1': 'extension', '3': 8, '4': 1, '5': 9, '10': 'extension'},
    {'1': 'mime_type', '3': 9, '4': 1, '5': 9, '10': 'mimeType'},
    {'1': 'is_hidden', '3': 10, '4': 1, '5': 8, '10': 'isHidden'},
    {'1': 'is_readonly', '3': 11, '4': 1, '5': 8, '10': 'isReadonly'},
  ],
};

/// Descriptor for `FileEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileEntryDescriptor = $convert.base64Decode(
    'CglGaWxlRW50cnkSDgoCaWQYASABKAlSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSEgoEcGF0aB'
    'gDIAEoCVIEcGF0aBIhCgxkaXNwbGF5X3BhdGgYBCABKAlSC2Rpc3BsYXlQYXRoEhUKBmlzX2Rp'
    'chgFIAEoCFIFaXNEaXISEgoEc2l6ZRgGIAEoA1IEc2l6ZRIfCgttb2RpZmllZF9hdBgHIAEoA1'
    'IKbW9kaWZpZWRBdBIcCglleHRlbnNpb24YCCABKAlSCWV4dGVuc2lvbhIbCgltaW1lX3R5cGUY'
    'CSABKAlSCG1pbWVUeXBlEhsKCWlzX2hpZGRlbhgKIAEoCFIIaXNIaWRkZW4SHwoLaXNfcmVhZG'
    '9ubHkYCyABKAhSCmlzUmVhZG9ubHk=');

@$core.Deprecated('Use fileInfoDescriptor instead')
const FileInfo$json = {
  '1': 'FileInfo',
  '2': [
    {'1': 'entry', '3': 1, '4': 1, '5': 11, '6': '.filenode.FileEntry', '10': 'entry'},
    {'1': 'created_at', '3': 2, '4': 1, '5': 3, '10': 'createdAt'},
    {'1': 'accessed_at', '3': 3, '4': 1, '5': 3, '10': 'accessedAt'},
    {'1': 'is_locked', '3': 4, '4': 1, '5': 8, '10': 'isLocked'},
    {'1': 'locked_by', '3': 5, '4': 1, '5': 9, '10': 'lockedBy'},
    {'1': 'checksum', '3': 6, '4': 1, '5': 9, '10': 'checksum'},
  ],
};

/// Descriptor for `FileInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileInfoDescriptor = $convert.base64Decode(
    'CghGaWxlSW5mbxIpCgVlbnRyeRgBIAEoCzITLmZpbGVub2RlLkZpbGVFbnRyeVIFZW50cnkSHQ'
    'oKY3JlYXRlZF9hdBgCIAEoA1IJY3JlYXRlZEF0Eh8KC2FjY2Vzc2VkX2F0GAMgASgDUgphY2Nl'
    'c3NlZEF0EhsKCWlzX2xvY2tlZBgEIAEoCFIIaXNMb2NrZWQSGwoJbG9ja2VkX2J5GAUgASgJUg'
    'hsb2NrZWRCeRIaCghjaGVja3N1bRgGIAEoCVIIY2hlY2tzdW0=');

@$core.Deprecated('Use listDirRequestDescriptor instead')
const ListDirRequest$json = {
  '1': 'ListDirRequest',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
    {'1': 'show_hidden', '3': 2, '4': 1, '5': 8, '10': 'showHidden'},
    {'1': 'sort_by', '3': 3, '4': 1, '5': 14, '6': '.filenode.SortBy', '10': 'sortBy'},
    {'1': 'sort_order', '3': 4, '4': 1, '5': 14, '6': '.filenode.SortOrder', '10': 'sortOrder'},
    {'1': 'page_token', '3': 5, '4': 1, '5': 9, '10': 'pageToken'},
    {'1': 'page_size', '3': 6, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListDirRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDirRequestDescriptor = $convert.base64Decode(
    'Cg5MaXN0RGlyUmVxdWVzdBISCgRwYXRoGAEgASgJUgRwYXRoEh8KC3Nob3dfaGlkZGVuGAIgAS'
    'gIUgpzaG93SGlkZGVuEikKB3NvcnRfYnkYAyABKA4yEC5maWxlbm9kZS5Tb3J0QnlSBnNvcnRC'
    'eRIyCgpzb3J0X29yZGVyGAQgASgOMhMuZmlsZW5vZGUuU29ydE9yZGVyUglzb3J0T3JkZXISHQ'
    'oKcGFnZV90b2tlbhgFIAEoCVIJcGFnZVRva2VuEhsKCXBhZ2Vfc2l6ZRgGIAEoBVIIcGFnZVNp'
    'emU=');

@$core.Deprecated('Use statRequestDescriptor instead')
const StatRequest$json = {
  '1': 'StatRequest',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
  ],
};

/// Descriptor for `StatRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statRequestDescriptor = $convert.base64Decode(
    'CgtTdGF0UmVxdWVzdBISCgRwYXRoGAEgASgJUgRwYXRo');

@$core.Deprecated('Use streamFileRequestDescriptor instead')
const StreamFileRequest$json = {
  '1': 'StreamFileRequest',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
    {'1': 'offset', '3': 2, '4': 1, '5': 3, '10': 'offset'},
    {'1': 'length', '3': 3, '4': 1, '5': 3, '10': 'length'},
    {'1': 'chunk_size', '3': 4, '4': 1, '5': 5, '10': 'chunkSize'},
    {'1': 'resume_token', '3': 5, '4': 1, '5': 9, '10': 'resumeToken'},
    {'1': 'lock_id', '3': 6, '4': 1, '5': 9, '10': 'lockId'},
  ],
};

/// Descriptor for `StreamFileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamFileRequestDescriptor = $convert.base64Decode(
    'ChFTdHJlYW1GaWxlUmVxdWVzdBISCgRwYXRoGAEgASgJUgRwYXRoEhYKBm9mZnNldBgCIAEoA1'
    'IGb2Zmc2V0EhYKBmxlbmd0aBgDIAEoA1IGbGVuZ3RoEh0KCmNodW5rX3NpemUYBCABKAVSCWNo'
    'dW5rU2l6ZRIhCgxyZXN1bWVfdG9rZW4YBSABKAlSC3Jlc3VtZVRva2VuEhcKB2xvY2tfaWQYBi'
    'ABKAlSBmxvY2tJZA==');

@$core.Deprecated('Use fileChunkDescriptor instead')
const FileChunk$json = {
  '1': 'FileChunk',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
    {'1': 'offset', '3': 2, '4': 1, '5': 3, '10': 'offset'},
    {'1': 'total_size', '3': 3, '4': 1, '5': 3, '10': 'totalSize'},
    {'1': 'is_last', '3': 4, '4': 1, '5': 8, '10': 'isLast'},
    {'1': 'chunk_checksum', '3': 5, '4': 1, '5': 9, '10': 'chunkChecksum'},
    {'1': 'file_checksum', '3': 6, '4': 1, '5': 9, '10': 'fileChecksum'},
    {'1': 'resume_token', '3': 7, '4': 1, '5': 9, '10': 'resumeToken'},
  ],
};

/// Descriptor for `FileChunk`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileChunkDescriptor = $convert.base64Decode(
    'CglGaWxlQ2h1bmsSEgoEZGF0YRgBIAEoDFIEZGF0YRIWCgZvZmZzZXQYAiABKANSBm9mZnNldB'
    'IdCgp0b3RhbF9zaXplGAMgASgDUgl0b3RhbFNpemUSFwoHaXNfbGFzdBgEIAEoCFIGaXNMYXN0'
    'EiUKDmNodW5rX2NoZWNrc3VtGAUgASgJUg1jaHVua0NoZWNrc3VtEiMKDWZpbGVfY2hlY2tzdW'
    '0YBiABKAlSDGZpbGVDaGVja3N1bRIhCgxyZXN1bWVfdG9rZW4YByABKAlSC3Jlc3VtZVRva2Vu');

@$core.Deprecated('Use uploadChunkDescriptor instead')
const UploadChunk$json = {
  '1': 'UploadChunk',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
    {'1': 'total_size', '3': 2, '4': 1, '5': 3, '10': 'totalSize'},
    {'1': 'overwrite', '3': 3, '4': 1, '5': 8, '10': 'overwrite'},
    {'1': 'data', '3': 4, '4': 1, '5': 12, '10': 'data'},
    {'1': 'offset', '3': 5, '4': 1, '5': 3, '10': 'offset'},
    {'1': 'is_last', '3': 6, '4': 1, '5': 8, '10': 'isLast'},
    {'1': 'checksum', '3': 7, '4': 1, '5': 9, '10': 'checksum'},
    {'1': 'resume_token', '3': 8, '4': 1, '5': 9, '10': 'resumeToken'},
  ],
};

/// Descriptor for `UploadChunk`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadChunkDescriptor = $convert.base64Decode(
    'CgtVcGxvYWRDaHVuaxISCgRwYXRoGAEgASgJUgRwYXRoEh0KCnRvdGFsX3NpemUYAiABKANSCX'
    'RvdGFsU2l6ZRIcCglvdmVyd3JpdGUYAyABKAhSCW92ZXJ3cml0ZRISCgRkYXRhGAQgASgMUgRk'
    'YXRhEhYKBm9mZnNldBgFIAEoA1IGb2Zmc2V0EhcKB2lzX2xhc3QYBiABKAhSBmlzTGFzdBIaCg'
    'hjaGVja3N1bRgHIAEoCVIIY2hlY2tzdW0SIQoMcmVzdW1lX3Rva2VuGAggASgJUgtyZXN1bWVU'
    'b2tlbg==');

@$core.Deprecated('Use uploadResultDescriptor instead')
const UploadResult$json = {
  '1': 'UploadResult',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
    {'1': 'bytes_written', '3': 3, '4': 1, '5': 3, '10': 'bytesWritten'},
    {'1': 'file_checksum', '3': 4, '4': 1, '5': 9, '10': 'fileChecksum'},
    {'1': 'error_code', '3': 5, '4': 1, '5': 9, '10': 'errorCode'},
    {'1': 'resume_token', '3': 6, '4': 1, '5': 9, '10': 'resumeToken'},
    {'1': 'resume_offset', '3': 7, '4': 1, '5': 3, '10': 'resumeOffset'},
  ],
};

/// Descriptor for `UploadResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadResultDescriptor = $convert.base64Decode(
    'CgxVcGxvYWRSZXN1bHQSGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxISCgRwYXRoGAIgASgJUg'
    'RwYXRoEiMKDWJ5dGVzX3dyaXR0ZW4YAyABKANSDGJ5dGVzV3JpdHRlbhIjCg1maWxlX2NoZWNr'
    'c3VtGAQgASgJUgxmaWxlQ2hlY2tzdW0SHQoKZXJyb3JfY29kZRgFIAEoCVIJZXJyb3JDb2RlEi'
    'EKDHJlc3VtZV90b2tlbhgGIAEoCVILcmVzdW1lVG9rZW4SIwoNcmVzdW1lX29mZnNldBgHIAEo'
    'A1IMcmVzdW1lT2Zmc2V0');

@$core.Deprecated('Use copyRequestDescriptor instead')
const CopyRequest$json = {
  '1': 'CopyRequest',
  '2': [
    {'1': 'sources', '3': 1, '4': 3, '5': 9, '10': 'sources'},
    {'1': 'destination', '3': 2, '4': 1, '5': 9, '10': 'destination'},
    {'1': 'overwrite', '3': 3, '4': 1, '5': 8, '10': 'overwrite'},
    {'1': 'concurrent_limit', '3': 4, '4': 1, '5': 5, '10': 'concurrentLimit'},
    {'1': 'operation_id', '3': 5, '4': 1, '5': 9, '10': 'operationId'},
  ],
};

/// Descriptor for `CopyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copyRequestDescriptor = $convert.base64Decode(
    'CgtDb3B5UmVxdWVzdBIYCgdzb3VyY2VzGAEgAygJUgdzb3VyY2VzEiAKC2Rlc3RpbmF0aW9uGA'
    'IgASgJUgtkZXN0aW5hdGlvbhIcCglvdmVyd3JpdGUYAyABKAhSCW92ZXJ3cml0ZRIpChBjb25j'
    'dXJyZW50X2xpbWl0GAQgASgFUg9jb25jdXJyZW50TGltaXQSIQoMb3BlcmF0aW9uX2lkGAUgAS'
    'gJUgtvcGVyYXRpb25JZA==');

@$core.Deprecated('Use moveRequestDescriptor instead')
const MoveRequest$json = {
  '1': 'MoveRequest',
  '2': [
    {'1': 'sources', '3': 1, '4': 3, '5': 9, '10': 'sources'},
    {'1': 'destination', '3': 2, '4': 1, '5': 9, '10': 'destination'},
    {'1': 'overwrite', '3': 3, '4': 1, '5': 8, '10': 'overwrite'},
    {'1': 'operation_id', '3': 4, '4': 1, '5': 9, '10': 'operationId'},
  ],
};

/// Descriptor for `MoveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moveRequestDescriptor = $convert.base64Decode(
    'CgtNb3ZlUmVxdWVzdBIYCgdzb3VyY2VzGAEgAygJUgdzb3VyY2VzEiAKC2Rlc3RpbmF0aW9uGA'
    'IgASgJUgtkZXN0aW5hdGlvbhIcCglvdmVyd3JpdGUYAyABKAhSCW92ZXJ3cml0ZRIhCgxvcGVy'
    'YXRpb25faWQYBCABKAlSC29wZXJhdGlvbklk');

@$core.Deprecated('Use transferProgressDescriptor instead')
const TransferProgress$json = {
  '1': 'TransferProgress',
  '2': [
    {'1': 'operation_id', '3': 1, '4': 1, '5': 9, '10': 'operationId'},
    {'1': 'current_file', '3': 2, '4': 1, '5': 9, '10': 'currentFile'},
    {'1': 'current_bytes', '3': 3, '4': 1, '5': 3, '10': 'currentBytes'},
    {'1': 'current_total', '3': 4, '4': 1, '5': 3, '10': 'currentTotal'},
    {'1': 'files_completed', '3': 5, '4': 1, '5': 5, '10': 'filesCompleted'},
    {'1': 'files_total', '3': 6, '4': 1, '5': 5, '10': 'filesTotal'},
    {'1': 'bytes_completed', '3': 7, '4': 1, '5': 3, '10': 'bytesCompleted'},
    {'1': 'bytes_total', '3': 8, '4': 1, '5': 3, '10': 'bytesTotal'},
    {'1': 'percent', '3': 9, '4': 1, '5': 2, '10': 'percent'},
    {'1': 'speed_bps', '3': 10, '4': 1, '5': 3, '10': 'speedBps'},
    {'1': 'eta_seconds', '3': 11, '4': 1, '5': 5, '10': 'etaSeconds'},
    {'1': 'status', '3': 12, '4': 1, '5': 14, '6': '.filenode.TransferStatus', '10': 'status'},
    {'1': 'error', '3': 13, '4': 1, '5': 9, '10': 'error'},
    {'1': 'resume_token', '3': 14, '4': 1, '5': 9, '10': 'resumeToken'},
  ],
};

/// Descriptor for `TransferProgress`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transferProgressDescriptor = $convert.base64Decode(
    'ChBUcmFuc2ZlclByb2dyZXNzEiEKDG9wZXJhdGlvbl9pZBgBIAEoCVILb3BlcmF0aW9uSWQSIQ'
    'oMY3VycmVudF9maWxlGAIgASgJUgtjdXJyZW50RmlsZRIjCg1jdXJyZW50X2J5dGVzGAMgASgD'
    'UgxjdXJyZW50Qnl0ZXMSIwoNY3VycmVudF90b3RhbBgEIAEoA1IMY3VycmVudFRvdGFsEicKD2'
    'ZpbGVzX2NvbXBsZXRlZBgFIAEoBVIOZmlsZXNDb21wbGV0ZWQSHwoLZmlsZXNfdG90YWwYBiAB'
    'KAVSCmZpbGVzVG90YWwSJwoPYnl0ZXNfY29tcGxldGVkGAcgASgDUg5ieXRlc0NvbXBsZXRlZB'
    'IfCgtieXRlc190b3RhbBgIIAEoA1IKYnl0ZXNUb3RhbBIYCgdwZXJjZW50GAkgASgCUgdwZXJj'
    'ZW50EhsKCXNwZWVkX2JwcxgKIAEoA1IIc3BlZWRCcHMSHwoLZXRhX3NlY29uZHMYCyABKAVSCm'
    'V0YVNlY29uZHMSMAoGc3RhdHVzGAwgASgOMhguZmlsZW5vZGUuVHJhbnNmZXJTdGF0dXNSBnN0'
    'YXR1cxIUCgVlcnJvchgNIAEoCVIFZXJyb3ISIQoMcmVzdW1lX3Rva2VuGA4gASgJUgtyZXN1bW'
    'VUb2tlbg==');

@$core.Deprecated('Use cancelRequestDescriptor instead')
const CancelRequest$json = {
  '1': 'CancelRequest',
  '2': [
    {'1': 'operation_id', '3': 1, '4': 1, '5': 9, '10': 'operationId'},
  ],
};

/// Descriptor for `CancelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelRequestDescriptor = $convert.base64Decode(
    'Cg1DYW5jZWxSZXF1ZXN0EiEKDG9wZXJhdGlvbl9pZBgBIAEoCVILb3BlcmF0aW9uSWQ=');

@$core.Deprecated('Use previewRequestDescriptor instead')
const PreviewRequest$json = {
  '1': 'PreviewRequest',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
    {'1': 'type', '3': 2, '4': 1, '5': 14, '6': '.filenode.PreviewType', '10': 'type'},
    {'1': 'max_bytes', '3': 3, '4': 1, '5': 3, '10': 'maxBytes'},
    {'1': 'quality', '3': 4, '4': 1, '5': 5, '10': 'quality'},
  ],
};

/// Descriptor for `PreviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List previewRequestDescriptor = $convert.base64Decode(
    'Cg5QcmV2aWV3UmVxdWVzdBISCgRwYXRoGAEgASgJUgRwYXRoEikKBHR5cGUYAiABKA4yFS5maW'
    'xlbm9kZS5QcmV2aWV3VHlwZVIEdHlwZRIbCgltYXhfYnl0ZXMYAyABKANSCG1heEJ5dGVzEhgK'
    'B3F1YWxpdHkYBCABKAVSB3F1YWxpdHk=');

@$core.Deprecated('Use previewChunkDescriptor instead')
const PreviewChunk$json = {
  '1': 'PreviewChunk',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
    {'1': 'mime_type', '3': 2, '4': 1, '5': 9, '10': 'mimeType'},
    {'1': 'quality', '3': 3, '4': 1, '5': 5, '10': 'quality'},
    {'1': 'is_final', '3': 4, '4': 1, '5': 8, '10': 'isFinal'},
    {'1': 'width', '3': 5, '4': 1, '5': 5, '10': 'width'},
    {'1': 'height', '3': 6, '4': 1, '5': 5, '10': 'height'},
    {'1': 'duration_ms', '3': 7, '4': 1, '5': 3, '10': 'durationMs'},
  ],
};

/// Descriptor for `PreviewChunk`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List previewChunkDescriptor = $convert.base64Decode(
    'CgxQcmV2aWV3Q2h1bmsSEgoEZGF0YRgBIAEoDFIEZGF0YRIbCgltaW1lX3R5cGUYAiABKAlSCG'
    '1pbWVUeXBlEhgKB3F1YWxpdHkYAyABKAVSB3F1YWxpdHkSGQoIaXNfZmluYWwYBCABKAhSB2lz'
    'RmluYWwSFAoFd2lkdGgYBSABKAVSBXdpZHRoEhYKBmhlaWdodBgGIAEoBVIGaGVpZ2h0Eh8KC2'
    'R1cmF0aW9uX21zGAcgASgDUgpkdXJhdGlvbk1z');

@$core.Deprecated('Use thumbnailRequestDescriptor instead')
const ThumbnailRequest$json = {
  '1': 'ThumbnailRequest',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
    {'1': 'width', '3': 2, '4': 1, '5': 5, '10': 'width'},
    {'1': 'height', '3': 3, '4': 1, '5': 5, '10': 'height'},
  ],
};

/// Descriptor for `ThumbnailRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List thumbnailRequestDescriptor = $convert.base64Decode(
    'ChBUaHVtYm5haWxSZXF1ZXN0EhIKBHBhdGgYASABKAlSBHBhdGgSFAoFd2lkdGgYAiABKAVSBX'
    'dpZHRoEhYKBmhlaWdodBgDIAEoBVIGaGVpZ2h0');

@$core.Deprecated('Use thumbnailResponseDescriptor instead')
const ThumbnailResponse$json = {
  '1': 'ThumbnailResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
    {'1': 'mime_type', '3': 2, '4': 1, '5': 9, '10': 'mimeType'},
    {'1': 'width', '3': 3, '4': 1, '5': 5, '10': 'width'},
    {'1': 'height', '3': 4, '4': 1, '5': 5, '10': 'height'},
  ],
};

/// Descriptor for `ThumbnailResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List thumbnailResponseDescriptor = $convert.base64Decode(
    'ChFUaHVtYm5haWxSZXNwb25zZRISCgRkYXRhGAEgASgMUgRkYXRhEhsKCW1pbWVfdHlwZRgCIA'
    'EoCVIIbWltZVR5cGUSFAoFd2lkdGgYAyABKAVSBXdpZHRoEhYKBmhlaWdodBgEIAEoBVIGaGVp'
    'Z2h0');

@$core.Deprecated('Use createDirRequestDescriptor instead')
const CreateDirRequest$json = {
  '1': 'CreateDirRequest',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
    {'1': 'recursive', '3': 2, '4': 1, '5': 8, '10': 'recursive'},
  ],
};

/// Descriptor for `CreateDirRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createDirRequestDescriptor = $convert.base64Decode(
    'ChBDcmVhdGVEaXJSZXF1ZXN0EhIKBHBhdGgYASABKAlSBHBhdGgSHAoJcmVjdXJzaXZlGAIgAS'
    'gIUglyZWN1cnNpdmU=');

@$core.Deprecated('Use createFileRequestDescriptor instead')
const CreateFileRequest$json = {
  '1': 'CreateFileRequest',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
    {'1': 'content', '3': 2, '4': 1, '5': 12, '10': 'content'},
  ],
};

/// Descriptor for `CreateFileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createFileRequestDescriptor = $convert.base64Decode(
    'ChFDcmVhdGVGaWxlUmVxdWVzdBISCgRwYXRoGAEgASgJUgRwYXRoEhgKB2NvbnRlbnQYAiABKA'
    'xSB2NvbnRlbnQ=');

@$core.Deprecated('Use deleteRequestDescriptor instead')
const DeleteRequest$json = {
  '1': 'DeleteRequest',
  '2': [
    {'1': 'paths', '3': 1, '4': 3, '5': 9, '10': 'paths'},
    {'1': 'permanent', '3': 2, '4': 1, '5': 8, '10': 'permanent'},
  ],
};

/// Descriptor for `DeleteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteRequestDescriptor = $convert.base64Decode(
    'Cg1EZWxldGVSZXF1ZXN0EhQKBXBhdGhzGAEgAygJUgVwYXRocxIcCglwZXJtYW5lbnQYAiABKA'
    'hSCXBlcm1hbmVudA==');

@$core.Deprecated('Use renameRequestDescriptor instead')
const RenameRequest$json = {
  '1': 'RenameRequest',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
    {'1': 'new_name', '3': 2, '4': 1, '5': 9, '10': 'newName'},
  ],
};

/// Descriptor for `RenameRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List renameRequestDescriptor = $convert.base64Decode(
    'Cg1SZW5hbWVSZXF1ZXN0EhIKBHBhdGgYASABKAlSBHBhdGgSGQoIbmV3X25hbWUYAiABKAlSB2'
    '5ld05hbWU=');

@$core.Deprecated('Use watchRequestDescriptor instead')
const WatchRequest$json = {
  '1': 'WatchRequest',
  '2': [
    {'1': 'paths', '3': 1, '4': 3, '5': 9, '10': 'paths'},
    {'1': 'recursive', '3': 2, '4': 1, '5': 8, '10': 'recursive'},
  ],
};

/// Descriptor for `WatchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchRequestDescriptor = $convert.base64Decode(
    'CgxXYXRjaFJlcXVlc3QSFAoFcGF0aHMYASADKAlSBXBhdGhzEhwKCXJlY3Vyc2l2ZRgCIAEoCF'
    'IJcmVjdXJzaXZl');

@$core.Deprecated('Use fileEventDescriptor instead')
const FileEvent$json = {
  '1': 'FileEvent',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.filenode.FileEventType', '10': 'type'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
    {'1': 'old_path', '3': 3, '4': 1, '5': 9, '10': 'oldPath'},
    {'1': 'timestamp', '3': 4, '4': 1, '5': 3, '10': 'timestamp'},
  ],
};

/// Descriptor for `FileEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileEventDescriptor = $convert.base64Decode(
    'CglGaWxlRXZlbnQSKwoEdHlwZRgBIAEoDjIXLmZpbGVub2RlLkZpbGVFdmVudFR5cGVSBHR5cG'
    'USEgoEcGF0aBgCIAEoCVIEcGF0aBIZCghvbGRfcGF0aBgDIAEoCVIHb2xkUGF0aBIcCgl0aW1l'
    'c3RhbXAYBCABKANSCXRpbWVzdGFtcA==');

@$core.Deprecated('Use deviceInfoDescriptor instead')
const DeviceInfo$json = {
  '1': 'DeviceInfo',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'device_name', '3': 2, '4': 1, '5': 9, '10': 'deviceName'},
    {'1': 'platform', '3': 3, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'version', '3': 4, '4': 1, '5': 9, '10': 'version'},
    {'1': 'total_storage', '3': 5, '4': 1, '5': 3, '10': 'totalStorage'},
    {'1': 'free_storage', '3': 6, '4': 1, '5': 3, '10': 'freeStorage'},
  ],
};

/// Descriptor for `DeviceInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceInfoDescriptor = $convert.base64Decode(
    'CgpEZXZpY2VJbmZvEhsKCWRldmljZV9pZBgBIAEoCVIIZGV2aWNlSWQSHwoLZGV2aWNlX25hbW'
    'UYAiABKAlSCmRldmljZU5hbWUSGgoIcGxhdGZvcm0YAyABKAlSCHBsYXRmb3JtEhgKB3ZlcnNp'
    'b24YBCABKAlSB3ZlcnNpb24SIwoNdG90YWxfc3RvcmFnZRgFIAEoA1IMdG90YWxTdG9yYWdlEi'
    'EKDGZyZWVfc3RvcmFnZRgGIAEoA1ILZnJlZVN0b3JhZ2U=');

@$core.Deprecated('Use driveListDescriptor instead')
const DriveList$json = {
  '1': 'DriveList',
  '2': [
    {'1': 'drives', '3': 1, '4': 3, '5': 11, '6': '.filenode.DriveInfo', '10': 'drives'},
  ],
};

/// Descriptor for `DriveList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List driveListDescriptor = $convert.base64Decode(
    'CglEcml2ZUxpc3QSKwoGZHJpdmVzGAEgAygLMhMuZmlsZW5vZGUuRHJpdmVJbmZvUgZkcml2ZX'
    'M=');

@$core.Deprecated('Use driveInfoDescriptor instead')
const DriveInfo$json = {
  '1': 'DriveInfo',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
    {'1': 'label', '3': 3, '4': 1, '5': 9, '10': 'label'},
    {'1': 'total_space', '3': 4, '4': 1, '5': 3, '10': 'totalSpace'},
    {'1': 'free_space', '3': 5, '4': 1, '5': 3, '10': 'freeSpace'},
    {'1': 'is_removable', '3': 6, '4': 1, '5': 8, '10': 'isRemovable'},
  ],
};

/// Descriptor for `DriveInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List driveInfoDescriptor = $convert.base64Decode(
    'CglEcml2ZUluZm8SEgoEbmFtZRgBIAEoCVIEbmFtZRISCgRwYXRoGAIgASgJUgRwYXRoEhQKBW'
    'xhYmVsGAMgASgJUgVsYWJlbBIfCgt0b3RhbF9zcGFjZRgEIAEoA1IKdG90YWxTcGFjZRIdCgpm'
    'cmVlX3NwYWNlGAUgASgDUglmcmVlU3BhY2USIQoMaXNfcmVtb3ZhYmxlGAYgASgIUgtpc1JlbW'
    '92YWJsZQ==');

@$core.Deprecated('Use peerInfoDescriptor instead')
const PeerInfo$json = {
  '1': 'PeerInfo',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'device_name', '3': 2, '4': 1, '5': 9, '10': 'deviceName'},
    {'1': 'ip_address', '3': 3, '4': 1, '5': 9, '10': 'ipAddress'},
    {'1': 'port', '3': 4, '4': 1, '5': 5, '10': 'port'},
    {'1': 'platform', '3': 5, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'is_paired', '3': 6, '4': 1, '5': 8, '10': 'isPaired'},
  ],
};

/// Descriptor for `PeerInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List peerInfoDescriptor = $convert.base64Decode(
    'CghQZWVySW5mbxIbCglkZXZpY2VfaWQYASABKAlSCGRldmljZUlkEh8KC2RldmljZV9uYW1lGA'
    'IgASgJUgpkZXZpY2VOYW1lEh0KCmlwX2FkZHJlc3MYAyABKAlSCWlwQWRkcmVzcxISCgRwb3J0'
    'GAQgASgFUgRwb3J0EhoKCHBsYXRmb3JtGAUgASgJUghwbGF0Zm9ybRIbCglpc19wYWlyZWQYBi'
    'ABKAhSCGlzUGFpcmVk');

@$core.Deprecated('Use pairingRequestDescriptor instead')
const PairingRequest$json = {
  '1': 'PairingRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'device_name', '3': 2, '4': 1, '5': 9, '10': 'deviceName'},
    {'1': 'public_key', '3': 3, '4': 1, '5': 12, '10': 'publicKey'},
  ],
};

/// Descriptor for `PairingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pairingRequestDescriptor = $convert.base64Decode(
    'Cg5QYWlyaW5nUmVxdWVzdBIbCglkZXZpY2VfaWQYASABKAlSCGRldmljZUlkEh8KC2RldmljZV'
    '9uYW1lGAIgASgJUgpkZXZpY2VOYW1lEh0KCnB1YmxpY19rZXkYAyABKAxSCXB1YmxpY0tleQ==');

@$core.Deprecated('Use pairingChallengeDescriptor instead')
const PairingChallenge$json = {
  '1': 'PairingChallenge',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'pin_code', '3': 2, '4': 1, '5': 9, '10': 'pinCode'},
    {'1': 'expires_in', '3': 3, '4': 1, '5': 5, '10': 'expiresIn'},
  ],
};

/// Descriptor for `PairingChallenge`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pairingChallengeDescriptor = $convert.base64Decode(
    'ChBQYWlyaW5nQ2hhbGxlbmdlEh0KCnNlc3Npb25faWQYASABKAlSCXNlc3Npb25JZBIZCghwaW'
    '5fY29kZRgCIAEoCVIHcGluQ29kZRIdCgpleHBpcmVzX2luGAMgASgFUglleHBpcmVzSW4=');

@$core.Deprecated('Use pairingConfirmationDescriptor instead')
const PairingConfirmation$json = {
  '1': 'PairingConfirmation',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'pin_code', '3': 2, '4': 1, '5': 9, '10': 'pinCode'},
    {'1': 'signature', '3': 3, '4': 1, '5': 12, '10': 'signature'},
  ],
};

/// Descriptor for `PairingConfirmation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pairingConfirmationDescriptor = $convert.base64Decode(
    'ChNQYWlyaW5nQ29uZmlybWF0aW9uEh0KCnNlc3Npb25faWQYASABKAlSCXNlc3Npb25JZBIZCg'
    'hwaW5fY29kZRgCIAEoCVIHcGluQ29kZRIcCglzaWduYXR1cmUYAyABKAxSCXNpZ25hdHVyZQ==');

@$core.Deprecated('Use pairingResultDescriptor instead')
const PairingResult$json = {
  '1': 'PairingResult',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'error', '3': 2, '4': 1, '5': 9, '10': 'error'},
    {'1': 'certificate', '3': 3, '4': 1, '5': 12, '10': 'certificate'},
  ],
};

/// Descriptor for `PairingResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pairingResultDescriptor = $convert.base64Decode(
    'Cg1QYWlyaW5nUmVzdWx0EhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSFAoFZXJyb3IYAiABKA'
    'lSBWVycm9yEiAKC2NlcnRpZmljYXRlGAMgASgMUgtjZXJ0aWZpY2F0ZQ==');

