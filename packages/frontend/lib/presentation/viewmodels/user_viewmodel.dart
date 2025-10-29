import 'package:frontend_flutter/frontend.dart';

// State classes for different UI states
class UserState extends Equatable {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final String? message;

  const UserState({
    this.user,
    this.isLoading = false,
    this.error,
    this.message,
  });

  UserState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    String? message,
  }) {
    return UserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      message: message,
    );
  }

  @override
  List<Object?> get props => [user, isLoading, error, message];
}

// UserCubit class
class UserCubit extends Cubit<UserState> {
  final UserService _userService;

  UserCubit(this._userService) : super(const UserState());

  // Get user by ID
  Future<void> loadUserData() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final response = await _userService.getUserByToken(
        DioClient.instance.dio.options.headers['Authorization'],
      );

      emit(
        state.copyWith(
          user: response,
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
