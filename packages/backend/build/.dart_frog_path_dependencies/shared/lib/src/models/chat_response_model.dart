import 'package:shared/shared.dart';

part 'chat_response_model.g.dart';

@JsonSerializable()
class ChatResponseModel {
  final int? id;
  final Map<String, dynamic> rows;
  final String? responseMsg;

  const ChatResponseModel({
    required this.id,
    required this.rows,
    required this.responseMsg,
  });

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ChatResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatResponseModelToJson(this);
}
