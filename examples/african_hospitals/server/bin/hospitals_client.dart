import 'dart:io';

import 'package:grpc/grpc.dart';
import 'package:hospitals/src/generated/hospitals.pbgrpc.dart';

void main(List<String> args) {
  final port = 8080;
  final address = InternetAddress.anyIPv4;

  final channel = ClientChannel(
    InternetAddress.anyIPv4,
    port: port,
    options: ChannelOptions(
      credentials: ChannelCredentials.insecure(),
    ),
  );

  final hospitalClient = HospitalServiceClient(channel);
}
