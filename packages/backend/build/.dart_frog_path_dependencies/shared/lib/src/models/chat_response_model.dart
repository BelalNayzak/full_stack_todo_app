import 'package:shared/shared.dart';

part 'chat_response_model.g.dart';

@JsonSerializable()
class ChatResponseModel {
  final List<Map<String, dynamic>> responseData;
  final String? responseSummary;

  const ChatResponseModel({
    required this.responseSummary,
    required this.responseData,
  });

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ChatResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatResponseModelToJson(this);
}
