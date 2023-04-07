import 'package:african_hospitals_client/african_hospitals_client.dart';
import 'package:african_hospitals_riverpod_client/african_hospitals_client_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc/grpc.dart';

final getHospitalProvider = FutureProviderFamily((ref, String id) {
  final hospitalServiceClient = ref.read(hospitalsServiceClientProvider);
  try {
    return hospitalServiceClient.getHospital(GetHospitalRequest(id: id));
  } on GrpcError catch (e) {
    if (e.code == StatusCode.notFound) {
      return null;
    }
    rethrow;
  }
});
