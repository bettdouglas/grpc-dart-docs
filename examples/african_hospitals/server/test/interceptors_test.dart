import 'dart:convert';
import 'dart:io';

import 'package:grpc/grpc.dart';
import 'package:hospitals/src/config.dart';
import 'package:hospitals/src/generated/index.dart';
import 'package:test/test.dart';
import 'package:firebase_dart/firebase_dart.dart';

void main() {
  final port = '8081';
  late Process p;
  late HospitalServiceClient hospitalServiceClient;
  late String token;

  setUpAll(() async {
    FirebaseDart.setup(storagePath: 'test');
    final user = await _getTestToken();
    addTearDown(() async => await user.delete());
    token = await user.getIdToken();
    p = await Process.start(
      'dart',
      ['run', 'bin/hospitals_server.dart'],
      environment: {'PORT': port},
    );

    // Wait for server to start and print to stdout.

    final stdOut = p.stdout.asBroadcastStream();
    stdOut.transform(utf8.decoder).forEach(print);

    await stdOut.first;
    final channel = ClientChannel(
      InternetAddress.anyIPv4,
      port: int.parse(port),
      options: ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );

    hospitalServiceClient = HospitalServiceClient(channel);
  });

  tearDownAll(() => p.kill());

  test('returns GrpcError.unathenticated if token is not supplied', () async {
    expect(
      () async => await hospitalServiceClient.listHospitals(
        ListHospitalsRequest(),
      ),
      throwsA(isA<GrpcError>()),
    );
  });
  test('returns List of hospitals if supplied token is valid', () async {
    await expectLater(
      hospitalServiceClient.listHospitals(
        ListHospitalsRequest(),
        options: CallOptions(metadata: {'token': token}),
      ),
      completion(isA<ListHospitalsResponse>()),
    );
  });
}

Future<User> _getTestToken() async {
  final app = await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotEnv.getOrElse(
        'apiKey',
        () => throw Exception('apiKey not defined'),
      ),
      appId: dotEnv.getOrElse(
        'appId',
        () => throw Exception('appId not defined'),
      ),
      messagingSenderId: dotEnv.getOrElse(
        'messagingSenderId',
        () => throw Exception('messagingSenderId not defined'),
      ),
      projectId: dotEnv.getOrElse(
        'PROJECT_ID',
        () => throw Exception('projectId not defined'),
      ),
      authDomain: dotEnv.getOrElse(
        'authDomain',
        () => throw Exception('authDomain not defined'),
      ),
    ),
  );

  final email = 'intergration_test_email1@gmail.com';
  final password = 'password';

  var auth = FirebaseAuth.instanceFor(app: app);
  final userCredential = await auth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
  final user = userCredential.user!;
  return user;
}
