import 'package:frontend_flutter/frontend.dart';

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
  Future<void> loadAllUsers() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final response = await _userService.getAllUsers();
      emit(
        state.copyWith(
          users: response,
          isLoading: false,
          message: 'All users loaded successfully.',
        ),
      );
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
  Future<void> createUser({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final userModel = UserModel(
        name: name,
        email: email,
        password: password,
        id: null,
      );
      final response = await _userService.createUser(userModel);
      final updatedUsers = [response, ...state.users];
      emit(
        state.copyWith(
          users: updatedUsers,
          isLoading: false,
          message: 'User added successfully.',
        ),
      );
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

  // get user by email
  Future<void> getUserByEmail({required String email}) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final response = await _userService.getUserByEmail(email);

      emit(
        state.copyWith(
          users: [response!],
          isLoading: false,
          message: 'User loaded successfully.',
        ),
      );
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

  // Get user by ID
  Future<void> getUserById(int id) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final response = await _userService.getUserById(id);

      emit(
        state.copyWith(
          users: [response],
          isLoading: false,
          message: 'User loaded successfully.',
        ),
      );
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

  // Clear error message
  void clearError() {
    emit(state.copyWith(error: null));
  }

  // Clear success message
  void clearMessage() {
    emit(state.copyWith(message: null));
  }
}
