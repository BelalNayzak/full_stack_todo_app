// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatResponseModel _$ChatResponseModelFromJson(Map<String, dynamic> json) =>
    ChatResponseModel(
      id: (json['id'] as num?)?.toInt(),
      rows: json['rows'] as Map<String, dynamic>,
      responseMsg: json['responseMsg'] as String?,
    );

Map<String, dynamic> _$ChatResponseModelToJson(ChatResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rows': instance.rows,
      'responseMsg': instance.responseMsg,
    };
