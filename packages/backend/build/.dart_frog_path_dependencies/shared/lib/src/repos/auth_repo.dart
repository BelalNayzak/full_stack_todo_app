import 'package:shared/shared.dart';

abstract class AuthRepo {
  Future<UserModel> register(UserModel userModel); // email & pass & name
  Future<String?> login(UserModel userModel); // email & pass & name(null)
  Future<void> logout();
}
