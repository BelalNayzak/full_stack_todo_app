import 'package:shared/shared.dart';

abstract class AuthRepo {
  Future<String?> login(int userId);
  Future<UserModel> register(UserModel userModel);
}
