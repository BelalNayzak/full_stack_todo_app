import 'package:shared/shared.dart';

part 'chat_response_model.g.dart';

@JsonSerializable()
class ChatResponseModel {
  final List<Map<String, dynamic>> responseData;
  final String? responseMsg;
  final String? usedQuery;
  final Map<String, dynamic>? usedQueryParams;

  const ChatResponseModel({
    required this.responseMsg,
    required this.responseData,
    required this.usedQuery,
    required this.usedQueryParams,
  });

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ChatResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatResponseModelToJson(this);
}
