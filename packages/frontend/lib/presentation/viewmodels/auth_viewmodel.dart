import 'package:frontend_flutter/frontend.dart';

class AuthState extends Equatable {
  final bool isLoading;
  final String? error;
  final String? message;
  final String? token;
  final UserModel? user;

  const AuthState({
    this.isLoading = false,
    this.error,
    this.message,
    this.token,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    String? message,
    String? token,
    UserModel? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      message: message,
      token: token,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, message, user];
}

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit(this._authService) : super(const AuthState());

  Future<void> signup({required UserModel userModel}) async {
    emit(state.copyWith(isLoading: true, error: null, message: null));
    try {
      final newUser = await _authService.register(userModel);
      emit(
        state.copyWith(
          isLoading: false,
          user: newUser,
          message: 'Signup successful. You can login now.',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e is NetworkException ? e.message : 'Signup failed',
        ),
      );
    }
  }

  Future<void> login({required UserModel userModel}) async {
    emit(state.copyWith(isLoading: true, error: null, message: null));
    try {
      final token = await _authService.login(userModel);
      if (token != null) {
        DioClient.instance.updateTokenInHeaders(token);
        emit(
          state.copyWith(
            isLoading: false,
            message: 'Login successful.',
            token: token,
          ),
        );
      } else {
        emit(state.copyWith(isLoading: false, error: 'Invalid credentials'));
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e is NetworkException ? e.message : 'Login failed',
        ),
      );
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(isLoading: true, error: null, message: null));
    try {
      await _authService.logout();
      DioClient.instance.updateTokenInHeaders('');
      emit(
        state.copyWith(isLoading: false, message: 'Logged out successfully.'),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e is NetworkException ? e.message : 'Logout failed',
        ),
      );
    }
  }

  void clearError() => emit(state.copyWith(error: null));

  void clearMessage() => emit(state.copyWith(message: null));
}
