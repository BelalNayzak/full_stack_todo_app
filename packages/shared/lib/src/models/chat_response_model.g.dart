// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatResponseModel _$ChatResponseModelFromJson(Map<String, dynamic> json) =>
    ChatResponseModel(
      responseSummary: json['responseSummary'] as String?,
      responseData: (json['responseData'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$ChatResponseModelToJson(ChatResponseModel instance) =>
    <String, dynamic>{
      'responseData': instance.responseData,
      'responseSummary': instance.responseSummary,
    };
