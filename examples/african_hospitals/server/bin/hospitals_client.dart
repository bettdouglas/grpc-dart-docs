import 'dart:io';

import 'package:grpc/grpc.dart';
import 'package:hospitals/src/generated/hospitals.pbgrpc.dart';

void main(List<String> args) async {
  final port = 9980;
  final address = InternetAddress.anyIPv4;

  final channel = ClientChannel(
    // InternetAddress.anyIPv4,
    'hospitals-grpc-server-of5ogbihaa-oa.a.run.app',
    port: 443,
    options: ChannelOptions(
      credentials: ChannelCredentials.secure(),
    ),
  );

  final hospitalClient = HospitalServiceClient(channel);
  final response = await hospitalClient.listHospitals(ListHospitalsRequest());
  print(response);
}
