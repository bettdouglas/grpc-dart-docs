/// A Very Good Project created by Very Good CLI.
library african_hospitals_client;

import 'package:african_hospitals_client/african_hospitals_client.dart';
import 'package:build_grpc_channel/build_grpc_channel.dart';
import 'package:grpc/grpc.dart';

export 'src/african_hospitals_client.dart';
export 'src/generated/index.dart';

/// Class to access african_hospitals_client utitilies
class AfricanHospitalsClient {
  /// Creates an instance of the hospital service client.
  /// required the host, port and whether the traffic is secured or not
  static HospitalServiceClient client({
    required String host,
    required int port,
    required bool isSecure,
    required Iterable<ClientInterceptor>? interceptors,
  }) {
    return HospitalServiceClient(
      buildGrpcChannel(
        host: host,
        port: port,
        secure: isSecure,
      ),
      interceptors: interceptors,
    );
  }
}
