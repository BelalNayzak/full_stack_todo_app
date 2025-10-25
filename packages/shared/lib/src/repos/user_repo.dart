import 'package:shared/src/models/user_model.dart';

abstract class UserRepo {
  Future<List<UserModel>> getAllUsers();
  Future<UserModel?> getUser(int id);
  Future<UserModel?> deleteUser(int id);
  Future<UserModel> addUser(UserModel userModel);
  Future<UserModel> updateUser(UserModel updatedUserModel);
}
