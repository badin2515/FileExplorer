import 'package:grpc/grpc.dart';
import 'package:fixnum/fixnum.dart';
import '../proto/filenode.pbgrpc.dart' as grpc;
import '../proto/filenode.pb.dart';

export '../proto/filenode.pb.dart';
export '../proto/filenode.pbenum.dart';

/// gRPC client wrapper for FileNode service
class FileNodeGrpcClient {
  static FileNodeGrpcClient? _instance;
  
  late final ClientChannel _channel;
  late final grpc.FileNodeClient _stub;
  
  FileNodeGrpcClient._internal() {
    _channel = ClientChannel(
      '127.0.0.1',
      port: 50051,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );
    _stub = grpc.FileNodeClient(_channel);
  }
  
  /// Get singleton instance
  static FileNodeGrpcClient get instance {
    _instance ??= FileNodeGrpcClient._internal();
    return _instance!;
  }
  
  /// Get the gRPC client stub
  grpc.FileNodeClient get client => _stub;
  
  /// Close the channel
  Future<void> shutdown() async {
    await _channel.shutdown();
    _instance = null;
  }
  
  /// List directory contents
  Stream<FileEntry> listDir(String path, {
    bool showHidden = false,
    SortBy sortBy = SortBy.SORT_NAME,
    SortOrder sortOrder = SortOrder.ASC,
  }) {
    return _stub.listDir(ListDirRequest(
      path: path,
      showHidden: showHidden,
      sortBy: sortBy,
      sortOrder: sortOrder,
    ));
  }
  
  /// Get file/directory info
  Future<FileInfo> stat(String path) async {
    return _stub.stat(StatRequest(path: path));
  }
  
  /// Get available drives
  Future<DriveList> getDrives() async {
    return _stub.getDrives(Empty());
  }
  
  /// Get device info
  Future<DeviceInfo> getDeviceInfo() async {
    return _stub.getDeviceInfo(Empty());
  }
  
  /// Create directory
  Future<OperationResult> createDir(String path, {bool recursive = false}) async {
    return _stub.createDir(CreateDirRequest(
      path: path,
      recursive: recursive,
    ));
  }
  
  /// Create file
  Future<OperationResult> createFile(String path, {List<int>? content}) async {
    return _stub.createFile(CreateFileRequest(
      path: path,
      content: content,
    ));
  }
  
  /// Delete files/directories
  Future<OperationResult> delete(List<String> paths, {bool permanent = false}) async {
    return _stub.delete(DeleteRequest(
      paths: paths,
      permanent: permanent,
    ));
  }
  
  /// Rename file/directory
  Future<OperationResult> rename(String path, String newName) async {
    return _stub.rename(RenameRequest(
      path: path,
      newName: newName,
    ));
  }
  
  /// Stream file content
  Stream<FileChunk> streamFile(String path, {
    int offset = 0,
    int length = 0,
    int chunkSize = 262144, // 256KB
  }) {
    return _stub.streamFile(StreamFileRequest(
      path: path,
      offset: Int64(offset),
      length: Int64(length),
      chunkSize: chunkSize,
    ));
  }
}
