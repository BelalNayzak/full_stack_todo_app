import 'dart:convert';

import 'package:backend_dart_frog/backend.dart';
import 'package:dio/dio.dart' as dio;

class ChatWithDataRepoImplSQL implements ChatWithDataRepo {
  final Pool connPool;

  ChatWithDataRepoImplSQL({required this.connPool});

  ///
  /// USING GEMENI : -----------------------------------------------
  ///

  @override
  // Future<ChatResponseModel> chatWithData(String userMsg) async {
  Future<dynamic> chatWithData(String userMsg) async {
    // 1️⃣ Build prompt for LLM
    final prompt =
        '''
          You are a SQL generator for Postgres.
          Return ONLY valid JSON (no markdown, no code fences, no explanations, no text outside JSON).
          Format:
          {
            "sql": "...",
            "params": {},
            "summary": "..."
          }
          Allowed only SELECT queries. Never modify data.

          Schema example:
          table todo(id int, user_id int, title text, desc text, status text, priority text);
          table user(id int, name text, email text, password text);

          knowing that:
          The status in the todo table must be a value of these values only ("todo", "inProgress", "done")
          and The priority in the todo table must be a value of these values only ("low", "medium", "high")

          User request: "$userMsg"
        ''';

    // 2️⃣ Call LLM (Gemeni)
    final llmResponse = await dio.Dio().post(
      'https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=${EnvConfigs.gemeniKey}',
      options: dio.Options(headers: {'Content-Type': 'application/json'}),
      data: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
      }),
    );

    final content =
        llmResponse.data['candidates'][0]['content']['parts'][0]['text'];

    final cleaned = content
        .replaceAll(RegExp(r'```json'), '')
        .replaceAll(RegExp(r'```'), '')
        .trim();

    final llmParsedData = jsonDecode(cleaned);

    final sqlGeneratedQuery = (llmParsedData['sql'] as String).trim();

    final sqlGeneratedQueryParams = (llmParsedData['params'] as String).trim();

    return llmResponse.data;

    // // 3️⃣ Safety checks
    // if (!sqlGeneratedQuery.toLowerCase().startsWith('select') ||
    //     sqlGeneratedQuery.contains(';')) {
    //   throw Exception({
    //     'Unsafe SQL Query. It seems you\'re requesting a heavy or a non authorized data',
    //   });
    // }

    // // 4️⃣ Excecute query to supabase (Postgres)
    // final result = await connPool.execute(
    //   Sql.named(sqlGeneratedQuery),
    //   parameters: sqlGeneratedQueryParams,
    // );

    // x.i('xxxxxxxxxx :  ${result.toString()}');

    // return result;

    // final data = result
    //     .map((record) => ChatResponseModel.fromJson(record.toColumnMap()))
    //     .toList();

    // return data.first;
  }

  ///
  /// USING OPEN AI : -----------------------------------------------
  ///

  // @override
  // Future<ChatResponseModel> _chatWithData(String userMsg) async {
  //   // 1️⃣ Build prompt for LLM
  //   final prompt =
  //       '''
  //         You are a SQL generator for Postgres.
  //         Return valid JSON: {"sql": "...", "params": {}, "summary": "..."}
  //         Allowed only SELECT queries. Never modify data.

  //         Schema example:
  //         table todo(id int, user_id int, title text, desc text, status text, priority text);
  //         table user(id int, name text, email text, password text);

  //         User request: "$userMsg"
  //       ''';

  //   // 2️⃣ Call LLM (OpenAI)
  //   final llmResponse = await dio.Dio().post(
  //     'https://api.openai.com/v1/chat/completions',
  //     options: dio.Options(
  //       headers: {
  //         'Authorization': 'Bearer ${EnvConfigs.openAIKey}',
  //         'Content-Type': 'application/json',
  //       },
  //     ),
  //     data: {
  //       'model': 'gpt-4o-mini',
  //       'messages': [
  //         {'role': 'system', 'content': 'You are a Postgres SQL generator.'},
  //         {'role': 'user', 'content': prompt},
  //       ],
  //       'response_format': {'type': 'json_object'},
  //     },
  //   );

  //   final content = llmResponse.data['choices'][0]['message']['content'];
  //   final sqlGeneratedQuerey = (content['sql'] as String).trim();
  //   final sqlGeneratedQueryParams = (content['params'] as String).trim();

  //   // 3️⃣ Safety checks
  //   if (!sqlGeneratedQuerey.toLowerCase().startsWith('select') ||
  //       sqlGeneratedQuerey.contains(';')) {
  //     throw Exception(
  //       Response.json(statusCode: 400, body: {'error': 'Unsafe SQL'}),
  //     );
  //   }

  //   // 4️⃣ Excecute query to supabase (Postgres)
  //   final result = await connPool.execute(
  //     Sql.named(sqlGeneratedQuerey),
  //     parameters: sqlGeneratedQueryParams,
  //   );

  //   final data = result
  //       .map((record) => ChatResponseModel.fromJson(record.toColumnMap()))
  //       .toList();

  //   return data.first;
  // }
}
