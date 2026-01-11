//
//  Generated code. Do not modify.
//  source: filenode.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'filenode.pb.dart' as $0;

export 'filenode.pb.dart';

@$pb.GrpcServiceName('filenode.FileNode')
class FileNodeClient extends $grpc.Client {
  static final _$listDir = $grpc.ClientMethod<$0.ListDirRequest, $0.FileEntry>(
      '/filenode.FileNode/ListDir',
      ($0.ListDirRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.FileEntry.fromBuffer(value));
  static final _$stat = $grpc.ClientMethod<$0.StatRequest, $0.FileInfo>(
      '/filenode.FileNode/Stat',
      ($0.StatRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.FileInfo.fromBuffer(value));
  static final _$watch = $grpc.ClientMethod<$0.WatchRequest, $0.FileEvent>(
      '/filenode.FileNode/Watch',
      ($0.WatchRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.FileEvent.fromBuffer(value));
  static final _$createDir = $grpc.ClientMethod<$0.CreateDirRequest, $0.OperationResult>(
      '/filenode.FileNode/CreateDir',
      ($0.CreateDirRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.OperationResult.fromBuffer(value));
  static final _$createFile = $grpc.ClientMethod<$0.CreateFileRequest, $0.OperationResult>(
      '/filenode.FileNode/CreateFile',
      ($0.CreateFileRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.OperationResult.fromBuffer(value));
  static final _$delete = $grpc.ClientMethod<$0.DeleteRequest, $0.OperationResult>(
      '/filenode.FileNode/Delete',
      ($0.DeleteRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.OperationResult.fromBuffer(value));
  static final _$rename = $grpc.ClientMethod<$0.RenameRequest, $0.OperationResult>(
      '/filenode.FileNode/Rename',
      ($0.RenameRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.OperationResult.fromBuffer(value));
  static final _$streamFile = $grpc.ClientMethod<$0.StreamFileRequest, $0.FileChunk>(
      '/filenode.FileNode/StreamFile',
      ($0.StreamFileRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.FileChunk.fromBuffer(value));
  static final _$uploadStream = $grpc.ClientMethod<$0.UploadChunk, $0.UploadResult>(
      '/filenode.FileNode/UploadStream',
      ($0.UploadChunk value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.UploadResult.fromBuffer(value));
  static final _$copyFiles = $grpc.ClientMethod<$0.CopyRequest, $0.TransferProgress>(
      '/filenode.FileNode/CopyFiles',
      ($0.CopyRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.TransferProgress.fromBuffer(value));
  static final _$moveFiles = $grpc.ClientMethod<$0.MoveRequest, $0.TransferProgress>(
      '/filenode.FileNode/MoveFiles',
      ($0.MoveRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.TransferProgress.fromBuffer(value));
  static final _$cancelTransfer = $grpc.ClientMethod<$0.CancelRequest, $0.OperationResult>(
      '/filenode.FileNode/CancelTransfer',
      ($0.CancelRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.OperationResult.fromBuffer(value));
  static final _$getPreview = $grpc.ClientMethod<$0.PreviewRequest, $0.PreviewChunk>(
      '/filenode.FileNode/GetPreview',
      ($0.PreviewRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.PreviewChunk.fromBuffer(value));
  static final _$getThumbnail = $grpc.ClientMethod<$0.ThumbnailRequest, $0.ThumbnailResponse>(
      '/filenode.FileNode/GetThumbnail',
      ($0.ThumbnailRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ThumbnailResponse.fromBuffer(value));
  static final _$getDeviceInfo = $grpc.ClientMethod<$0.Empty, $0.DeviceInfo>(
      '/filenode.FileNode/GetDeviceInfo',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.DeviceInfo.fromBuffer(value));
  static final _$getDrives = $grpc.ClientMethod<$0.Empty, $0.DriveList>(
      '/filenode.FileNode/GetDrives',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.DriveList.fromBuffer(value));
  static final _$discoverPeers = $grpc.ClientMethod<$0.Empty, $0.PeerInfo>(
      '/filenode.FileNode/DiscoverPeers',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.PeerInfo.fromBuffer(value));
  static final _$requestPairing = $grpc.ClientMethod<$0.PairingRequest, $0.PairingChallenge>(
      '/filenode.FileNode/RequestPairing',
      ($0.PairingRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.PairingChallenge.fromBuffer(value));
  static final _$confirmPairing = $grpc.ClientMethod<$0.PairingConfirmation, $0.PairingResult>(
      '/filenode.FileNode/ConfirmPairing',
      ($0.PairingConfirmation value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.PairingResult.fromBuffer(value));

  FileNodeClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseStream<$0.FileEntry> listDir($0.ListDirRequest request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$listDir, $async.Stream.fromIterable([request]), options: options);
  }

  $grpc.ResponseFuture<$0.FileInfo> stat($0.StatRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$stat, request, options: options);
  }

  $grpc.ResponseStream<$0.FileEvent> watch($0.WatchRequest request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$watch, $async.Stream.fromIterable([request]), options: options);
  }

  $grpc.ResponseFuture<$0.OperationResult> createDir($0.CreateDirRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createDir, request, options: options);
  }

  $grpc.ResponseFuture<$0.OperationResult> createFile($0.CreateFileRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createFile, request, options: options);
  }

  $grpc.ResponseFuture<$0.OperationResult> delete($0.DeleteRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$delete, request, options: options);
  }

  $grpc.ResponseFuture<$0.OperationResult> rename($0.RenameRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$rename, request, options: options);
  }

  $grpc.ResponseStream<$0.FileChunk> streamFile($0.StreamFileRequest request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$streamFile, $async.Stream.fromIterable([request]), options: options);
  }

  $grpc.ResponseFuture<$0.UploadResult> uploadStream($async.Stream<$0.UploadChunk> request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$uploadStream, request, options: options).single;
  }

  $grpc.ResponseStream<$0.TransferProgress> copyFiles($0.CopyRequest request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$copyFiles, $async.Stream.fromIterable([request]), options: options);
  }

  $grpc.ResponseStream<$0.TransferProgress> moveFiles($0.MoveRequest request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$moveFiles, $async.Stream.fromIterable([request]), options: options);
  }

  $grpc.ResponseFuture<$0.OperationResult> cancelTransfer($0.CancelRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$cancelTransfer, request, options: options);
  }

  $grpc.ResponseStream<$0.PreviewChunk> getPreview($0.PreviewRequest request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$getPreview, $async.Stream.fromIterable([request]), options: options);
  }

  $grpc.ResponseFuture<$0.ThumbnailResponse> getThumbnail($0.ThumbnailRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getThumbnail, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeviceInfo> getDeviceInfo($0.Empty request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getDeviceInfo, request, options: options);
  }

  $grpc.ResponseFuture<$0.DriveList> getDrives($0.Empty request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getDrives, request, options: options);
  }

  $grpc.ResponseStream<$0.PeerInfo> discoverPeers($0.Empty request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$discoverPeers, $async.Stream.fromIterable([request]), options: options);
  }

  $grpc.ResponseFuture<$0.PairingChallenge> requestPairing($0.PairingRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$requestPairing, request, options: options);
  }

  $grpc.ResponseFuture<$0.PairingResult> confirmPairing($0.PairingConfirmation request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$confirmPairing, request, options: options);
  }
}

@$pb.GrpcServiceName('filenode.FileNode')
abstract class FileNodeServiceBase extends $grpc.Service {
  $core.String get $name => 'filenode.FileNode';

  FileNodeServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ListDirRequest, $0.FileEntry>(
        'ListDir',
        listDir_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.ListDirRequest.fromBuffer(value),
        ($0.FileEntry value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StatRequest, $0.FileInfo>(
        'Stat',
        stat_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.StatRequest.fromBuffer(value),
        ($0.FileInfo value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WatchRequest, $0.FileEvent>(
        'Watch',
        watch_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.WatchRequest.fromBuffer(value),
        ($0.FileEvent value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CreateDirRequest, $0.OperationResult>(
        'CreateDir',
        createDir_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CreateDirRequest.fromBuffer(value),
        ($0.OperationResult value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CreateFileRequest, $0.OperationResult>(
        'CreateFile',
        createFile_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CreateFileRequest.fromBuffer(value),
        ($0.OperationResult value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteRequest, $0.OperationResult>(
        'Delete',
        delete_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DeleteRequest.fromBuffer(value),
        ($0.OperationResult value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RenameRequest, $0.OperationResult>(
        'Rename',
        rename_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RenameRequest.fromBuffer(value),
        ($0.OperationResult value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StreamFileRequest, $0.FileChunk>(
        'StreamFile',
        streamFile_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.StreamFileRequest.fromBuffer(value),
        ($0.FileChunk value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UploadChunk, $0.UploadResult>(
        'UploadStream',
        uploadStream,
        true,
        false,
        ($core.List<$core.int> value) => $0.UploadChunk.fromBuffer(value),
        ($0.UploadResult value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CopyRequest, $0.TransferProgress>(
        'CopyFiles',
        copyFiles_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.CopyRequest.fromBuffer(value),
        ($0.TransferProgress value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.MoveRequest, $0.TransferProgress>(
        'MoveFiles',
        moveFiles_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.MoveRequest.fromBuffer(value),
        ($0.TransferProgress value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CancelRequest, $0.OperationResult>(
        'CancelTransfer',
        cancelTransfer_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CancelRequest.fromBuffer(value),
        ($0.OperationResult value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PreviewRequest, $0.PreviewChunk>(
        'GetPreview',
        getPreview_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.PreviewRequest.fromBuffer(value),
        ($0.PreviewChunk value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ThumbnailRequest, $0.ThumbnailResponse>(
        'GetThumbnail',
        getThumbnail_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ThumbnailRequest.fromBuffer(value),
        ($0.ThumbnailResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.DeviceInfo>(
        'GetDeviceInfo',
        getDeviceInfo_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.DeviceInfo value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.DriveList>(
        'GetDrives',
        getDrives_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.DriveList value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.PeerInfo>(
        'DiscoverPeers',
        discoverPeers_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.PeerInfo value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PairingRequest, $0.PairingChallenge>(
        'RequestPairing',
        requestPairing_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.PairingRequest.fromBuffer(value),
        ($0.PairingChallenge value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PairingConfirmation, $0.PairingResult>(
        'ConfirmPairing',
        confirmPairing_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.PairingConfirmation.fromBuffer(value),
        ($0.PairingResult value) => value.writeToBuffer()));
  }

  $async.Stream<$0.FileEntry> listDir_Pre($grpc.ServiceCall call, $async.Future<$0.ListDirRequest> request) async* {
    yield* listDir(call, await request);
  }

  $async.Future<$0.FileInfo> stat_Pre($grpc.ServiceCall call, $async.Future<$0.StatRequest> request) async {
    return stat(call, await request);
  }

  $async.Stream<$0.FileEvent> watch_Pre($grpc.ServiceCall call, $async.Future<$0.WatchRequest> request) async* {
    yield* watch(call, await request);
  }

  $async.Future<$0.OperationResult> createDir_Pre($grpc.ServiceCall call, $async.Future<$0.CreateDirRequest> request) async {
    return createDir(call, await request);
  }

  $async.Future<$0.OperationResult> createFile_Pre($grpc.ServiceCall call, $async.Future<$0.CreateFileRequest> request) async {
    return createFile(call, await request);
  }

  $async.Future<$0.OperationResult> delete_Pre($grpc.ServiceCall call, $async.Future<$0.DeleteRequest> request) async {
    return delete(call, await request);
  }

  $async.Future<$0.OperationResult> rename_Pre($grpc.ServiceCall call, $async.Future<$0.RenameRequest> request) async {
    return rename(call, await request);
  }

  $async.Stream<$0.FileChunk> streamFile_Pre($grpc.ServiceCall call, $async.Future<$0.StreamFileRequest> request) async* {
    yield* streamFile(call, await request);
  }

  $async.Stream<$0.TransferProgress> copyFiles_Pre($grpc.ServiceCall call, $async.Future<$0.CopyRequest> request) async* {
    yield* copyFiles(call, await request);
  }

  $async.Stream<$0.TransferProgress> moveFiles_Pre($grpc.ServiceCall call, $async.Future<$0.MoveRequest> request) async* {
    yield* moveFiles(call, await request);
  }

  $async.Future<$0.OperationResult> cancelTransfer_Pre($grpc.ServiceCall call, $async.Future<$0.CancelRequest> request) async {
    return cancelTransfer(call, await request);
  }

  $async.Stream<$0.PreviewChunk> getPreview_Pre($grpc.ServiceCall call, $async.Future<$0.PreviewRequest> request) async* {
    yield* getPreview(call, await request);
  }

  $async.Future<$0.ThumbnailResponse> getThumbnail_Pre($grpc.ServiceCall call, $async.Future<$0.ThumbnailRequest> request) async {
    return getThumbnail(call, await request);
  }

  $async.Future<$0.DeviceInfo> getDeviceInfo_Pre($grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return getDeviceInfo(call, await request);
  }

  $async.Future<$0.DriveList> getDrives_Pre($grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return getDrives(call, await request);
  }

  $async.Stream<$0.PeerInfo> discoverPeers_Pre($grpc.ServiceCall call, $async.Future<$0.Empty> request) async* {
    yield* discoverPeers(call, await request);
  }

  $async.Future<$0.PairingChallenge> requestPairing_Pre($grpc.ServiceCall call, $async.Future<$0.PairingRequest> request) async {
    return requestPairing(call, await request);
  }

  $async.Future<$0.PairingResult> confirmPairing_Pre($grpc.ServiceCall call, $async.Future<$0.PairingConfirmation> request) async {
    return confirmPairing(call, await request);
  }

  $async.Stream<$0.FileEntry> listDir($grpc.ServiceCall call, $0.ListDirRequest request);
  $async.Future<$0.FileInfo> stat($grpc.ServiceCall call, $0.StatRequest request);
  $async.Stream<$0.FileEvent> watch($grpc.ServiceCall call, $0.WatchRequest request);
  $async.Future<$0.OperationResult> createDir($grpc.ServiceCall call, $0.CreateDirRequest request);
  $async.Future<$0.OperationResult> createFile($grpc.ServiceCall call, $0.CreateFileRequest request);
  $async.Future<$0.OperationResult> delete($grpc.ServiceCall call, $0.DeleteRequest request);
  $async.Future<$0.OperationResult> rename($grpc.ServiceCall call, $0.RenameRequest request);
  $async.Stream<$0.FileChunk> streamFile($grpc.ServiceCall call, $0.StreamFileRequest request);
  $async.Future<$0.UploadResult> uploadStream($grpc.ServiceCall call, $async.Stream<$0.UploadChunk> request);
  $async.Stream<$0.TransferProgress> copyFiles($grpc.ServiceCall call, $0.CopyRequest request);
  $async.Stream<$0.TransferProgress> moveFiles($grpc.ServiceCall call, $0.MoveRequest request);
  $async.Future<$0.OperationResult> cancelTransfer($grpc.ServiceCall call, $0.CancelRequest request);
  $async.Stream<$0.PreviewChunk> getPreview($grpc.ServiceCall call, $0.PreviewRequest request);
  $async.Future<$0.ThumbnailResponse> getThumbnail($grpc.ServiceCall call, $0.ThumbnailRequest request);
  $async.Future<$0.DeviceInfo> getDeviceInfo($grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.DriveList> getDrives($grpc.ServiceCall call, $0.Empty request);
  $async.Stream<$0.PeerInfo> discoverPeers($grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.PairingChallenge> requestPairing($grpc.ServiceCall call, $0.PairingRequest request);
  $async.Future<$0.PairingResult> confirmPairing($grpc.ServiceCall call, $0.PairingConfirmation request);
}
