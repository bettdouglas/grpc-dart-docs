///
//  Generated code. Do not modify.
//  source: hospitals.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ListHospitalsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListHospitalsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'african_hospitals'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  ListHospitalsRequest._() : super();
  factory ListHospitalsRequest() => create();
  factory ListHospitalsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListHospitalsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListHospitalsRequest clone() => ListHospitalsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListHospitalsRequest copyWith(void Function(ListHospitalsRequest) updates) => super.copyWith((message) => updates(message as ListHospitalsRequest)) as ListHospitalsRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListHospitalsRequest create() => ListHospitalsRequest._();
  ListHospitalsRequest createEmptyInstance() => create();
  static $pb.PbList<ListHospitalsRequest> createRepeated() => $pb.PbList<ListHospitalsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListHospitalsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListHospitalsRequest>(create);
  static ListHospitalsRequest? _defaultInstance;
}

class ListHospitalsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListHospitalsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'african_hospitals'), createEmptyInstance: create)
    ..pc<Hospital>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hospitals', $pb.PbFieldType.PM, subBuilder: Hospital.create)
    ..hasRequiredFields = false
  ;

  ListHospitalsResponse._() : super();
  factory ListHospitalsResponse({
    $core.Iterable<Hospital>? hospitals,
  }) {
    final _result = create();
    if (hospitals != null) {
      _result.hospitals.addAll(hospitals);
    }
    return _result;
  }
  factory ListHospitalsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListHospitalsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListHospitalsResponse clone() => ListHospitalsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListHospitalsResponse copyWith(void Function(ListHospitalsResponse) updates) => super.copyWith((message) => updates(message as ListHospitalsResponse)) as ListHospitalsResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListHospitalsResponse create() => ListHospitalsResponse._();
  ListHospitalsResponse createEmptyInstance() => create();
  static $pb.PbList<ListHospitalsResponse> createRepeated() => $pb.PbList<ListHospitalsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListHospitalsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListHospitalsResponse>(create);
  static ListHospitalsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Hospital> get hospitals => $_getList(0);
}

class GetHospitalRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetHospitalRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'african_hospitals'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..hasRequiredFields = false
  ;

  GetHospitalRequest._() : super();
  factory GetHospitalRequest({
    $core.String? id,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory GetHospitalRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetHospitalRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetHospitalRequest clone() => GetHospitalRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetHospitalRequest copyWith(void Function(GetHospitalRequest) updates) => super.copyWith((message) => updates(message as GetHospitalRequest)) as GetHospitalRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetHospitalRequest create() => GetHospitalRequest._();
  GetHospitalRequest createEmptyInstance() => create();
  static $pb.PbList<GetHospitalRequest> createRepeated() => $pb.PbList<GetHospitalRequest>();
  @$core.pragma('dart2js:noInline')
  static GetHospitalRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetHospitalRequest>(create);
  static GetHospitalRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class SearchHospitalsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SearchHospitalsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'african_hospitals'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'country')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..hasRequiredFields = false
  ;

  SearchHospitalsRequest._() : super();
  factory SearchHospitalsRequest({
    $core.String? country,
    $core.String? name,
  }) {
    final _result = create();
    if (country != null) {
      _result.country = country;
    }
    if (name != null) {
      _result.name = name;
    }
    return _result;
  }
  factory SearchHospitalsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SearchHospitalsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SearchHospitalsRequest clone() => SearchHospitalsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SearchHospitalsRequest copyWith(void Function(SearchHospitalsRequest) updates) => super.copyWith((message) => updates(message as SearchHospitalsRequest)) as SearchHospitalsRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SearchHospitalsRequest create() => SearchHospitalsRequest._();
  SearchHospitalsRequest createEmptyInstance() => create();
  static $pb.PbList<SearchHospitalsRequest> createRepeated() => $pb.PbList<SearchHospitalsRequest>();
  @$core.pragma('dart2js:noInline')
  static SearchHospitalsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SearchHospitalsRequest>(create);
  static SearchHospitalsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get country => $_getSZ(0);
  @$pb.TagNumber(1)
  set country($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCountry() => $_has(0);
  @$pb.TagNumber(1)
  void clearCountry() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);
}

class SearchHospitalsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SearchHospitalsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'african_hospitals'), createEmptyInstance: create)
    ..pc<Hospital>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hospitals', $pb.PbFieldType.PM, subBuilder: Hospital.create)
    ..hasRequiredFields = false
  ;

  SearchHospitalsResponse._() : super();
  factory SearchHospitalsResponse({
    $core.Iterable<Hospital>? hospitals,
  }) {
    final _result = create();
    if (hospitals != null) {
      _result.hospitals.addAll(hospitals);
    }
    return _result;
  }
  factory SearchHospitalsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SearchHospitalsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SearchHospitalsResponse clone() => SearchHospitalsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SearchHospitalsResponse copyWith(void Function(SearchHospitalsResponse) updates) => super.copyWith((message) => updates(message as SearchHospitalsResponse)) as SearchHospitalsResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SearchHospitalsResponse create() => SearchHospitalsResponse._();
  SearchHospitalsResponse createEmptyInstance() => create();
  static $pb.PbList<SearchHospitalsResponse> createRepeated() => $pb.PbList<SearchHospitalsResponse>();
  @$core.pragma('dart2js:noInline')
  static SearchHospitalsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SearchHospitalsResponse>(create);
  static SearchHospitalsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Hospital> get hospitals => $_getList(0);
}

class Hospital extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Hospital', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'african_hospitals'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ownership')
    ..aOM<LatLng>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'latLng', protoName: 'latLng', subBuilder: LatLng.create)
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'country')
    ..hasRequiredFields = false
  ;

  Hospital._() : super();
  factory Hospital({
    $core.String? id,
    $core.String? name,
    $core.String? type,
    $core.String? ownership,
    LatLng? latLng,
    $core.String? country,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (name != null) {
      _result.name = name;
    }
    if (type != null) {
      _result.type = type;
    }
    if (ownership != null) {
      _result.ownership = ownership;
    }
    if (latLng != null) {
      _result.latLng = latLng;
    }
    if (country != null) {
      _result.country = country;
    }
    return _result;
  }
  factory Hospital.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Hospital.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Hospital clone() => Hospital()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Hospital copyWith(void Function(Hospital) updates) => super.copyWith((message) => updates(message as Hospital)) as Hospital; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Hospital create() => Hospital._();
  Hospital createEmptyInstance() => create();
  static $pb.PbList<Hospital> createRepeated() => $pb.PbList<Hospital>();
  @$core.pragma('dart2js:noInline')
  static Hospital getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Hospital>(create);
  static Hospital? _defaultInstance;

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
  $core.String get type => $_getSZ(2);
  @$pb.TagNumber(3)
  set type($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get ownership => $_getSZ(3);
  @$pb.TagNumber(4)
  set ownership($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasOwnership() => $_has(3);
  @$pb.TagNumber(4)
  void clearOwnership() => clearField(4);

  @$pb.TagNumber(5)
  LatLng get latLng => $_getN(4);
  @$pb.TagNumber(5)
  set latLng(LatLng v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasLatLng() => $_has(4);
  @$pb.TagNumber(5)
  void clearLatLng() => clearField(5);
  @$pb.TagNumber(5)
  LatLng ensureLatLng() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get country => $_getSZ(5);
  @$pb.TagNumber(6)
  set country($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCountry() => $_has(5);
  @$pb.TagNumber(6)
  void clearCountry() => clearField(6);
}

class LatLng extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LatLng', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'african_hospitals'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'latitude', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'longitude', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  LatLng._() : super();
  factory LatLng({
    $core.double? latitude,
    $core.double? longitude,
  }) {
    final _result = create();
    if (latitude != null) {
      _result.latitude = latitude;
    }
    if (longitude != null) {
      _result.longitude = longitude;
    }
    return _result;
  }
  factory LatLng.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LatLng.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LatLng clone() => LatLng()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LatLng copyWith(void Function(LatLng) updates) => super.copyWith((message) => updates(message as LatLng)) as LatLng; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LatLng create() => LatLng._();
  LatLng createEmptyInstance() => create();
  static $pb.PbList<LatLng> createRepeated() => $pb.PbList<LatLng>();
  @$core.pragma('dart2js:noInline')
  static LatLng getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LatLng>(create);
  static LatLng? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get latitude => $_getN(0);
  @$pb.TagNumber(1)
  set latitude($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLatitude() => $_has(0);
  @$pb.TagNumber(1)
  void clearLatitude() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get longitude => $_getN(1);
  @$pb.TagNumber(2)
  set longitude($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLongitude() => $_has(1);
  @$pb.TagNumber(2)
  void clearLongitude() => clearField(2);
}

