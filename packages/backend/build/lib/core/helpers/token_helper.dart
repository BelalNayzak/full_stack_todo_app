import 'package:backend_dart_frog/backend.dart';

class TokenHelper {
  static generateToken(int userId) {
    final tokenSecret = EnvConfigs.tokenSecret;

    // create json web token and sign it
    final jwt = JWT({
      'sub': userId.toString(),
      'iat': DateTime.now().millisecondsSinceEpoch, // issued at
      'exp': DateTime.now()
          .add(const Duration(days: 30))
          .millisecondsSinceEpoch, // expires in
    });

    return jwt.sign(
      SecretKey(tokenSecret),
      expiresIn: const Duration(days: 30),
      algorithm: JWTAlgorithm.HS256,
    );
  }

  static int? verifyToken(String token) {
    try {
      final tokenSecret = EnvConfigs.tokenSecret;

      final payload = JWT.verify(
        token,
        SecretKey(tokenSecret),
      );

      final data = payload.payload as Map<String, dynamic>;

      return int.tryParse(data['sub'] as String? ?? '');
    } catch (e) {
      return null;
    }
  }
}
