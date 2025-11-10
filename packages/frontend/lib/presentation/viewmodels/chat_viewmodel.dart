import 'package:frontend_flutter/frontend.dart';

class ChatState extends Equatable {
  final List<ChatMessageModel> messages;
  final bool isLoading;
  final String? error;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessageModel>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [messages, isLoading, error];
}

class ChatCubit extends Cubit<ChatState> {
  final ChatService _chatService;

  ChatCubit(this._chatService) : super(const ChatState());

  Future<void> sendMessage(int userId, String message) async {
    // Add user message
    final userMessage = ChatMessageModel(
      text: message,
      isUser: true,
      timestamp: DateTime.now(),
    );

    emit(
      state.copyWith(
        messages: [...state.messages, userMessage],
        isLoading: true,
        error: null,
      ),
    );

    try {
      final response = await _chatService.sendMessage(
        message: message,
        userId: userId,
      );

      // Add AI response
      final aiMessage = ChatMessageModel(
        text: response.message,
        isUser: false,
        timestamp: DateTime.now(),
        data: response.data,
      );

      emit(
        state.copyWith(
          messages: [...state.messages, aiMessage],
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          messages: [
            ...state.messages,
            ChatMessageModel(
              text: e is NetworkException
                  ? e.message
                  : 'Failed to send message, Try again later.',
              isUser: false,
              timestamp: DateTime.now(),
            ),
          ],
          isLoading: false,
          error: e is NetworkException
              ? e.message
              : 'Failed to send message, Try again later.',
        ),
      );
    }
  }

  void clearMessages() {
    emit(const ChatState());
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }
}
