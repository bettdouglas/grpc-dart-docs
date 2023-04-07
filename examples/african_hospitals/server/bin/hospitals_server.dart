import 'dart:io';

import 'package:grpc/grpc.dart';
import 'package:hospitals/src/hospital_repository.dart';
import 'package:hospitals/src/hospital_service_impl.dart';
import 'package:hospitals/src/interceptors.dart';

void main(List<String> arguments) async {
  // we read the list of hospitals from csv
  final hospitals = await readHospitalsFromCsv();

  // Create instance of the repository
  final hospitalRepository = HospitalRepository(
    hospitals: hospitals.take(200).toList(),
  );

  // Create an instance of HospitalService
  final hospitalService = HospitalService(
    hospitalRepository: hospitalRepository,
  );

  final services = [hospitalService];
  final interceptors = <Interceptor>[
    authInterceptor,
  ];

  // Add the service to the server
  final server = Server(services, interceptors);

  // Start the server running on port 8080
  final address = InternetAddress.anyIPv4;
  final portEnvVariable = Platform.environment['PORT'];
  if (portEnvVariable == null) {
    throw Exception('PORT environment variable not defined');
  }
  final port = int.parse(portEnvVariable);
  await server.serve(address: address, port: port);
  print('Server running on $address on port $port');
}
