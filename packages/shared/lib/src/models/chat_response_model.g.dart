// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatResponseModel _$ChatResponseModelFromJson(Map<String, dynamic> json) =>
    ChatResponseModel(
      responseMsg: json['responseMsg'] as String?,
      responseData: (json['responseData'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      responseDataMD: json['responseDataMD'] as String?,
      usedQuery: json['usedQuery'] as String?,
      usedQueryParams: json['usedQueryParams'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ChatResponseModelToJson(ChatResponseModel instance) =>
    <String, dynamic>{
      'responseData': instance.responseData,
      'responseDataMD': instance.responseDataMD,
      'responseMsg': instance.responseMsg,
      'usedQuery': instance.usedQuery,
      'usedQueryParams': instance.usedQueryParams,
    };
