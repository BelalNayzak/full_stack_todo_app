import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/shared.dart';

import '../../core/network/network_exception.dart';
import '../../data/models/create_user_dto.dart';
import '../../data/services/user_service.dart';

// State classes for different UI states
class UserState extends Equatable {
  final List<UserModel> users;
  final UserModel? selectedUser;
  final bool isLoading;
  final String? error;
  final String? message;

  const UserState({
    this.users = const [],
    this.selectedUser,
    this.isLoading = false,
    this.error,
    this.message,
  });

  UserState copyWith({
    List<UserModel>? users,
    UserModel? selectedUser,
    bool? isLoading,
    String? error,
    String? message,
  }) {
    return UserState(
      users: users ?? this.users,
      selectedUser: selectedUser ?? this.selectedUser,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      message: message,
    );
  }

  @override
  List<Object?> get props => [users, selectedUser, isLoading, error, message];
}

// UserCubit class
class UserCubit extends Cubit<UserState> {
  final UserService _userService;

  UserCubit(this._userService) : super(const UserState());

  // Load all users
  Future<void> loadUsers() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final response = await _userService.getAllUsers();
      if (response.success) {
        emit(
          state.copyWith(
            users: response.data ?? [],
            isLoading: false,
            message: response.message,
          ),
        );
      } else {
        emit(state.copyWith(isLoading: false, error: response.message));
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e is NetworkException
              ? e.message
              : 'An unexpected error occurred',
        ),
      );
    }
  }

  // Create a new user
  Future<void> createUser({required String name, required String email}) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final createUserDto = CreateUserDto(name: name, email: email);

      final response = await _userService.createUser(createUserDto);
      if (response.success && response.data != null) {
        final updatedUsers = [response.data!, ...state.users];
        emit(
          state.copyWith(
            users: updatedUsers,
            isLoading: false,
            message: response.message,
          ),
        );
      } else {
        emit(state.copyWith(isLoading: false, error: response.message));
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e is NetworkException
              ? e.message
              : 'An unexpected error occurred',
        ),
      );
    }
  }

  // Select a user
  void selectUser(UserModel user) {
    emit(state.copyWith(selectedUser: user));
  }

  // Get user by ID
  UserModel? getUserById(int id) {
    try {
      return state.users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  // Clear error message
  void clearError() {
    emit(state.copyWith(error: null));
  }

  // Clear success message
  void clearMessage() {
    emit(state.copyWith(message: null));
  }
}
