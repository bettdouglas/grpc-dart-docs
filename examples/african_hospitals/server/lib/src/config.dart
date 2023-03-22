import 'package:dotenv/dotenv.dart';

final dotEnv = DotEnv(includePlatformEnvironment: true)..load(['.env']);
