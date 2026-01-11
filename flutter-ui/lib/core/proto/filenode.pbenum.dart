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

import 'package:protobuf/protobuf.dart' as $pb;

class SortBy extends $pb.ProtobufEnum {
  static const SortBy SORT_NAME = SortBy._(0, _omitEnumNames ? '' : 'SORT_NAME');
  static const SortBy SORT_SIZE = SortBy._(1, _omitEnumNames ? '' : 'SORT_SIZE');
  static const SortBy SORT_MODIFIED = SortBy._(2, _omitEnumNames ? '' : 'SORT_MODIFIED');
  static const SortBy SORT_TYPE = SortBy._(3, _omitEnumNames ? '' : 'SORT_TYPE');

  static const $core.List<SortBy> values = <SortBy> [
    SORT_NAME,
    SORT_SIZE,
    SORT_MODIFIED,
    SORT_TYPE,
  ];

  static final $core.Map<$core.int, SortBy> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SortBy? valueOf($core.int value) => _byValue[value];

  const SortBy._($core.int v, $core.String n) : super(v, n);
}

class SortOrder extends $pb.ProtobufEnum {
  static const SortOrder ASC = SortOrder._(0, _omitEnumNames ? '' : 'ASC');
  static const SortOrder DESC = SortOrder._(1, _omitEnumNames ? '' : 'DESC');

  static const $core.List<SortOrder> values = <SortOrder> [
    ASC,
    DESC,
  ];

  static final $core.Map<$core.int, SortOrder> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SortOrder? valueOf($core.int value) => _byValue[value];

  const SortOrder._($core.int v, $core.String n) : super(v, n);
}

class TransferStatus extends $pb.ProtobufEnum {
  static const TransferStatus QUEUED = TransferStatus._(0, _omitEnumNames ? '' : 'QUEUED');
  static const TransferStatus IN_PROGRESS = TransferStatus._(1, _omitEnumNames ? '' : 'IN_PROGRESS');
  static const TransferStatus PAUSED = TransferStatus._(2, _omitEnumNames ? '' : 'PAUSED');
  static const TransferStatus COMPLETED = TransferStatus._(3, _omitEnumNames ? '' : 'COMPLETED');
  static const TransferStatus FAILED = TransferStatus._(4, _omitEnumNames ? '' : 'FAILED');
  static const TransferStatus CANCELLED = TransferStatus._(5, _omitEnumNames ? '' : 'CANCELLED');

  static const $core.List<TransferStatus> values = <TransferStatus> [
    QUEUED,
    IN_PROGRESS,
    PAUSED,
    COMPLETED,
    FAILED,
    CANCELLED,
  ];

  static final $core.Map<$core.int, TransferStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static TransferStatus? valueOf($core.int value) => _byValue[value];

  const TransferStatus._($core.int v, $core.String n) : super(v, n);
}

class PreviewType extends $pb.ProtobufEnum {
  static const PreviewType AUTO = PreviewType._(0, _omitEnumNames ? '' : 'AUTO');
  static const PreviewType IMAGE = PreviewType._(1, _omitEnumNames ? '' : 'IMAGE');
  static const PreviewType VIDEO = PreviewType._(2, _omitEnumNames ? '' : 'VIDEO');
  static const PreviewType AUDIO = PreviewType._(3, _omitEnumNames ? '' : 'AUDIO');
  static const PreviewType TEXT = PreviewType._(4, _omitEnumNames ? '' : 'TEXT');

  static const $core.List<PreviewType> values = <PreviewType> [
    AUTO,
    IMAGE,
    VIDEO,
    AUDIO,
    TEXT,
  ];

  static final $core.Map<$core.int, PreviewType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static PreviewType? valueOf($core.int value) => _byValue[value];

  const PreviewType._($core.int v, $core.String n) : super(v, n);
}

class FileEventType extends $pb.ProtobufEnum {
  static const FileEventType CREATED = FileEventType._(0, _omitEnumNames ? '' : 'CREATED');
  static const FileEventType MODIFIED = FileEventType._(1, _omitEnumNames ? '' : 'MODIFIED');
  static const FileEventType DELETED = FileEventType._(2, _omitEnumNames ? '' : 'DELETED');
  static const FileEventType RENAMED = FileEventType._(3, _omitEnumNames ? '' : 'RENAMED');

  static const $core.List<FileEventType> values = <FileEventType> [
    CREATED,
    MODIFIED,
    DELETED,
    RENAMED,
  ];

  static final $core.Map<$core.int, FileEventType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static FileEventType? valueOf($core.int value) => _byValue[value];

  const FileEventType._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
