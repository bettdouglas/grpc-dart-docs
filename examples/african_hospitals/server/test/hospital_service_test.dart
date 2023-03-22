import 'dart:io';

import 'package:grpc/grpc.dart';
import 'package:hospitals/src/generated/index.dart';
import 'package:test/test.dart';

void main() {
  final port = '443';
  late Process p;
  late HospitalServiceClient hospitalServiceClient;

  setUpAll(() async {
    // p = await Process.start(
    //   'dart',
    //   ['run', 'bin/hospitals_server.dart'],
    //   environment: {'PORT': port},
    // );

    // Wait for server to start and print to stdout.

    // final stdOut = p.stdout.asBroadcastStream();
    // stdOut.transform(utf8.decoder).forEach(print);

    // await stdOut.first;
    final channel = ClientChannel(
      'hospitals-grpc-server-of5ogbihaa-oa.a.run.app',
      port: int.parse(port),
      options: ChannelOptions(
        credentials: ChannelCredentials.secure(),
      ),
    );

    hospitalServiceClient = HospitalServiceClient(channel);
  });

  // tearDownAll(() => p.kill());
  final existingId = '58281511-980f-40f3-a391-f55fa3c685c8';

  group('GetHospital', () {
    test('can get hospital', () async {
      final hospital = await hospitalServiceClient.getHospital(
        GetHospitalRequest(id: existingId),
      );
      expect(hospital, isA<Hospital>());
      print(hospital);
    });
    test('throws GrpcError.notFound when not found', () async {
      await expectLater(
        () async => await hospitalServiceClient.getHospital(
          GetHospitalRequest(),
        ),
        throwsA(isA<GrpcError>()),
      );
    });
  });
  group('ListHospitals', () {
    test('returns List with 96,395 hospitals', () async {
      final response = await hospitalServiceClient.listHospitals(
        ListHospitalsRequest(),
      );
      expect(response.hospitals, hasLength(96395));
    });
  });

  group('SearchHospitals', () {
    test('returns hospitals with the specified names', () async {
      final response = await hospitalServiceClient.searchHospitals(
        SearchHospitalsRequest(name: 'Bula Matadi Health Centre'),
      );
      expect(response.hospitals, hasLength(1));
    });

    test('filters both name and country', () async {
      var response = await hospitalServiceClient.searchHospitals(
        SearchHospitalsRequest(
          name: 'Bula Matadi Health Centre',
          country: 'Kenya',
        ),
      );
      expect(response.hospitals, hasLength(0));

      response = await hospitalServiceClient.searchHospitals(
        SearchHospitalsRequest(
          name: 'Bula Matadi Health Centre',
          country: 'Angola',
        ),
      );
      expect(response.hospitals, hasLength(1));
    });

    test('returns hospitals which fall in Angola', () async {
      final response = await hospitalServiceClient.searchHospitals(
        SearchHospitalsRequest(country: 'Angola'),
      );
      expect(response.hospitals, hasLength(1435));
    });
  });
}
