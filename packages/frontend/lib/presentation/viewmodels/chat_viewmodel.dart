import 'package:frontend_flutter/frontend.dart';

class ChatMessage extends Equatable {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<dynamic>? data;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.data,
  });

  @override
  List<Object?> get props => [text, isUser, timestamp, data];
}

class ChatState extends Equatable {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
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

  Future<void> sendMessage(String message, int userId) async {
    // Add user message
    final userMessage = ChatMessage(
      text: message,
      isUser: true,
      timestamp: DateTime.now(),
    );

    emit(state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
    ));

    try {
      final response = await _chatService.sendMessage(
        message: message,
        userId: userId,
      );

      // Add AI response
      final aiMessage = ChatMessage(
        text: response.message,
        isUser: false,
        timestamp: DateTime.now(),
        data: response.data,
      );

      emit(state.copyWith(
        messages: [...state.messages, aiMessage],
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e is NetworkException
            ? e.message
            : 'Failed to send message',
      ));
    }
  }

  void clearMessages() {
    emit(const ChatState());
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }
}
