import 'package:african_hospitals_client/african_hospitals_client.dart';
import 'package:african_hospitals_riverpod_client/african_hospitals_client_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final listHospitalsProvider = FutureProvider<List<Hospital>>((ref) {
  final hospitalsServiceClient = ref.read(hospitalsServiceClientProvider);
  return hospitalsServiceClient
      .listHospitals(ListHospitalsRequest())
      .then((response) => response.hospitals);
});
