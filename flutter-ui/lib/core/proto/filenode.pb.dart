//
//  Generated code. Do not modify.
//  source: filenode.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'filenode.pbenum.dart';

export 'filenode.pbenum.dart';

class Empty extends $pb.GeneratedMessage {
  factory Empty() => create();
  Empty._() : super();
  factory Empty.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Empty.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Empty', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Empty clone() => Empty()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Empty copyWith(void Function(Empty) updates) => super.copyWith((message) => updates(message as Empty)) as Empty;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Empty create() => Empty._();
  Empty createEmptyInstance() => create();
  static $pb.PbList<Empty> createRepeated() => $pb.PbList<Empty>();
  @$core.pragma('dart2js:noInline')
  static Empty getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Empty>(create);
  static Empty? _defaultInstance;
}

class OperationResult extends $pb.GeneratedMessage {
  factory OperationResult({
    $core.bool? success,
    $core.String? message,
    $core.String? errorCode,
  }) {
    final $result = create();
    if (success != null) {
      $result.success = success;
    }
    if (message != null) {
      $result.message = message;
    }
    if (errorCode != null) {
      $result.errorCode = errorCode;
    }
    return $result;
  }
  OperationResult._() : super();
  factory OperationResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OperationResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'OperationResult', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOS(3, _omitFieldNames ? '' : 'errorCode')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OperationResult clone() => OperationResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OperationResult copyWith(void Function(OperationResult) updates) => super.copyWith((message) => updates(message as OperationResult)) as OperationResult;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OperationResult create() => OperationResult._();
  OperationResult createEmptyInstance() => create();
  static $pb.PbList<OperationResult> createRepeated() => $pb.PbList<OperationResult>();
  @$core.pragma('dart2js:noInline')
  static OperationResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OperationResult>(create);
  static OperationResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get errorCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set errorCode($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasErrorCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearErrorCode() => clearField(3);
}

class FileEntry extends $pb.GeneratedMessage {
  factory FileEntry({
    $core.String? id,
    $core.String? name,
    $core.String? path,
    $core.String? displayPath,
    $core.bool? isDir,
    $fixnum.Int64? size,
    $fixnum.Int64? modifiedAt,
    $core.String? extension_8,
    $core.String? mimeType,
    $core.bool? isHidden,
    $core.bool? isReadonly,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (name != null) {
      $result.name = name;
    }
    if (path != null) {
      $result.path = path;
    }
    if (displayPath != null) {
      $result.displayPath = displayPath;
    }
    if (isDir != null) {
      $result.isDir = isDir;
    }
    if (size != null) {
      $result.size = size;
    }
    if (modifiedAt != null) {
      $result.modifiedAt = modifiedAt;
    }
    if (extension_8 != null) {
      $result.extension_8 = extension_8;
    }
    if (mimeType != null) {
      $result.mimeType = mimeType;
    }
    if (isHidden != null) {
      $result.isHidden = isHidden;
    }
    if (isReadonly != null) {
      $result.isReadonly = isReadonly;
    }
    return $result;
  }
  FileEntry._() : super();
  factory FileEntry.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FileEntry.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FileEntry', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'path')
    ..aOS(4, _omitFieldNames ? '' : 'displayPath')
    ..aOB(5, _omitFieldNames ? '' : 'isDir')
    ..aInt64(6, _omitFieldNames ? '' : 'size')
    ..aInt64(7, _omitFieldNames ? '' : 'modifiedAt')
    ..aOS(8, _omitFieldNames ? '' : 'extension')
    ..aOS(9, _omitFieldNames ? '' : 'mimeType')
    ..aOB(10, _omitFieldNames ? '' : 'isHidden')
    ..aOB(11, _omitFieldNames ? '' : 'isReadonly')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FileEntry clone() => FileEntry()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FileEntry copyWith(void Function(FileEntry) updates) => super.copyWith((message) => updates(message as FileEntry)) as FileEntry;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FileEntry create() => FileEntry._();
  FileEntry createEmptyInstance() => create();
  static $pb.PbList<FileEntry> createRepeated() => $pb.PbList<FileEntry>();
  @$core.pragma('dart2js:noInline')
  static FileEntry getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FileEntry>(create);
  static FileEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get path => $_getSZ(2);
  @$pb.TagNumber(3)
  set path($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPath() => $_has(2);
  @$pb.TagNumber(3)
  void clearPath() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get displayPath => $_getSZ(3);
  @$pb.TagNumber(4)
  set displayPath($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDisplayPath() => $_has(3);
  @$pb.TagNumber(4)
  void clearDisplayPath() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isDir => $_getBF(4);
  @$pb.TagNumber(5)
  set isDir($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasIsDir() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsDir() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get size => $_getI64(5);
  @$pb.TagNumber(6)
  set size($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasSize() => $_has(5);
  @$pb.TagNumber(6)
  void clearSize() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get modifiedAt => $_getI64(6);
  @$pb.TagNumber(7)
  set modifiedAt($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasModifiedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearModifiedAt() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get extension_8 => $_getSZ(7);
  @$pb.TagNumber(8)
  set extension_8($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasExtension_8() => $_has(7);
  @$pb.TagNumber(8)
  void clearExtension_8() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get mimeType => $_getSZ(8);
  @$pb.TagNumber(9)
  set mimeType($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasMimeType() => $_has(8);
  @$pb.TagNumber(9)
  void clearMimeType() => clearField(9);

  @$pb.TagNumber(10)
  $core.bool get isHidden => $_getBF(9);
  @$pb.TagNumber(10)
  set isHidden($core.bool v) { $_setBool(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasIsHidden() => $_has(9);
  @$pb.TagNumber(10)
  void clearIsHidden() => clearField(10);

  @$pb.TagNumber(11)
  $core.bool get isReadonly => $_getBF(10);
  @$pb.TagNumber(11)
  set isReadonly($core.bool v) { $_setBool(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasIsReadonly() => $_has(10);
  @$pb.TagNumber(11)
  void clearIsReadonly() => clearField(11);
}

class FileInfo extends $pb.GeneratedMessage {
  factory FileInfo({
    FileEntry? entry,
    $fixnum.Int64? createdAt,
    $fixnum.Int64? accessedAt,
    $core.bool? isLocked,
    $core.String? lockedBy,
    $core.String? checksum,
  }) {
    final $result = create();
    if (entry != null) {
      $result.entry = entry;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (accessedAt != null) {
      $result.accessedAt = accessedAt;
    }
    if (isLocked != null) {
      $result.isLocked = isLocked;
    }
    if (lockedBy != null) {
      $result.lockedBy = lockedBy;
    }
    if (checksum != null) {
      $result.checksum = checksum;
    }
    return $result;
  }
  FileInfo._() : super();
  factory FileInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FileInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FileInfo', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..aOM<FileEntry>(1, _omitFieldNames ? '' : 'entry', subBuilder: FileEntry.create)
    ..aInt64(2, _omitFieldNames ? '' : 'createdAt')
    ..aInt64(3, _omitFieldNames ? '' : 'accessedAt')
    ..aOB(4, _omitFieldNames ? '' : 'isLocked')
    ..aOS(5, _omitFieldNames ? '' : 'lockedBy')
    ..aOS(6, _omitFieldNames ? '' : 'checksum')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FileInfo clone() => FileInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FileInfo copyWith(void Function(FileInfo) updates) => super.copyWith((message) => updates(message as FileInfo)) as FileInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FileInfo create() => FileInfo._();
  FileInfo createEmptyInstance() => create();
  static $pb.PbList<FileInfo> createRepeated() => $pb.PbList<FileInfo>();
  @$core.pragma('dart2js:noInline')
  static FileInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FileInfo>(create);
  static FileInfo? _defaultInstance;

  @$pb.TagNumber(1)
  FileEntry get entry => $_getN(0);
  @$pb.TagNumber(1)
  set entry(FileEntry v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasEntry() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntry() => clearField(1);
  @$pb.TagNumber(1)
  FileEntry ensureEntry() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get createdAt => $_getI64(1);
  @$pb.TagNumber(2)
  set createdAt($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCreatedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreatedAt() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get accessedAt => $_getI64(2);
  @$pb.TagNumber(3)
  set accessedAt($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAccessedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearAccessedAt() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isLocked => $_getBF(3);
  @$pb.TagNumber(4)
  set isLocked($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasIsLocked() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsLocked() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get lockedBy => $_getSZ(4);
  @$pb.TagNumber(5)
  set lockedBy($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasLockedBy() => $_has(4);
  @$pb.TagNumber(5)
  void clearLockedBy() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get checksum => $_getSZ(5);
  @$pb.TagNumber(6)
  set checksum($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasChecksum() => $_has(5);
  @$pb.TagNumber(6)
  void clearChecksum() => clearField(6);
}

class ListDirRequest extends $pb.GeneratedMessage {
  factory ListDirRequest({
    $core.String? path,
    $core.bool? showHidden,
    SortBy? sortBy,
    SortOrder? sortOrder,
    $core.String? pageToken,
    $core.int? pageSize,
  }) {
    final $result = create();
    if (path != null) {
      $result.path = path;
    }
    if (showHidden != null) {
      $result.showHidden = showHidden;
    }
    if (sortBy != null) {
      $result.sortBy = sortBy;
    }
    if (sortOrder != null) {
      $result.sortOrder = sortOrder;
    }
    if (pageToken != null) {
      $result.pageToken = pageToken;
    }
    if (pageSize != null) {
      $result.pageSize = pageSize;
    }
    return $result;
  }
  ListDirRequest._() : super();
  factory ListDirRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListDirRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListDirRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..aOB(2, _omitFieldNames ? '' : 'showHidden')
    ..e<SortBy>(3, _omitFieldNames ? '' : 'sortBy', $pb.PbFieldType.OE, defaultOrMaker: SortBy.SORT_NAME, valueOf: SortBy.valueOf, enumValues: SortBy.values)
    ..e<SortOrder>(4, _omitFieldNames ? '' : 'sortOrder', $pb.PbFieldType.OE, defaultOrMaker: SortOrder.ASC, valueOf: SortOrder.valueOf, enumValues: SortOrder.values)
    ..aOS(5, _omitFieldNames ? '' : 'pageToken')
    ..a<$core.int>(6, _omitFieldNames ? '' : 'pageSize', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListDirRequest clone() => ListDirRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListDirRequest copyWith(void Function(ListDirRequest) updates) => super.copyWith((message) => updates(message as ListDirRequest)) as ListDirRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDirRequest create() => ListDirRequest._();
  ListDirRequest createEmptyInstance() => create();
  static $pb.PbList<ListDirRequest> createRepeated() => $pb.PbList<ListDirRequest>();
  @$core.pragma('dart2js:noInline')
  static ListDirRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListDirRequest>(create);
  static ListDirRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get showHidden => $_getBF(1);
  @$pb.TagNumber(2)
  set showHidden($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasShowHidden() => $_has(1);
  @$pb.TagNumber(2)
  void clearShowHidden() => clearField(2);

  @$pb.TagNumber(3)
  SortBy get sortBy => $_getN(2);
  @$pb.TagNumber(3)
  set sortBy(SortBy v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSortBy() => $_has(2);
  @$pb.TagNumber(3)
  void clearSortBy() => clearField(3);

  @$pb.TagNumber(4)
  SortOrder get sortOrder => $_getN(3);
  @$pb.TagNumber(4)
  set sortOrder(SortOrder v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasSortOrder() => $_has(3);
  @$pb.TagNumber(4)
  void clearSortOrder() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get pageToken => $_getSZ(4);
  @$pb.TagNumber(5)
  set pageToken($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPageToken() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageToken() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get pageSize => $_getIZ(5);
  @$pb.TagNumber(6)
  set pageSize($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPageSize() => $_has(5);
  @$pb.TagNumber(6)
  void clearPageSize() => clearField(6);
}

class StatRequest extends $pb.GeneratedMessage {
  factory StatRequest({
    $core.String? path,
  }) {
    final $result = create();
    if (path != null) {
      $result.path = path;
    }
    return $result;
  }
  StatRequest._() : super();
  factory StatRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StatRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'StatRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StatRequest clone() => StatRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StatRequest copyWith(void Function(StatRequest) updates) => super.copyWith((message) => updates(message as StatRequest)) as StatRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StatRequest create() => StatRequest._();
  StatRequest createEmptyInstance() => create();
  static $pb.PbList<StatRequest> createRepeated() => $pb.PbList<StatRequest>();
  @$core.pragma('dart2js:noInline')
  static StatRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StatRequest>(create);
  static StatRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => clearField(1);
}

class StreamFileRequest extends $pb.GeneratedMessage {
  factory StreamFileRequest({
    $core.String? path,
    $fixnum.Int64? offset,
    $fixnum.Int64? length,
    $core.int? chunkSize,
    $core.String? resumeToken,
    $core.String? lockId,
  }) {
    final $result = create();
    if (path != null) {
      $result.path = path;
    }
    if (offset != null) {
      $result.offset = offset;
    }
    if (length != null) {
      $result.length = length;
    }
    if (chunkSize != null) {
      $result.chunkSize = chunkSize;
    }
    if (resumeToken != null) {
      $result.resumeToken = resumeToken;
    }
    if (lockId != null) {
      $result.lockId = lockId;
    }
    return $result;
  }
  StreamFileRequest._() : super();
  factory StreamFileRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StreamFileRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'StreamFileRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..aInt64(2, _omitFieldNames ? '' : 'offset')
    ..aInt64(3, _omitFieldNames ? '' : 'length')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'chunkSize', $pb.PbFieldType.O3)
    ..aOS(5, _omitFieldNames ? '' : 'resumeToken')
    ..aOS(6, _omitFieldNames ? '' : 'lockId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StreamFileRequest clone() => StreamFileRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StreamFileRequest copyWith(void Function(StreamFileRequest) updates) => super.copyWith((message) => updates(message as StreamFileRequest)) as StreamFileRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StreamFileRequest create() => StreamFileRequest._();
  StreamFileRequest createEmptyInstance() => create();
  static $pb.PbList<StreamFileRequest> createRepeated() => $pb.PbList<StreamFileRequest>();
  @$core.pragma('dart2js:noInline')
  static StreamFileRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StreamFileRequest>(create);
  static StreamFileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get offset => $_getI64(1);
  @$pb.TagNumber(2)
  set offset($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearOffset() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get length => $_getI64(2);
  @$pb.TagNumber(3)
  set length($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLength() => $_has(2);
  @$pb.TagNumber(3)
  void clearLength() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get chunkSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set chunkSize($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasChunkSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearChunkSize() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get resumeToken => $_getSZ(4);
  @$pb.TagNumber(5)
  set resumeToken($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasResumeToken() => $_has(4);
  @$pb.TagNumber(5)
  void clearResumeToken() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get lockId => $_getSZ(5);
  @$pb.TagNumber(6)
  set lockId($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasLockId() => $_has(5);
  @$pb.TagNumber(6)
  void clearLockId() => clearField(6);
}

class FileChunk extends $pb.GeneratedMessage {
  factory FileChunk({
    $core.List<$core.int>? data,
    $fixnum.Int64? offset,
    $fixnum.Int64? totalSize,
    $core.bool? isLast,
    $core.String? chunkChecksum,
    $core.String? fileChecksum,
    $core.String? resumeToken,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    if (offset != null) {
      $result.offset = offset;
    }
    if (totalSize != null) {
      $result.totalSize = totalSize;
    }
    if (isLast != null) {
      $result.isLast = isLast;
    }
    if (chunkChecksum != null) {
      $result.chunkChecksum = chunkChecksum;
    }
    if (fileChecksum != null) {
      $result.fileChecksum = fileChecksum;
    }
    if (resumeToken != null) {
      $result.resumeToken = resumeToken;
    }
    return $result;
  }
  FileChunk._() : super();
  factory FileChunk.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FileChunk.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FileChunk', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..aInt64(2, _omitFieldNames ? '' : 'offset')
    ..aInt64(3, _omitFieldNames ? '' : 'totalSize')
    ..aOB(4, _omitFieldNames ? '' : 'isLast')
    ..aOS(5, _omitFieldNames ? '' : 'chunkChecksum')
    ..aOS(6, _omitFieldNames ? '' : 'fileChecksum')
    ..aOS(7, _omitFieldNames ? '' : 'resumeToken')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FileChunk clone() => FileChunk()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FileChunk copyWith(void Function(FileChunk) updates) => super.copyWith((message) => updates(message as FileChunk)) as FileChunk;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FileChunk create() => FileChunk._();
  FileChunk createEmptyInstance() => create();
  static $pb.PbList<FileChunk> createRepeated() => $pb.PbList<FileChunk>();
  @$core.pragma('dart2js:noInline')
  static FileChunk getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FileChunk>(create);
  static FileChunk? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get offset => $_getI64(1);
  @$pb.TagNumber(2)
  set offset($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearOffset() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get totalSize => $_getI64(2);
  @$pb.TagNumber(3)
  set totalSize($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTotalSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalSize() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isLast => $_getBF(3);
  @$pb.TagNumber(4)
  set isLast($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasIsLast() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsLast() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get chunkChecksum => $_getSZ(4);
  @$pb.TagNumber(5)
  set chunkChecksum($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasChunkChecksum() => $_has(4);
  @$pb.TagNumber(5)
  void clearChunkChecksum() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get fileChecksum => $_getSZ(5);
  @$pb.TagNumber(6)
  set fileChecksum($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasFileChecksum() => $_has(5);
  @$pb.TagNumber(6)
  void clearFileChecksum() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get resumeToken => $_getSZ(6);
  @$pb.TagNumber(7)
  set resumeToken($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasResumeToken() => $_has(6);
  @$pb.TagNumber(7)
  void clearResumeToken() => clearField(7);
}

class UploadChunk extends $pb.GeneratedMessage {
  factory UploadChunk({
    $core.String? path,
    $fixnum.Int64? totalSize,
    $core.bool? overwrite,
    $core.List<$core.int>? data,
    $fixnum.Int64? offset,
    $core.bool? isLast,
    $core.String? checksum,
    $core.String? resumeToken,
  }) {
    final $result = create();
    if (path != null) {
      $result.path = path;
    }
    if (totalSize != null) {
      $result.totalSize = totalSize;
    }
    if (overwrite != null) {
      $result.overwrite = overwrite;
    }
    if (data != null) {
      $result.data = data;
    }
    if (offset != null) {
      $result.offset = offset;
    }
    if (isLast != null) {
      $result.isLast = isLast;
    }
    if (checksum != null) {
      $result.checksum = checksum;
    }
    if (resumeToken != null) {
      $result.resumeToken = resumeToken;
    }
    return $result;
  }
  UploadChunk._() : super();
  factory UploadChunk.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UploadChunk.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UploadChunk', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..aInt64(2, _omitFieldNames ? '' : 'totalSize')
    ..aOB(3, _omitFieldNames ? '' : 'overwrite')
    ..a<$core.List<$core.int>>(4, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..aInt64(5, _omitFieldNames ? '' : 'offset')
    ..aOB(6, _omitFieldNames ? '' : 'isLast')
    ..aOS(7, _omitFieldNames ? '' : 'checksum')
    ..aOS(8, _omitFieldNames ? '' : 'resumeToken')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UploadChunk clone() => UploadChunk()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UploadChunk copyWith(void Function(UploadChunk) updates) => super.copyWith((message) => updates(message as UploadChunk)) as UploadChunk;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UploadChunk create() => UploadChunk._();
  UploadChunk createEmptyInstance() => create();
  static $pb.PbList<UploadChunk> createRepeated() => $pb.PbList<UploadChunk>();
  @$core.pragma('dart2js:noInline')
  static UploadChunk getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UploadChunk>(create);
  static UploadChunk? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get totalSize => $_getI64(1);
  @$pb.TagNumber(2)
  set totalSize($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTotalSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalSize() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get overwrite => $_getBF(2);
  @$pb.TagNumber(3)
  set overwrite($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasOverwrite() => $_has(2);
  @$pb.TagNumber(3)
  void clearOverwrite() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get data => $_getN(3);
  @$pb.TagNumber(4)
  set data($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasData() => $_has(3);
  @$pb.TagNumber(4)
  void clearData() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get offset => $_getI64(4);
  @$pb.TagNumber(5)
  set offset($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasOffset() => $_has(4);
  @$pb.TagNumber(5)
  void clearOffset() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isLast => $_getBF(5);
  @$pb.TagNumber(6)
  set isLast($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasIsLast() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsLast() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get checksum => $_getSZ(6);
  @$pb.TagNumber(7)
  set checksum($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasChecksum() => $_has(6);
  @$pb.TagNumber(7)
  void clearChecksum() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get resumeToken => $_getSZ(7);
  @$pb.TagNumber(8)
  set resumeToken($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasResumeToken() => $_has(7);
  @$pb.TagNumber(8)
  void clearResumeToken() => clearField(8);
}

class UploadResult extends $pb.GeneratedMessage {
  factory UploadResult({
    $core.bool? success,
    $core.String? path,
    $fixnum.Int64? bytesWritten,
    $core.String? fileChecksum,
    $core.String? errorCode,
    $core.String? resumeToken,
    $fixnum.Int64? resumeOffset,
  }) {
    final $result = create();
    if (success != null) {
      $result.success = success;
    }
    if (path != null) {
      $result.path = path;
    }
    if (bytesWritten != null) {
      $result.bytesWritten = bytesWritten;
    }
    if (fileChecksum != null) {
      $result.fileChecksum = fileChecksum;
    }
    if (errorCode != null) {
      $result.errorCode = errorCode;
    }
    if (resumeToken != null) {
      $result.resumeToken = resumeToken;
    }
    if (resumeOffset != null) {
      $result.resumeOffset = resumeOffset;
    }
    return $result;
  }
  UploadResult._() : super();
  factory UploadResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UploadResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UploadResult', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'path')
    ..aInt64(3, _omitFieldNames ? '' : 'bytesWritten')
    ..aOS(4, _omitFieldNames ? '' : 'fileChecksum')
    ..aOS(5, _omitFieldNames ? '' : 'errorCode')
    ..aOS(6, _omitFieldNames ? '' : 'resumeToken')
    ..aInt64(7, _omitFieldNames ? '' : 'resumeOffset')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UploadResult clone() => UploadResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UploadResult copyWith(void Function(UploadResult) updates) => super.copyWith((message) => updates(message as UploadResult)) as UploadResult;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UploadResult create() => UploadResult._();
  UploadResult createEmptyInstance() => create();
  static $pb.PbList<UploadResult> createRepeated() => $pb.PbList<UploadResult>();
  @$core.pragma('dart2js:noInline')
  static UploadResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UploadResult>(create);
  static UploadResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get bytesWritten => $_getI64(2);
  @$pb.TagNumber(3)
  set bytesWritten($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasBytesWritten() => $_has(2);
  @$pb.TagNumber(3)
  void clearBytesWritten() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get fileChecksum => $_getSZ(3);
  @$pb.TagNumber(4)
  set fileChecksum($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasFileChecksum() => $_has(3);
  @$pb.TagNumber(4)
  void clearFileChecksum() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get errorCode => $_getSZ(4);
  @$pb.TagNumber(5)
  set errorCode($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasErrorCode() => $_has(4);
  @$pb.TagNumber(5)
  void clearErrorCode() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get resumeToken => $_getSZ(5);
  @$pb.TagNumber(6)
  set resumeToken($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasResumeToken() => $_has(5);
  @$pb.TagNumber(6)
  void clearResumeToken() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get resumeOffset => $_getI64(6);
  @$pb.TagNumber(7)
  set resumeOffset($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasResumeOffset() => $_has(6);
  @$pb.TagNumber(7)
  void clearResumeOffset() => clearField(7);
}

class CopyRequest extends $pb.GeneratedMessage {
  factory CopyRequest({
    $core.Iterable<$core.String>? sources,
    $core.String? destination,
    $core.bool? overwrite,
    $core.int? concurrentLimit,
    $core.String? operationId,
  }) {
    final $result = create();
    if (sources != null) {
      $result.sources.addAll(sources);
    }
    if (destination != null) {
      $result.destination = destination;
    }
    if (overwrite != null) {
      $result.overwrite = overwrite;
    }
    if (concurrentLimit != null) {
      $result.concurrentLimit = concurrentLimit;
    }
    if (operationId != null) {
      $result.operationId = operationId;
    }
    return $result;
  }
  CopyRequest._() : super();
  factory CopyRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CopyRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CopyRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'sources')
    ..aOS(2, _omitFieldNames ? '' : 'destination')
    ..aOB(3, _omitFieldNames ? '' : 'overwrite')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'concurrentLimit', $pb.PbFieldType.O3)
    ..aOS(5, _omitFieldNames ? '' : 'operationId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CopyRequest clone() => CopyRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CopyRequest copyWith(void Function(CopyRequest) updates) => super.copyWith((message) => updates(message as CopyRequest)) as CopyRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CopyRequest create() => CopyRequest._();
  CopyRequest createEmptyInstance() => create();
  static $pb.PbList<CopyRequest> createRepeated() => $pb.PbList<CopyRequest>();
  @$core.pragma('dart2js:noInline')
  static CopyRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CopyRequest>(create);
  static CopyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get sources => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get destination => $_getSZ(1);
  @$pb.TagNumber(2)
  set destination($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDestination() => $_has(1);
  @$pb.TagNumber(2)
  void clearDestination() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get overwrite => $_getBF(2);
  @$pb.TagNumber(3)
  set overwrite($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasOverwrite() => $_has(2);
  @$pb.TagNumber(3)
  void clearOverwrite() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get concurrentLimit => $_getIZ(3);
  @$pb.TagNumber(4)
  set concurrentLimit($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasConcurrentLimit() => $_has(3);
  @$pb.TagNumber(4)
  void clearConcurrentLimit() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get operationId => $_getSZ(4);
  @$pb.TagNumber(5)
  set operationId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasOperationId() => $_has(4);
  @$pb.TagNumber(5)
  void clearOperationId() => clearField(5);
}

class MoveRequest extends $pb.GeneratedMessage {
  factory MoveRequest({
    $core.Iterable<$core.String>? sources,
    $core.String? destination,
    $core.bool? overwrite,
    $core.String? operationId,
  }) {
    final $result = create();
    if (sources != null) {
      $result.sources.addAll(sources);
    }
    if (destination != null) {
      $result.destination = destination;
    }
    if (overwrite != null) {
      $result.overwrite = overwrite;
    }
    if (operationId != null) {
      $result.operationId = operationId;
    }
    return $result;
  }
  MoveRequest._() : super();
  factory MoveRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MoveRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MoveRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'sources')
    ..aOS(2, _omitFieldNames ? '' : 'destination')
    ..aOB(3, _omitFieldNames ? '' : 'overwrite')
    ..aOS(4, _omitFieldNames ? '' : 'operationId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MoveRequest clone() => MoveRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MoveRequest copyWith(void Function(MoveRequest) updates) => super.copyWith((message) => updates(message as MoveRequest)) as MoveRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MoveRequest create() => MoveRequest._();
  MoveRequest createEmptyInstance() => create();
  static $pb.PbList<MoveRequest> createRepeated() => $pb.PbList<MoveRequest>();
  @$core.pragma('dart2js:noInline')
  static MoveRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MoveRequest>(create);
  static MoveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get sources => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get destination => $_getSZ(1);
  @$pb.TagNumber(2)
  set destination($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDestination() => $_has(1);
  @$pb.TagNumber(2)
  void clearDestination() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get overwrite => $_getBF(2);
  @$pb.TagNumber(3)
  set overwrite($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasOverwrite() => $_has(2);
  @$pb.TagNumber(3)
  void clearOverwrite() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get operationId => $_getSZ(3);
  @$pb.TagNumber(4)
  set operationId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasOperationId() => $_has(3);
  @$pb.TagNumber(4)
  void clearOperationId() => clearField(4);
}

class TransferProgress extends $pb.GeneratedMessage {
  factory TransferProgress({
    $core.String? operationId,
    $core.String? currentFile,
    $fixnum.Int64? currentBytes,
    $fixnum.Int64? currentTotal,
    $core.int? filesCompleted,
    $core.int? filesTotal,
    $fixnum.Int64? bytesCompleted,
    $fixnum.Int64? bytesTotal,
    $core.double? percent,
    $fixnum.Int64? speedBps,
    $core.int? etaSeconds,
    TransferStatus? status,
    $core.String? error,
    $core.String? resumeToken,
  }) {
    final $result = create();
    if (operationId != null) {
      $result.operationId = operationId;
    }
    if (currentFile != null) {
      $result.currentFile = currentFile;
    }
    if (currentBytes != null) {
      $result.currentBytes = currentBytes;
    }
    if (currentTotal != null) {
      $result.currentTotal = currentTotal;
    }
    if (filesCompleted != null) {
      $result.filesCompleted = filesCompleted;
    }
    if (filesTotal != null) {
      $result.filesTotal = filesTotal;
    }
    if (bytesCompleted != null) {
      $result.bytesCompleted = bytesCompleted;
    }
    if (bytesTotal != null) {
      $result.bytesTotal = bytesTotal;
    }
    if (percent != null) {
      $result.percent = percent;
    }
    if (speedBps != null) {
      $result.speedBps = speedBps;
    }
    if (etaSeconds != null) {
      $result.etaSeconds = etaSeconds;
    }
    if (status != null) {
      $result.status = status;
    }
    if (error != null) {
      $result.error = error;
    }
    if (resumeToken != null) {
      $result.resumeToken = resumeToken;
    }
    return $result;
  }
  TransferProgress._() : super();
  factory TransferProgress.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TransferProgress.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TransferProgress', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'operationId')
    ..aOS(2, _omitFieldNames ? '' : 'currentFile')
    ..aInt64(3, _omitFieldNames ? '' : 'currentBytes')
    ..aInt64(4, _omitFieldNames ? '' : 'currentTotal')
    ..a<$core.int>(5, _omitFieldNames ? '' : 'filesCompleted', $pb.PbFieldType.O3)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'filesTotal', $pb.PbFieldType.O3)
    ..aInt64(7, _omitFieldNames ? '' : 'bytesCompleted')
    ..aInt64(8, _omitFieldNames ? '' : 'bytesTotal')
    ..a<$core.double>(9, _omitFieldNames ? '' : 'percent', $pb.PbFieldType.OF)
    ..aInt64(10, _omitFieldNames ? '' : 'speedBps')
    ..a<$core.int>(11, _omitFieldNames ? '' : 'etaSeconds', $pb.PbFieldType.O3)
    ..e<TransferStatus>(12, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: TransferStatus.QUEUED, valueOf: TransferStatus.valueOf, enumValues: TransferStatus.values)
    ..aOS(13, _omitFieldNames ? '' : 'error')
    ..aOS(14, _omitFieldNames ? '' : 'resumeToken')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TransferProgress clone() => TransferProgress()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TransferProgress copyWith(void Function(TransferProgress) updates) => super.copyWith((message) => updates(message as TransferProgress)) as TransferProgress;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransferProgress create() => TransferProgress._();
  TransferProgress createEmptyInstance() => create();
  static $pb.PbList<TransferProgress> createRepeated() => $pb.PbList<TransferProgress>();
  @$core.pragma('dart2js:noInline')
  static TransferProgress getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TransferProgress>(create);
  static TransferProgress? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get operationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set operationId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOperationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOperationId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get currentFile => $_getSZ(1);
  @$pb.TagNumber(2)
  set currentFile($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCurrentFile() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrentFile() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get currentBytes => $_getI64(2);
  @$pb.TagNumber(3)
  set currentBytes($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCurrentBytes() => $_has(2);
  @$pb.TagNumber(3)
  void clearCurrentBytes() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get currentTotal => $_getI64(3);
  @$pb.TagNumber(4)
  set currentTotal($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCurrentTotal() => $_has(3);
  @$pb.TagNumber(4)
  void clearCurrentTotal() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get filesCompleted => $_getIZ(4);
  @$pb.TagNumber(5)
  set filesCompleted($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasFilesCompleted() => $_has(4);
  @$pb.TagNumber(5)
  void clearFilesCompleted() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get filesTotal => $_getIZ(5);
  @$pb.TagNumber(6)
  set filesTotal($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasFilesTotal() => $_has(5);
  @$pb.TagNumber(6)
  void clearFilesTotal() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get bytesCompleted => $_getI64(6);
  @$pb.TagNumber(7)
  set bytesCompleted($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasBytesCompleted() => $_has(6);
  @$pb.TagNumber(7)
  void clearBytesCompleted() => clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get bytesTotal => $_getI64(7);
  @$pb.TagNumber(8)
  set bytesTotal($fixnum.Int64 v) { $_setInt64(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasBytesTotal() => $_has(7);
  @$pb.TagNumber(8)
  void clearBytesTotal() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get percent => $_getN(8);
  @$pb.TagNumber(9)
  set percent($core.double v) { $_setFloat(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasPercent() => $_has(8);
  @$pb.TagNumber(9)
  void clearPercent() => clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get speedBps => $_getI64(9);
  @$pb.TagNumber(10)
  set speedBps($fixnum.Int64 v) { $_setInt64(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasSpeedBps() => $_has(9);
  @$pb.TagNumber(10)
  void clearSpeedBps() => clearField(10);

  @$pb.TagNumber(11)
  $core.int get etaSeconds => $_getIZ(10);
  @$pb.TagNumber(11)
  set etaSeconds($core.int v) { $_setSignedInt32(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasEtaSeconds() => $_has(10);
  @$pb.TagNumber(11)
  void clearEtaSeconds() => clearField(11);

  @$pb.TagNumber(12)
  TransferStatus get status => $_getN(11);
  @$pb.TagNumber(12)
  set status(TransferStatus v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasStatus() => $_has(11);
  @$pb.TagNumber(12)
  void clearStatus() => clearField(12);

  @$pb.TagNumber(13)
  $core.String get error => $_getSZ(12);
  @$pb.TagNumber(13)
  set error($core.String v) { $_setString(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasError() => $_has(12);
  @$pb.TagNumber(13)
  void clearError() => clearField(13);

  @$pb.TagNumber(14)
  $core.String get resumeToken => $_getSZ(13);
  @$pb.TagNumber(14)
  set resumeToken($core.String v) { $_setString(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasResumeToken() => $_has(13);
  @$pb.TagNumber(14)
  void clearResumeToken() => clearField(14);
}

class CancelRequest extends $pb.GeneratedMessage {
  factory CancelRequest({
    $core.String? operationId,
  }) {
    final $result = create();
    if (operationId != null) {
      $result.operationId = operationId;
    }
    return $result;
  }
  CancelRequest._() : super();
  factory CancelRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CancelRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CancelRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'operationId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CancelRequest clone() => CancelRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CancelRequest copyWith(void Function(CancelRequest) updates) => super.copyWith((message) => updates(message as CancelRequest)) as CancelRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelRequest create() => CancelRequest._();
  CancelRequest createEmptyInstance() => create();
  static $pb.PbList<CancelRequest> createRepeated() => $pb.PbList<CancelRequest>();
  @$core.pragma('dart2js:noInline')
  static CancelRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CancelRequest>(create);
  static CancelRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get operationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set operationId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOperationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOperationId() => clearField(1);
}

class PreviewRequest extends $pb.GeneratedMessage {
  factory PreviewRequest({
    $core.String? path,
    PreviewType? type,
    $fixnum.Int64? maxBytes,
    $core.int? quality,
  }) {
    final $result = create();
    if (path != null) {
      $result.path = path;
    }
    if (type != null) {
      $result.type = type;
    }
    if (maxBytes != null) {
      $result.maxBytes = maxBytes;
    }
    if (quality != null) {
      $result.quality = quality;
    }
    return $result;
  }
  PreviewRequest._() : super();
  factory PreviewRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PreviewRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PreviewRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..e<PreviewType>(2, _omitFieldNames ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: PreviewType.AUTO, valueOf: PreviewType.valueOf, enumValues: PreviewType.values)
    ..aInt64(3, _omitFieldNames ? '' : 'maxBytes')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'quality', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PreviewRequest clone() => PreviewRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PreviewRequest copyWith(void Function(PreviewRequest) updates) => super.copyWith((message) => updates(message as PreviewRequest)) as PreviewRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PreviewRequest create() => PreviewRequest._();
  PreviewRequest createEmptyInstance() => create();
  static $pb.PbList<PreviewRequest> createRepeated() => $pb.PbList<PreviewRequest>();
  @$core.pragma('dart2js:noInline')
  static PreviewRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PreviewRequest>(create);
  static PreviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => clearField(1);

  @$pb.TagNumber(2)
  PreviewType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(PreviewType v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get maxBytes => $_getI64(2);
  @$pb.TagNumber(3)
  set maxBytes($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMaxBytes() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxBytes() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get quality => $_getIZ(3);
  @$pb.TagNumber(4)
  set quality($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasQuality() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuality() => clearField(4);
}

class PreviewChunk extends $pb.GeneratedMessage {
  factory PreviewChunk({
    $core.List<$core.int>? data,
    $core.String? mimeType,
    $core.int? quality,
    $core.bool? isFinal,
    $core.int? width,
    $core.int? height,
    $fixnum.Int64? durationMs,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    if (mimeType != null) {
      $result.mimeType = mimeType;
    }
    if (quality != null) {
      $result.quality = quality;
    }
    if (isFinal != null) {
      $result.isFinal = isFinal;
    }
    if (width != null) {
      $result.width = width;
    }
    if (height != null) {
      $result.height = height;
    }
    if (durationMs != null) {
      $result.durationMs = durationMs;
    }
    return $result;
  }
  PreviewChunk._() : super();
  factory PreviewChunk.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PreviewChunk.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PreviewChunk', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..aOS(2, _omitFieldNames ? '' : 'mimeType')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'quality', $pb.PbFieldType.O3)
    ..aOB(4, _omitFieldNames ? '' : 'isFinal')
    ..a<$core.int>(5, _omitFieldNames ? '' : 'width', $pb.PbFieldType.O3)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'height', $pb.PbFieldType.O3)
    ..aInt64(7, _omitFieldNames ? '' : 'durationMs')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PreviewChunk clone() => PreviewChunk()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PreviewChunk copyWith(void Function(PreviewChunk) updates) => super.copyWith((message) => updates(message as PreviewChunk)) as PreviewChunk;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PreviewChunk create() => PreviewChunk._();
  PreviewChunk createEmptyInstance() => create();
  static $pb.PbList<PreviewChunk> createRepeated() => $pb.PbList<PreviewChunk>();
  @$core.pragma('dart2js:noInline')
  static PreviewChunk getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PreviewChunk>(create);
  static PreviewChunk? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get mimeType => $_getSZ(1);
  @$pb.TagNumber(2)
  set mimeType($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMimeType() => $_has(1);
  @$pb.TagNumber(2)
  void clearMimeType() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get quality => $_getIZ(2);
  @$pb.TagNumber(3)
  set quality($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasQuality() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuality() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isFinal => $_getBF(3);
  @$pb.TagNumber(4)
  set isFinal($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasIsFinal() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsFinal() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get width => $_getIZ(4);
  @$pb.TagNumber(5)
  set width($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasWidth() => $_has(4);
  @$pb.TagNumber(5)
  void clearWidth() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get height => $_getIZ(5);
  @$pb.TagNumber(6)
  set height($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasHeight() => $_has(5);
  @$pb.TagNumber(6)
  void clearHeight() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get durationMs => $_getI64(6);
  @$pb.TagNumber(7)
  set durationMs($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasDurationMs() => $_has(6);
  @$pb.TagNumber(7)
  void clearDurationMs() => clearField(7);
}

class ThumbnailRequest extends $pb.GeneratedMessage {
  factory ThumbnailRequest({
    $core.String? path,
    $core.int? width,
    $core.int? height,
  }) {
    final $result = create();
    if (path != null) {
      $result.path = path;
    }
    if (width != null) {
      $result.width = width;
    }
    if (height != null) {
      $result.height = height;
    }
    return $result;
  }
  ThumbnailRequest._() : super();
  factory ThumbnailRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ThumbnailRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ThumbnailRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'width', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'height', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ThumbnailRequest clone() => ThumbnailRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ThumbnailRequest copyWith(void Function(ThumbnailRequest) updates) => super.copyWith((message) => updates(message as ThumbnailRequest)) as ThumbnailRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ThumbnailRequest create() => ThumbnailRequest._();
  ThumbnailRequest createEmptyInstance() => create();
  static $pb.PbList<ThumbnailRequest> createRepeated() => $pb.PbList<ThumbnailRequest>();
  @$core.pragma('dart2js:noInline')
  static ThumbnailRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ThumbnailRequest>(create);
  static ThumbnailRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get width => $_getIZ(1);
  @$pb.TagNumber(2)
  set width($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasWidth() => $_has(1);
  @$pb.TagNumber(2)
  void clearWidth() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get height => $_getIZ(2);
  @$pb.TagNumber(3)
  set height($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasHeight() => $_has(2);
  @$pb.TagNumber(3)
  void clearHeight() => clearField(3);
}

class ThumbnailResponse extends $pb.GeneratedMessage {
  factory ThumbnailResponse({
    $core.List<$core.int>? data,
    $core.String? mimeType,
    $core.int? width,
    $core.int? height,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    if (mimeType != null) {
      $result.mimeType = mimeType;
    }
    if (width != null) {
      $result.width = width;
    }
    if (height != null) {
      $result.height = height;
    }
    return $result;
  }
  ThumbnailResponse._() : super();
  factory ThumbnailResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ThumbnailResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ThumbnailResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..aOS(2, _omitFieldNames ? '' : 'mimeType')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'width', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'height', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ThumbnailResponse clone() => ThumbnailResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ThumbnailResponse copyWith(void Function(ThumbnailResponse) updates) => super.copyWith((message) => updates(message as ThumbnailResponse)) as ThumbnailResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ThumbnailResponse create() => ThumbnailResponse._();
  ThumbnailResponse createEmptyInstance() => create();
  static $pb.PbList<ThumbnailResponse> createRepeated() => $pb.PbList<ThumbnailResponse>();
  @$core.pragma('dart2js:noInline')
  static ThumbnailResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ThumbnailResponse>(create);
  static ThumbnailResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get mimeType => $_getSZ(1);
  @$pb.TagNumber(2)
  set mimeType($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMimeType() => $_has(1);
  @$pb.TagNumber(2)
  void clearMimeType() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get width => $_getIZ(2);
  @$pb.TagNumber(3)
  set width($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasWidth() => $_has(2);
  @$pb.TagNumber(3)
  void clearWidth() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get height => $_getIZ(3);
  @$pb.TagNumber(4)
  set height($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHeight() => $_has(3);
  @$pb.TagNumber(4)
  void clearHeight() => clearField(4);
}

class CreateDirRequest extends $pb.GeneratedMessage {
  factory CreateDirRequest({
    $core.String? path,
    $core.bool? recursive,
  }) {
    final $result = create();
    if (path != null) {
      $result.path = path;
    }
    if (recursive != null) {
      $result.recursive = recursive;
    }
    return $result;
  }
  CreateDirRequest._() : super();
  factory CreateDirRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateDirRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateDirRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..aOB(2, _omitFieldNames ? '' : 'recursive')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateDirRequest clone() => CreateDirRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateDirRequest copyWith(void Function(CreateDirRequest) updates) => super.copyWith((message) => updates(message as CreateDirRequest)) as CreateDirRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateDirRequest create() => CreateDirRequest._();
  CreateDirRequest createEmptyInstance() => create();
  static $pb.PbList<CreateDirRequest> createRepeated() => $pb.PbList<CreateDirRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateDirRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateDirRequest>(create);
  static CreateDirRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get recursive => $_getBF(1);
  @$pb.TagNumber(2)
  set recursive($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRecursive() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecursive() => clearField(2);
}

class CreateFileRequest extends $pb.GeneratedMessage {
  factory CreateFileRequest({
    $core.String? path,
    $core.List<$core.int>? content,
  }) {
    final $result = create();
    if (path != null) {
      $result.path = path;
    }
    if (content != null) {
      $result.content = content;
    }
    return $result;
  }
  CreateFileRequest._() : super();
  factory CreateFileRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateFileRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateFileRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'content', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateFileRequest clone() => CreateFileRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateFileRequest copyWith(void Function(CreateFileRequest) updates) => super.copyWith((message) => updates(message as CreateFileRequest)) as CreateFileRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateFileRequest create() => CreateFileRequest._();
  CreateFileRequest createEmptyInstance() => create();
  static $pb.PbList<CreateFileRequest> createRepeated() => $pb.PbList<CreateFileRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateFileRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateFileRequest>(create);
  static CreateFileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get content => $_getN(1);
  @$pb.TagNumber(2)
  set content($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearContent() => clearField(2);
}

class DeleteRequest extends $pb.GeneratedMessage {
  factory DeleteRequest({
    $core.Iterable<$core.String>? paths,
    $core.bool? permanent,
  }) {
    final $result = create();
    if (paths != null) {
      $result.paths.addAll(paths);
    }
    if (permanent != null) {
      $result.permanent = permanent;
    }
    return $result;
  }
  DeleteRequest._() : super();
  factory DeleteRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'paths')
    ..aOB(2, _omitFieldNames ? '' : 'permanent')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteRequest clone() => DeleteRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteRequest copyWith(void Function(DeleteRequest) updates) => super.copyWith((message) => updates(message as DeleteRequest)) as DeleteRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteRequest create() => DeleteRequest._();
  DeleteRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteRequest> createRepeated() => $pb.PbList<DeleteRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteRequest>(create);
  static DeleteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get paths => $_getList(0);

  @$pb.TagNumber(2)
  $core.bool get permanent => $_getBF(1);
  @$pb.TagNumber(2)
  set permanent($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPermanent() => $_has(1);
  @$pb.TagNumber(2)
  void clearPermanent() => clearField(2);
}

class RenameRequest extends $pb.GeneratedMessage {
  factory RenameRequest({
    $core.String? path,
    $core.String? newName,
  }) {
    final $result = create();
    if (path != null) {
      $result.path = path;
    }
    if (newName != null) {
      $result.newName = newName;
    }
    return $result;
  }
  RenameRequest._() : super();
  factory RenameRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RenameRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RenameRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..aOS(2, _omitFieldNames ? '' : 'newName')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RenameRequest clone() => RenameRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RenameRequest copyWith(void Function(RenameRequest) updates) => super.copyWith((message) => updates(message as RenameRequest)) as RenameRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RenameRequest create() => RenameRequest._();
  RenameRequest createEmptyInstance() => create();
  static $pb.PbList<RenameRequest> createRepeated() => $pb.PbList<RenameRequest>();
  @$core.pragma('dart2js:noInline')
  static RenameRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RenameRequest>(create);
  static RenameRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get newName => $_getSZ(1);
  @$pb.TagNumber(2)
  set newName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNewName() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewName() => clearField(2);
}

class WatchRequest extends $pb.GeneratedMessage {
  factory WatchRequest({
    $core.Iterable<$core.String>? paths,
    $core.bool? recursive,
  }) {
    final $result = create();
    if (paths != null) {
      $result.paths.addAll(paths);
    }
    if (recursive != null) {
      $result.recursive = recursive;
    }
    return $result;
  }
  WatchRequest._() : super();
  factory WatchRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WatchRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'WatchRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'paths')
    ..aOB(2, _omitFieldNames ? '' : 'recursive')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WatchRequest clone() => WatchRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WatchRequest copyWith(void Function(WatchRequest) updates) => super.copyWith((message) => updates(message as WatchRequest)) as WatchRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchRequest create() => WatchRequest._();
  WatchRequest createEmptyInstance() => create();
  static $pb.PbList<WatchRequest> createRepeated() => $pb.PbList<WatchRequest>();
  @$core.pragma('dart2js:noInline')
  static WatchRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WatchRequest>(create);
  static WatchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get paths => $_getList(0);

  @$pb.TagNumber(2)
  $core.bool get recursive => $_getBF(1);
  @$pb.TagNumber(2)
  set recursive($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRecursive() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecursive() => clearField(2);
}

class FileEvent extends $pb.GeneratedMessage {
  factory FileEvent({
    FileEventType? type,
    $core.String? path,
    $core.String? oldPath,
    $fixnum.Int64? timestamp,
  }) {
    final $result = create();
    if (type != null) {
      $result.type = type;
    }
    if (path != null) {
      $result.path = path;
    }
    if (oldPath != null) {
      $result.oldPath = oldPath;
    }
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    return $result;
  }
  FileEvent._() : super();
  factory FileEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FileEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FileEvent', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..e<FileEventType>(1, _omitFieldNames ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: FileEventType.CREATED, valueOf: FileEventType.valueOf, enumValues: FileEventType.values)
    ..aOS(2, _omitFieldNames ? '' : 'path')
    ..aOS(3, _omitFieldNames ? '' : 'oldPath')
    ..aInt64(4, _omitFieldNames ? '' : 'timestamp')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FileEvent clone() => FileEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FileEvent copyWith(void Function(FileEvent) updates) => super.copyWith((message) => updates(message as FileEvent)) as FileEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FileEvent create() => FileEvent._();
  FileEvent createEmptyInstance() => create();
  static $pb.PbList<FileEvent> createRepeated() => $pb.PbList<FileEvent>();
  @$core.pragma('dart2js:noInline')
  static FileEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FileEvent>(create);
  static FileEvent? _defaultInstance;

  @$pb.TagNumber(1)
  FileEventType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(FileEventType v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get oldPath => $_getSZ(2);
  @$pb.TagNumber(3)
  set oldPath($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasOldPath() => $_has(2);
  @$pb.TagNumber(3)
  void clearOldPath() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get timestamp => $_getI64(3);
  @$pb.TagNumber(4)
  set timestamp($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTimestamp() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimestamp() => clearField(4);
}

class DeviceInfo extends $pb.GeneratedMessage {
  factory DeviceInfo({
    $core.String? deviceId,
    $core.String? deviceName,
    $core.String? platform,
    $core.String? version,
    $fixnum.Int64? totalStorage,
    $fixnum.Int64? freeStorage,
  }) {
    final $result = create();
    if (deviceId != null) {
      $result.deviceId = deviceId;
    }
    if (deviceName != null) {
      $result.deviceName = deviceName;
    }
    if (platform != null) {
      $result.platform = platform;
    }
    if (version != null) {
      $result.version = version;
    }
    if (totalStorage != null) {
      $result.totalStorage = totalStorage;
    }
    if (freeStorage != null) {
      $result.freeStorage = freeStorage;
    }
    return $result;
  }
  DeviceInfo._() : super();
  factory DeviceInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeviceInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeviceInfo', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOS(2, _omitFieldNames ? '' : 'deviceName')
    ..aOS(3, _omitFieldNames ? '' : 'platform')
    ..aOS(4, _omitFieldNames ? '' : 'version')
    ..aInt64(5, _omitFieldNames ? '' : 'totalStorage')
    ..aInt64(6, _omitFieldNames ? '' : 'freeStorage')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeviceInfo clone() => DeviceInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeviceInfo copyWith(void Function(DeviceInfo) updates) => super.copyWith((message) => updates(message as DeviceInfo)) as DeviceInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceInfo create() => DeviceInfo._();
  DeviceInfo createEmptyInstance() => create();
  static $pb.PbList<DeviceInfo> createRepeated() => $pb.PbList<DeviceInfo>();
  @$core.pragma('dart2js:noInline')
  static DeviceInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeviceInfo>(create);
  static DeviceInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get deviceName => $_getSZ(1);
  @$pb.TagNumber(2)
  set deviceName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDeviceName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get platform => $_getSZ(2);
  @$pb.TagNumber(3)
  set platform($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPlatform() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlatform() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get version => $_getSZ(3);
  @$pb.TagNumber(4)
  set version($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearVersion() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get totalStorage => $_getI64(4);
  @$pb.TagNumber(5)
  set totalStorage($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTotalStorage() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotalStorage() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get freeStorage => $_getI64(5);
  @$pb.TagNumber(6)
  set freeStorage($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasFreeStorage() => $_has(5);
  @$pb.TagNumber(6)
  void clearFreeStorage() => clearField(6);
}

class DriveList extends $pb.GeneratedMessage {
  factory DriveList({
    $core.Iterable<DriveInfo>? drives,
  }) {
    final $result = create();
    if (drives != null) {
      $result.drives.addAll(drives);
    }
    return $result;
  }
  DriveList._() : super();
  factory DriveList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DriveList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DriveList', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..pc<DriveInfo>(1, _omitFieldNames ? '' : 'drives', $pb.PbFieldType.PM, subBuilder: DriveInfo.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DriveList clone() => DriveList()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DriveList copyWith(void Function(DriveList) updates) => super.copyWith((message) => updates(message as DriveList)) as DriveList;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DriveList create() => DriveList._();
  DriveList createEmptyInstance() => create();
  static $pb.PbList<DriveList> createRepeated() => $pb.PbList<DriveList>();
  @$core.pragma('dart2js:noInline')
  static DriveList getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DriveList>(create);
  static DriveList? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<DriveInfo> get drives => $_getList(0);
}

class DriveInfo extends $pb.GeneratedMessage {
  factory DriveInfo({
    $core.String? name,
    $core.String? path,
    $core.String? label,
    $fixnum.Int64? totalSpace,
    $fixnum.Int64? freeSpace,
    $core.bool? isRemovable,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (path != null) {
      $result.path = path;
    }
    if (label != null) {
      $result.label = label;
    }
    if (totalSpace != null) {
      $result.totalSpace = totalSpace;
    }
    if (freeSpace != null) {
      $result.freeSpace = freeSpace;
    }
    if (isRemovable != null) {
      $result.isRemovable = isRemovable;
    }
    return $result;
  }
  DriveInfo._() : super();
  factory DriveInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DriveInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DriveInfo', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'path')
    ..aOS(3, _omitFieldNames ? '' : 'label')
    ..aInt64(4, _omitFieldNames ? '' : 'totalSpace')
    ..aInt64(5, _omitFieldNames ? '' : 'freeSpace')
    ..aOB(6, _omitFieldNames ? '' : 'isRemovable')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DriveInfo clone() => DriveInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DriveInfo copyWith(void Function(DriveInfo) updates) => super.copyWith((message) => updates(message as DriveInfo)) as DriveInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DriveInfo create() => DriveInfo._();
  DriveInfo createEmptyInstance() => create();
  static $pb.PbList<DriveInfo> createRepeated() => $pb.PbList<DriveInfo>();
  @$core.pragma('dart2js:noInline')
  static DriveInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DriveInfo>(create);
  static DriveInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get label => $_getSZ(2);
  @$pb.TagNumber(3)
  set label($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLabel() => $_has(2);
  @$pb.TagNumber(3)
  void clearLabel() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get totalSpace => $_getI64(3);
  @$pb.TagNumber(4)
  set totalSpace($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTotalSpace() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalSpace() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get freeSpace => $_getI64(4);
  @$pb.TagNumber(5)
  set freeSpace($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasFreeSpace() => $_has(4);
  @$pb.TagNumber(5)
  void clearFreeSpace() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isRemovable => $_getBF(5);
  @$pb.TagNumber(6)
  set isRemovable($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasIsRemovable() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsRemovable() => clearField(6);
}

class PeerInfo extends $pb.GeneratedMessage {
  factory PeerInfo({
    $core.String? deviceId,
    $core.String? deviceName,
    $core.String? ipAddress,
    $core.int? port,
    $core.String? platform,
    $core.bool? isPaired,
  }) {
    final $result = create();
    if (deviceId != null) {
      $result.deviceId = deviceId;
    }
    if (deviceName != null) {
      $result.deviceName = deviceName;
    }
    if (ipAddress != null) {
      $result.ipAddress = ipAddress;
    }
    if (port != null) {
      $result.port = port;
    }
    if (platform != null) {
      $result.platform = platform;
    }
    if (isPaired != null) {
      $result.isPaired = isPaired;
    }
    return $result;
  }
  PeerInfo._() : super();
  factory PeerInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PeerInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PeerInfo', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOS(2, _omitFieldNames ? '' : 'deviceName')
    ..aOS(3, _omitFieldNames ? '' : 'ipAddress')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'port', $pb.PbFieldType.O3)
    ..aOS(5, _omitFieldNames ? '' : 'platform')
    ..aOB(6, _omitFieldNames ? '' : 'isPaired')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PeerInfo clone() => PeerInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PeerInfo copyWith(void Function(PeerInfo) updates) => super.copyWith((message) => updates(message as PeerInfo)) as PeerInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PeerInfo create() => PeerInfo._();
  PeerInfo createEmptyInstance() => create();
  static $pb.PbList<PeerInfo> createRepeated() => $pb.PbList<PeerInfo>();
  @$core.pragma('dart2js:noInline')
  static PeerInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PeerInfo>(create);
  static PeerInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get deviceName => $_getSZ(1);
  @$pb.TagNumber(2)
  set deviceName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDeviceName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get ipAddress => $_getSZ(2);
  @$pb.TagNumber(3)
  set ipAddress($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIpAddress() => $_has(2);
  @$pb.TagNumber(3)
  void clearIpAddress() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get port => $_getIZ(3);
  @$pb.TagNumber(4)
  set port($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPort() => $_has(3);
  @$pb.TagNumber(4)
  void clearPort() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get platform => $_getSZ(4);
  @$pb.TagNumber(5)
  set platform($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPlatform() => $_has(4);
  @$pb.TagNumber(5)
  void clearPlatform() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isPaired => $_getBF(5);
  @$pb.TagNumber(6)
  set isPaired($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasIsPaired() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsPaired() => clearField(6);
}

class PairingRequest extends $pb.GeneratedMessage {
  factory PairingRequest({
    $core.String? deviceId,
    $core.String? deviceName,
    $core.List<$core.int>? publicKey,
  }) {
    final $result = create();
    if (deviceId != null) {
      $result.deviceId = deviceId;
    }
    if (deviceName != null) {
      $result.deviceName = deviceName;
    }
    if (publicKey != null) {
      $result.publicKey = publicKey;
    }
    return $result;
  }
  PairingRequest._() : super();
  factory PairingRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PairingRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PairingRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOS(2, _omitFieldNames ? '' : 'deviceName')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'publicKey', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PairingRequest clone() => PairingRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PairingRequest copyWith(void Function(PairingRequest) updates) => super.copyWith((message) => updates(message as PairingRequest)) as PairingRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PairingRequest create() => PairingRequest._();
  PairingRequest createEmptyInstance() => create();
  static $pb.PbList<PairingRequest> createRepeated() => $pb.PbList<PairingRequest>();
  @$core.pragma('dart2js:noInline')
  static PairingRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PairingRequest>(create);
  static PairingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get deviceName => $_getSZ(1);
  @$pb.TagNumber(2)
  set deviceName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDeviceName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceName() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get publicKey => $_getN(2);
  @$pb.TagNumber(3)
  set publicKey($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPublicKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearPublicKey() => clearField(3);
}

class PairingChallenge extends $pb.GeneratedMessage {
  factory PairingChallenge({
    $core.String? sessionId,
    $core.String? pinCode,
    $core.int? expiresIn,
  }) {
    final $result = create();
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    if (pinCode != null) {
      $result.pinCode = pinCode;
    }
    if (expiresIn != null) {
      $result.expiresIn = expiresIn;
    }
    return $result;
  }
  PairingChallenge._() : super();
  factory PairingChallenge.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PairingChallenge.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PairingChallenge', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'pinCode')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'expiresIn', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PairingChallenge clone() => PairingChallenge()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PairingChallenge copyWith(void Function(PairingChallenge) updates) => super.copyWith((message) => updates(message as PairingChallenge)) as PairingChallenge;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PairingChallenge create() => PairingChallenge._();
  PairingChallenge createEmptyInstance() => create();
  static $pb.PbList<PairingChallenge> createRepeated() => $pb.PbList<PairingChallenge>();
  @$core.pragma('dart2js:noInline')
  static PairingChallenge getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PairingChallenge>(create);
  static PairingChallenge? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get pinCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set pinCode($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPinCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearPinCode() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get expiresIn => $_getIZ(2);
  @$pb.TagNumber(3)
  set expiresIn($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasExpiresIn() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpiresIn() => clearField(3);
}

class PairingConfirmation extends $pb.GeneratedMessage {
  factory PairingConfirmation({
    $core.String? sessionId,
    $core.String? pinCode,
    $core.List<$core.int>? signature,
  }) {
    final $result = create();
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    if (pinCode != null) {
      $result.pinCode = pinCode;
    }
    if (signature != null) {
      $result.signature = signature;
    }
    return $result;
  }
  PairingConfirmation._() : super();
  factory PairingConfirmation.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PairingConfirmation.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PairingConfirmation', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'pinCode')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'signature', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PairingConfirmation clone() => PairingConfirmation()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PairingConfirmation copyWith(void Function(PairingConfirmation) updates) => super.copyWith((message) => updates(message as PairingConfirmation)) as PairingConfirmation;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PairingConfirmation create() => PairingConfirmation._();
  PairingConfirmation createEmptyInstance() => create();
  static $pb.PbList<PairingConfirmation> createRepeated() => $pb.PbList<PairingConfirmation>();
  @$core.pragma('dart2js:noInline')
  static PairingConfirmation getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PairingConfirmation>(create);
  static PairingConfirmation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get pinCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set pinCode($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPinCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearPinCode() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get signature => $_getN(2);
  @$pb.TagNumber(3)
  set signature($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSignature() => $_has(2);
  @$pb.TagNumber(3)
  void clearSignature() => clearField(3);
}

class PairingResult extends $pb.GeneratedMessage {
  factory PairingResult({
    $core.bool? success,
    $core.String? error,
    $core.List<$core.int>? certificate,
  }) {
    final $result = create();
    if (success != null) {
      $result.success = success;
    }
    if (error != null) {
      $result.error = error;
    }
    if (certificate != null) {
      $result.certificate = certificate;
    }
    return $result;
  }
  PairingResult._() : super();
  factory PairingResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PairingResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PairingResult', package: const $pb.PackageName(_omitMessageNames ? '' : 'filenode'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'error')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'certificate', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PairingResult clone() => PairingResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PairingResult copyWith(void Function(PairingResult) updates) => super.copyWith((message) => updates(message as PairingResult)) as PairingResult;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PairingResult create() => PairingResult._();
  PairingResult createEmptyInstance() => create();
  static $pb.PbList<PairingResult> createRepeated() => $pb.PbList<PairingResult>();
  @$core.pragma('dart2js:noInline')
  static PairingResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PairingResult>(create);
  static PairingResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get error => $_getSZ(1);
  @$pb.TagNumber(2)
  set error($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get certificate => $_getN(2);
  @$pb.TagNumber(3)
  set certificate($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCertificate() => $_has(2);
  @$pb.TagNumber(3)
  void clearCertificate() => clearField(3);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
