///
//  Generated code. Do not modify.
//  source: hospitals.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use listHospitalsRequestDescriptor instead')
const ListHospitalsRequest$json = const {
  '1': 'ListHospitalsRequest',
};

/// Descriptor for `ListHospitalsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listHospitalsRequestDescriptor = $convert.base64Decode('ChRMaXN0SG9zcGl0YWxzUmVxdWVzdA==');
@$core.Deprecated('Use listHospitalsResponseDescriptor instead')
const ListHospitalsResponse$json = const {
  '1': 'ListHospitalsResponse',
  '2': const [
    const {'1': 'hospitals', '3': 1, '4': 3, '5': 11, '6': '.african_hospitals.Hospital', '10': 'hospitals'},
  ],
};

/// Descriptor for `ListHospitalsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listHospitalsResponseDescriptor = $convert.base64Decode('ChVMaXN0SG9zcGl0YWxzUmVzcG9uc2USOQoJaG9zcGl0YWxzGAEgAygLMhsuYWZyaWNhbl9ob3NwaXRhbHMuSG9zcGl0YWxSCWhvc3BpdGFscw==');
@$core.Deprecated('Use getHospitalRequestDescriptor instead')
const GetHospitalRequest$json = const {
  '1': 'GetHospitalRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetHospitalRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getHospitalRequestDescriptor = $convert.base64Decode('ChJHZXRIb3NwaXRhbFJlcXVlc3QSDgoCaWQYASABKAlSAmlk');
@$core.Deprecated('Use searchHospitalsRequestDescriptor instead')
const SearchHospitalsRequest$json = const {
  '1': 'SearchHospitalsRequest',
  '2': const [
    const {'1': 'country', '3': 1, '4': 1, '5': 9, '10': 'country'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `SearchHospitalsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchHospitalsRequestDescriptor = $convert.base64Decode('ChZTZWFyY2hIb3NwaXRhbHNSZXF1ZXN0EhgKB2NvdW50cnkYASABKAlSB2NvdW50cnkSEgoEbmFtZRgCIAEoCVIEbmFtZQ==');
@$core.Deprecated('Use searchHospitalsResponseDescriptor instead')
const SearchHospitalsResponse$json = const {
  '1': 'SearchHospitalsResponse',
  '2': const [
    const {'1': 'hospitals', '3': 1, '4': 3, '5': 11, '6': '.african_hospitals.Hospital', '10': 'hospitals'},
  ],
};

/// Descriptor for `SearchHospitalsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchHospitalsResponseDescriptor = $convert.base64Decode('ChdTZWFyY2hIb3NwaXRhbHNSZXNwb25zZRI5Cglob3NwaXRhbHMYASADKAsyGy5hZnJpY2FuX2hvc3BpdGFscy5Ib3NwaXRhbFIJaG9zcGl0YWxz');
@$core.Deprecated('Use hospitalDescriptor instead')
const Hospital$json = const {
  '1': 'Hospital',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'type', '3': 3, '4': 1, '5': 9, '10': 'type'},
    const {'1': 'ownership', '3': 4, '4': 1, '5': 9, '10': 'ownership'},
    const {'1': 'latLng', '3': 5, '4': 1, '5': 11, '6': '.african_hospitals.LatLng', '10': 'latLng'},
    const {'1': 'country', '3': 6, '4': 1, '5': 9, '10': 'country'},
  ],
};

/// Descriptor for `Hospital`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hospitalDescriptor = $convert.base64Decode('CghIb3NwaXRhbBIOCgJpZBgBIAEoCVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRISCgR0eXBlGAMgASgJUgR0eXBlEhwKCW93bmVyc2hpcBgEIAEoCVIJb3duZXJzaGlwEjEKBmxhdExuZxgFIAEoCzIZLmFmcmljYW5faG9zcGl0YWxzLkxhdExuZ1IGbGF0TG5nEhgKB2NvdW50cnkYBiABKAlSB2NvdW50cnk=');
@$core.Deprecated('Use latLngDescriptor instead')
const LatLng$json = const {
  '1': 'LatLng',
  '2': const [
    const {'1': 'latitude', '3': 1, '4': 1, '5': 2, '10': 'latitude'},
    const {'1': 'longitude', '3': 2, '4': 1, '5': 2, '10': 'longitude'},
  ],
};

/// Descriptor for `LatLng`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List latLngDescriptor = $convert.base64Decode('CgZMYXRMbmcSGgoIbGF0aXR1ZGUYASABKAJSCGxhdGl0dWRlEhwKCWxvbmdpdHVkZRgCIAEoAlIJbG9uZ2l0dWRl');
