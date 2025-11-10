import 'package:shared/shared.dart';

part 'chat_message_model.g.dart';

@JsonSerializable()
class ChatMessageModel extends Equatable {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<dynamic>? data;
  final String? dataMD;

  const ChatMessageModel({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.data,
    this.dataMD,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);

  @override
  List<Object?> get props => [text, isUser, timestamp, data];
}
