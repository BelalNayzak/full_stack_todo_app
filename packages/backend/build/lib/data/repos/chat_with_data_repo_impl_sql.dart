import 'package:backend_dart_frog/backend.dart';
import 'package:dio/dio.dart' as dio;
import 'package:logger/logger.dart'; // only used here to call the LLM

class ChatWithDataRepoImplSQL implements ChatWithDataRepo {
  final Pool connPool;

  ChatWithDataRepoImplSQL({required this.connPool});

  ///
  /// USING GEMENI : -----------------------------------------------
  ///

  @override
  // Future<ChatResponseModel> chatWithData(String userMsg) async {
  Future<dynamic> chatWithData(String userMsg) async {
    Logger x = Logger();

    x.i('xxxxxxxxxx 1 : $userMsg');

    // 1️⃣ Build prompt for LLM
    final prompt =
        '''
          You are a SQL generator for Postgres.
          Return valid JSON: {"sql": "...", "params": {}, "summary": "..."}
          Allowed only SELECT queries. Never modify data.

          Schema example:
          table todo(id int, user_id int, title text, desc text, status text, priority text);
          table user(id int, name text, email text, password text);

          User request: "$userMsg"
        ''';

    x.i('xxxxxxxxxx 2 : $prompt');

    // 2️⃣ Call LLM (Gemeni)
    final llmResponse = await dio.Dio().post(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${EnvConfigs.gemeniKey}',
      options: dio.Options(headers: {'Content-Type': 'application/json'}),
      data: {
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
      },
    );

    x.i('xxxxxxxxxx 3.1 : ${llmResponse.toString()}');
    x.i('xxxxxxxxxx 3.2 : ${llmResponse.data['candidates']}');
    x.i('xxxxxxxxxx 3.3 : ${llmResponse.data['candidates'][0]}');
    x.i('xxxxxxxxxx 3.4 : ${llmResponse.data['candidates'][0]['content']}');
    x.i(
      'xxxxxxxxxx 3.5 : ${llmResponse.data['candidates'][0]['content']['parts']}',
    );
    x.i(
      'xxxxxxxxxx 3.6 : ${llmResponse.data['candidates'][0]['content']['parts'][0]}',
    );
    x.i(
      'xxxxxxxxxx 3.7 : ${llmResponse.data['candidates'][0]['content']['parts'][0]['text']}',
    );

    final content =
        llmResponse.data['candidates'][0]['content']['parts'][0]['text'];
    x.i('xxxxxxxxxx 4 : ${content}');

    final sqlGeneratedQuery = (content['sql'] as String).trim();
    x.i('xxxxxxxxxx 5 : ${sqlGeneratedQuery}');

    final sqlGeneratedQueryParams = (content['params'] as String).trim();
    x.i('xxxxxxxxxx 6 : ${sqlGeneratedQueryParams}');

    // 3️⃣ Safety checks
    if (!sqlGeneratedQuery.toLowerCase().startsWith('select') ||
        sqlGeneratedQuery.contains(';')) {
      throw Exception({
        'Unsafe SQL Query. It seems you\'re requesting a heavy or a non authorized data',
      });
    }

    // 4️⃣ Excecute query to supabase (Postgres)
    final result = await connPool.execute(
      Sql.named(sqlGeneratedQuery),
      parameters: sqlGeneratedQueryParams,
    );

    x.i('xxxxxxxxxx :  ${result.toString()}');

    return result;

    // final data = result
    //     .map((record) => ChatResponseModel.fromJson(record.toColumnMap()))
    //     .toList();

    // return data.first;
  }

  ///
  /// USING OPEN AI : -----------------------------------------------
  ///

  @override
  Future<ChatResponseModel> _chatWithData(String userMsg) async {
    // 1️⃣ Build prompt for LLM
    final prompt =
        '''
          You are a SQL generator for Postgres.
          Return valid JSON: {"sql": "...", "params": {}, "summary": "..."}
          Allowed only SELECT queries. Never modify data.

          Schema example:
          table todo(id int, user_id int, title text, desc text, status text, priority text);
          table user(id int, name text, email text, password text);

          User request: "$userMsg"
        ''';

    // 2️⃣ Call LLM (OpenAI)
    final llmResponse = await dio.Dio().post(
      'https://api.openai.com/v1/chat/completions',
      options: dio.Options(
        headers: {
          'Authorization': 'Bearer ${EnvConfigs.openAIKey}',
          'Content-Type': 'application/json',
        },
      ),
      data: {
        'model': 'gpt-4o-mini',
        'messages': [
          {'role': 'system', 'content': 'You are a Postgres SQL generator.'},
          {'role': 'user', 'content': prompt},
        ],
        'response_format': {'type': 'json_object'},
      },
    );

    final content = llmResponse.data['choices'][0]['message']['content'];
    final sqlGeneratedQuerey = (content['sql'] as String).trim();
    final sqlGeneratedQueryParams = (content['params'] as String).trim();

    // 3️⃣ Safety checks
    if (!sqlGeneratedQuerey.toLowerCase().startsWith('select') ||
        sqlGeneratedQuerey.contains(';')) {
      throw Exception(
        Response.json(statusCode: 400, body: {'error': 'Unsafe SQL'}),
      );
    }

    // 4️⃣ Excecute query to supabase (Postgres)
    final result = await connPool.execute(
      Sql.named(sqlGeneratedQuerey),
      parameters: sqlGeneratedQueryParams,
    );

    final data = result
        .map((record) => ChatResponseModel.fromJson(record.toColumnMap()))
        .toList();

    return data.first;
  }
}
