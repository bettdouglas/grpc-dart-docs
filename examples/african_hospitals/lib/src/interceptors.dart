import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:grpc/grpc.dart';

FutureOr<GrpcError?> logMetadataInterceptor(
  ServiceCall call,
  ServiceMethod method,
) {
  print(method.name);
  print(call.clientMetadata);
}
