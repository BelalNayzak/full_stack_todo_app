import 'package:backend_dart_frog/backend.dart';
import 'package:dotenv/dotenv.dart' as dotenv;

// init & load .env variables
final _env = dotenv.DotEnv(includePlatformEnvironment: true)..load();

// Create ONE global connections pool at startup,
// And dart frog operates this connPool effeciently behind the scene for your requests.
final connectionPool = Pool.withEndpoints(
  [
    Endpoint(
      host: EnvConfigs.dbHost,
      database: EnvConfigs.dbName,
      username: EnvConfigs.dbUserName,
      password: EnvConfigs.dbPassword,
      port: EnvConfigs.dbPort,
    ),
  ],
  settings: PoolSettings(
    // 👈 disable SSL for local use ONLY !
    sslMode: SslMode.disable,
    // up to 10 concurrent connections
    maxConnectionCount: EnvConfigs.dbMaxConnCount,
  ),
);

String getEnv(String key, {String? fallback}) =>
    Platform.environment[key] ?? _env[key] ?? fallback ?? '';

class EnvConfigs {
  const EnvConfigs._();

  static String get tokenSecret => getEnv('TOKEN_SECRET');

  static String get dbHost => getEnv('DB_HOST', fallback: 'localhost');
  static int get dbPort =>
      int.tryParse(getEnv('DB_PORT', fallback: '5432')) ?? 5432;
  static String get dbUserName => getEnv('DB_USERNAME', fallback: 'postgres');
  static String get dbPassword => getEnv('DB_PASSWORD', fallback: '');
  static String get dbName => getEnv('DB_NAME', fallback: 'mydb');

  static int get dbMaxConnCount =>
      int.tryParse(getEnv('DB_MAX_CONN_COUNT', fallback: '10')) ?? 10;
}
