import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth_admin_verify/firebase_auth_admin_verify.dart';
import 'package:firebase_dart/implementation/testing.dart';
import 'package:grpc/grpc.dart';
import 'package:hospitals/src/config.dart';
import 'package:hospitals/src/generated/index.dart';
import 'package:test/test.dart';
import 'package:firebase_dart/firebase_dart.dart';

void main() {
  final port = '8081';
  late Process p;
  late HospitalServiceClient hospitalServiceClient;

  setUpAll(() async {
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

  test('returns GrpcError.unathenticated if token is not supplied', () {});
  test('returns GrpcError.unathenticated if token is not supplied', () {});
  test('returns List of hospitals if supplied token is valid', () async {
    final token = await _getTestToken();
    await expectLater(
      hospitalServiceClient.listHospitals(
        ListHospitalsRequest(),
        options: CallOptions(metadata: {'token': token}),
      ),
      completion(isA<ListHospitalsResponse>()),
    );
  });
}

Future<String> _getTestToken() async {
  await FirebaseTesting.setup();

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
  var backend = FirebaseTesting.getBackend(app.options);

  final email = 'intergration_test_email@gmail.com';
  final password = 'password';

  final user = await backend.authBackend.createUser(
    email: email,
    password: password,
  );

  // final token = await backend.authBackend.generateIdToken(uid: uid, providerId: providerId)
  var auth = FirebaseAuth.instanceFor(app: app);
  final cred = await auth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
  return await backend.authBackend.generateIdToken(
    uid: cred.user!.uid,
    providerId: cred.additionalUserInfo!.providerId!,
  );
}
