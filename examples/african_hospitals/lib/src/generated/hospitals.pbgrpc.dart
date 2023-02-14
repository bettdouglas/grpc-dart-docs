///
//  Generated code. Do not modify.
//  source: hospitals.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'hospitals.pb.dart' as $0;
export 'hospitals.pb.dart';

class HospitalServiceClient extends $grpc.Client {
  static final _$listHospitals =
      $grpc.ClientMethod<$0.ListHospitalsRequest, $0.ListHospitalsResponse>(
          '/african_hospitals.HospitalService/ListHospitals',
          ($0.ListHospitalsRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.ListHospitalsResponse.fromBuffer(value));
  static final _$getHospital =
      $grpc.ClientMethod<$0.GetHospitalRequest, $0.Hospital>(
          '/african_hospitals.HospitalService/GetHospital',
          ($0.GetHospitalRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Hospital.fromBuffer(value));
  static final _$searchHospitals =
      $grpc.ClientMethod<$0.SearchHospitalsRequest, $0.SearchHospitalsResponse>(
          '/african_hospitals.HospitalService/SearchHospitals',
          ($0.SearchHospitalsRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.SearchHospitalsResponse.fromBuffer(value));

  HospitalServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.ListHospitalsResponse> listHospitals(
      $0.ListHospitalsRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listHospitals, request, options: options);
  }

  $grpc.ResponseFuture<$0.Hospital> getHospital($0.GetHospitalRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getHospital, request, options: options);
  }

  $grpc.ResponseFuture<$0.SearchHospitalsResponse> searchHospitals(
      $0.SearchHospitalsRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$searchHospitals, request, options: options);
  }
}

abstract class HospitalServiceBase extends $grpc.Service {
  $core.String get $name => 'african_hospitals.HospitalService';

  HospitalServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.ListHospitalsRequest, $0.ListHospitalsResponse>(
            'ListHospitals',
            listHospitals_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListHospitalsRequest.fromBuffer(value),
            ($0.ListHospitalsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetHospitalRequest, $0.Hospital>(
        'GetHospital',
        getHospital_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetHospitalRequest.fromBuffer(value),
        ($0.Hospital value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SearchHospitalsRequest,
            $0.SearchHospitalsResponse>(
        'SearchHospitals',
        searchHospitals_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SearchHospitalsRequest.fromBuffer(value),
        ($0.SearchHospitalsResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ListHospitalsResponse> listHospitals_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.ListHospitalsRequest> request) async {
    return listHospitals(call, await request);
  }

  $async.Future<$0.Hospital> getHospital_Pre($grpc.ServiceCall call,
      $async.Future<$0.GetHospitalRequest> request) async {
    return getHospital(call, await request);
  }

  $async.Future<$0.SearchHospitalsResponse> searchHospitals_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.SearchHospitalsRequest> request) async {
    return searchHospitals(call, await request);
  }

  $async.Future<$0.ListHospitalsResponse> listHospitals(
      $grpc.ServiceCall call, $0.ListHospitalsRequest request);
  $async.Future<$0.Hospital> getHospital(
      $grpc.ServiceCall call, $0.GetHospitalRequest request);
  $async.Future<$0.SearchHospitalsResponse> searchHospitals(
      $grpc.ServiceCall call, $0.SearchHospitalsRequest request);
}
