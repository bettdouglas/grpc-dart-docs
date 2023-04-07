import 'package:african_hospitals_client/african_hospitals_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hospitalsServiceClientProvider = Provider(
  (ref) => AfricanHospitalsClient.client(
    host: '10.0.2.2',
    isSecure: false,
    port: 9980,
    interceptors: [],
  ),
);
