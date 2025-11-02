import 'package:backend_dart_frog/backend.dart';
import 'package:dotenv/dotenv.dart' as dotenv;

// Load .env locally + platform environment on Render
final _env = dotenv.DotEnv(includePlatformEnvironment: true)..load();

// Helper to get environment variables (Render > .env > fallback)
String getEnv(String key, {String? fallback}) =>
    Platform.environment[key] ?? _env[key] ?? fallback ?? '';

class EnvConfigs {
  const EnvConfigs._();

  // Match Render/Supabase env vars
  static String get tokenSecret => getEnv('TOKEN_SECRET', fallback: 'secret');
  static String get dbHost => getEnv('SUPABASE_HOST', fallback: 'localhost');
  static String get dbName => getEnv('SUPABASE_DB', fallback: 'postgres');
  static String get dbUserName => getEnv('SUPABASE_USER', fallback: 'postgres');
  static String get dbPassword => getEnv('SUPABASE_PASS', fallback: '');
  static int get dbPort =>
      int.tryParse(getEnv('PORT', fallback: '5432')) ?? 5432;
  static int get dbMaxConnCount =>
      int.tryParse(getEnv('DB_MAX_CONN_COUNT', fallback: '10')) ?? 10;

  // Detect production
  static bool get isProduction =>
      getEnv('IS_PRODUCTION', fallback: 'false') == 'true';
}

// Create ONE global Postgres pool
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
    // Supabase requires SSL in production
    sslMode: EnvConfigs.isProduction ? SslMode.disable : SslMode.disable,
    maxConnectionCount: EnvConfigs.dbMaxConnCount,
  ),
);
