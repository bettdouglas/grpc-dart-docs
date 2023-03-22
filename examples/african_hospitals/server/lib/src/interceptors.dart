import 'dart:async';

import 'package:firebase_auth_admin_verify/firebase_auth_admin_verify.dart';
import 'package:grpc/grpc.dart';
import 'package:hospitals/src/config.dart';

FutureOr<GrpcError?> logMetadataInterceptor(
  ServiceCall call,
  ServiceMethod method,
) {
  print(method.name);
  print(call.clientMetadata);
  return null;
}

Future<GrpcError?> authInterceptor(
  ServiceCall call,
  ServiceMethod method,
) async {
  final metadata = call.clientMetadata ?? {};
  final idToken = metadata['token'];
  if (idToken == null) {
    return GrpcError.unauthenticated('Token not found');
  }
  try {
    final verifiedJwt = await verifyFirebaseToken(
      idToken,
      projectId: dotEnv.getOrElse(
        'PROJECT_ID',
        () => throw Exception('PROJECT_ID not defined in .env'),
      ),
      serviceFilePath: dotEnv.getOrElse(
        'SERVICE_ACCOUNT_FILE_PATH',
        () => throw Exception('SERVICE_FILE_PATH not defined in .env'),
      ),
    );
    final payload = verifiedJwt.payload;
    print(payload);
  } on FirebaseVerifyException catch (e) {
    return GrpcError.unauthenticated(e.message);
  }
  return null;
}
