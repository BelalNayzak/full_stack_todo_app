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
  Future<ChatResponseModel> chatWithData(int userId, String userMsg) async {
    String sqlGeneratedQuery = '';
    Map<String, dynamic> sqlGeneratedQueryParams = {};
    String sqlGeneratedQueryMsg = '';

    try {
      // 2️⃣ Call LLM (Gemeni)
      final llmResponse = await dio.Dio().post(
        'https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=${EnvConfigs.gemeniKey}',
        options: dio.Options(headers: {'Content-Type': 'application/json'}),
        data: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': _buildAiPrompt(userId, userMsg)},
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

      sqlGeneratedQuery = (llmParsedData['sql'] as String).trim();
      sqlGeneratedQueryParams = llmParsedData['params'];
      sqlGeneratedQueryMsg = llmParsedData['summary'];

      // 3️⃣ Safety checks
      if (sqlGeneratedQuery.toLowerCase().contains('delete') ||
          sqlGeneratedQuery.toLowerCase().contains('post') ||
          sqlGeneratedQuery.toLowerCase().contains('put') ||
          sqlGeneratedQuery.toLowerCase().contains('truncate')) {
        throw Exception({'Unsafe SQL Query.'});
      }

      // 4️⃣ Excecute query to supabase (Postgres)
      final result = await connPool.execute(
        Sql.named(sqlGeneratedQuery),
        parameters: sqlGeneratedQueryParams,
      );

      final data = result.map((record) => record.toColumnMap()).toList();

      return ChatResponseModel(
        usedQuery: sqlGeneratedQuery,
        usedQueryParams: sqlGeneratedQueryParams,
        responseMsg: sqlGeneratedQueryMsg,
        responseData: data,
      );
    } on dio.DioException catch (e) {
      throw Exception({
        'Dio error': e.response?.data,
        'Status code': e.response?.statusCode,
        'Message': e.message,
        'sqlGeneratedQuery': sqlGeneratedQuery,
        'sqlGeneratedQueryParams': sqlGeneratedQueryParams,
        'sqlGeneratedQueryMsg': sqlGeneratedQueryMsg,
      });
    } catch (e) {
      throw Exception({
        'Other error': e.toString(),
        'sqlGeneratedQuery': sqlGeneratedQuery,
        'sqlGeneratedQueryParams': sqlGeneratedQueryParams,
        'sqlGeneratedQueryMsg': sqlGeneratedQueryMsg,
      });
    }
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

// 1️⃣ Build prompt for LLM
String _buildAiPrompt(int userId, String userMsg) {
  return '''
          You are a SQL generator for Postgres.
          Return ONLY valid JSON (no markdown, no code fences, no explanations).
          When generating SQL, always:
          - Use single quotes ('...') for string values.
          - Do NOT use double quotes for strings.
          - Do NOT wrap keywords like SELECT, FROM, WHERE in quotes.
          - Wrap table names and column names like todo, user in double quotes.
          - Use User's ID to get ONLY user's related data (knowing that: user_id = $userId).
          - Do NOT get any data that is not attached to that user (user in not authorized to get any data not attached to him somehow).
          - Refer to named parameters with the @ sign (example:  SELECT * FROM "table_name" WHERE "id" = @id RETURNING *)
          - Return everything from the server responser (example:  ...RETURNING *)

          Return JSON in this format:
          {
            "sql": "...",
            "params": {
              "key": value,
              ...
            },
            "summary": "..."
          }
          Allowed only SELECT queries. Never modify data.

          Schema example:
          table todo(id int, user_id int, title text, desc text, status text, priority text);
          table user(id int, name text, email text, password text);

          Knowing that:
          - The status in the todo table must be string a value of these values only ("todo", "inProgress", "done")
          - The priority in the todo table must be a string value of these values only ("low", "medium", "high")

          User request: "$userMsg"
        ''';
}
