import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:stormberry/stormberry.dart';
import 'package:stormberry_example/models/user.dart';

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  // final server = await serve(handler, ip, port);
  // print('Server listening on port ${server.port}');
  final env = DotEnv()..load();
  final database = getConnectionPool(env);
  final users = await database.users.queryCompleteViews();
  print(users);

  await database.close();
}

Database getConnectionPool(DotEnv env) {
  final host = env.getOrElse(
    'POSTGRES_HOST',
    () => throw Exception('POSTGRES_HOST is not defined in env'),
  );
  final port = env.getOrElse(
    'POSTGRES_PORT',
    () => throw Exception('POSTGRES_HOST is not defined in env'),
  );
  final database = env.getOrElse(
    'POSTGRES_DB',
    () => throw Exception('POSTGRES_DB is not defined in env'),
  );
  final user = env.getOrElse(
    'POSTGRES_USER',
    () => throw Exception('POSTGRES_USER is not defined in env'),
  );
  final password = env.getOrElse(
    'POSTGRES_PASSWORD',
    () => throw Exception('POSTGRES_PASSWORD is not defined in env'),
  );

  return Database(
    host: host,
    port: int.parse(port),
    database: database,
    user: user,
    password: password,
    useSSL: false,
  );
}
