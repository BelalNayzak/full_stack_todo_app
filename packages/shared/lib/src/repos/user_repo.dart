import 'package:shared/shared.dart';

abstract class UserRepo {
  Future<UserModel> createUser(UserModel userModel);
  Future<List<UserModel>> getAllUsers();
  Future<UserModel?> getUserById(int id);
  Future<UserModel?> getUserByEmail(String email);
  Future<UserModel?> updateUser(UserModel updatedUserModel);
  Future<UserModel?> deleteUser(int id);
}
