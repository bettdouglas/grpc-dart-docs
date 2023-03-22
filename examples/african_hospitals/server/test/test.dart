import 'package:firebase_auth_admin_verify/firebase_auth_admin_verify.dart';
import 'package:firebase_dart/firebase_dart.dart';
import 'package:firebase_dart/implementation/testing.dart';
import 'package:test/test.dart';

void main() {
  test('verifies token successfully', () async {
    final token = await _getTestToken();
    final jwt = await verifyFirebaseToken(
      token,
      serviceFilePath: 'service-account.json',
      projectId: 'my_project',
    );
  });
}

Future<String> _getTestToken() async {
  await FirebaseTesting.setup();

  final app = await Firebase.initializeApp(
    options: FirebaseOptions(
        appId: 'my_app_id',
        apiKey: 'apiKey',
        projectId: 'my_project',
        messagingSenderId: 'ignore',
        authDomain: 'my_project.firebaseapp.com'),
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
