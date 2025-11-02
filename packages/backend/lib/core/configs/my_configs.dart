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
      port: EnvConfigs.isProduction ? EnvConfigs.dbPort : 5432,
    ),
  ],
  settings: PoolSettings(
    // disable SSL for local use ONLY but enable it for production!
    sslMode: EnvConfigs.isProduction ? SslMode.require : SslMode.disable,
    // up to 10 concurrent connections
    maxConnectionCount: EnvConfigs.dbMaxConnCount,
  ),
);

String getEnv(String key, {String? fallback}) =>
    Platform.environment[key] ?? _env[key] ?? fallback ?? '';

class EnvConfigs {
  const EnvConfigs._();

  static String get tokenSecret => getEnv('TOKEN_SECRET');
  static String get dbHost => Platform.environment['DB_HOST'] ?? 'localhost';
  static String get dbName => Platform.environment['DB_NAME'] ?? 'postgres';
  static String get dbUserName =>
      Platform.environment['DB_USERNAME'] ?? 'postgres';
  static String get dbPassword => Platform.environment['DB_PASSWORD'] ?? '';
  static int get dbPort =>
      int.tryParse(Platform.environment['DB_PORT'] ?? '5432') ?? 5432;
  static int get dbMaxConnCount =>
      int.tryParse(Platform.environment['DB_MAX_CONN_COUNT'] ?? '10') ?? 10;

  static bool get isProduction =>
      Platform.environment['IS_PRODUCTION'] == 'true';
}
