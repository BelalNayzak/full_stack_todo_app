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
      final llmResponseQuery = await _getAiQuery(userId, userMsg);

      _extractDataFromAiResponse(
        llmResponseQuery,
        sqlGeneratedQuery,
        sqlGeneratedQueryParams,
        sqlGeneratedQueryMsg,
      );

      // 3️⃣ Safety checks
      _assureDatabaseSafeActions(sqlGeneratedQuery);

      // 4️⃣ Excecute query to supabase (Postgres)
      final result = await connPool.execute(
        Sql.named(sqlGeneratedQuery),
        parameters: sqlGeneratedQueryParams,
      );

      final data = result.map((record) => record.toColumnMap()).toList();

      // get ai mmd
      final llmResponseMmd = await _getAiMmd(userMsg);

      _extractDataFromAiResponse(
        llmResponseMmd,
        sqlGeneratedQuery,
        sqlGeneratedQueryParams,
        sqlGeneratedQueryMsg,
      );

      final mmdChatResponseModel = ChatResponseModel(
        usedQuery: sqlGeneratedQuery,
        usedQueryParams: sqlGeneratedQueryParams,
        responseMsg: sqlGeneratedQueryMsg,
        responseData: data,
      );

      return mmdChatResponseModel;
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

  _getAiQuery(int userId, String userMsg) async {
    return await dio.Dio().post(
      'https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=${EnvConfigs.gemeniKey}',
      options: dio.Options(headers: {'Content-Type': 'application/json'}),
      data: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': _buildSqlQueryAiPrompt(userId, userMsg)},
            ],
          },
        ],
      }),
    );
  }

  _extractDataFromAiResponse(
    llmResponse,
    sqlGeneratedQuery,
    sqlGeneratedQueryParams,
    sqlGeneratedQueryMsg,
  ) async {
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
  }

  _getAiMmd(String userMsg) async {
    return await dio.Dio().post(
      'https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=${EnvConfigs.gemeniKey}',
      options: dio.Options(headers: {'Content-Type': 'application/json'}),
      data: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': _buildMmdAiPrompt(userMsg)},
            ],
          },
        ],
      }),
    );
  }

  _assureDatabaseSafeActions(sqlGeneratedQuery) async {
    if (sqlGeneratedQuery.toLowerCase().contains('delete') ||
        sqlGeneratedQuery.toLowerCase().contains('post') ||
        sqlGeneratedQuery.toLowerCase().contains('put') ||
        sqlGeneratedQuery.toLowerCase().contains('truncate')) {
      throw Exception({'Unsafe SQL Query.'});
    }
  }

  // 1️⃣ Build prompt for LLM
  String _buildSqlQueryAiPrompt(int userId, String userMsg) {
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
          - Refer to named parameters with the @ sign (example:  SELECT * FROM "table_name" WHERE "id" = @id)

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

  String _buildMmdAiPrompt(String userMsg) {
    return '''
          You are an Intelligent Markdown Response Generator.

          Your job:

          Convert SQL query results + metadata into a fully polished, human-friendly Markdown report.

          Core Rules:

          - Output Markdown only (tables, charts, headings, code blocks, diagrams, notes).
          - Never output JSON or raw SQL.
          - Never explain internal reasoning.
          - Never output plain text outside Markdown.
          - Dynamically adapt the layout based on the meaning of the data.

          Smart Behavior:

          You MUST: 
          - Understand semantic meaning of fields like: status, priority, title, email, timestamps, etc.
          - Understand semantic domain (todos, users, analytics). 
          - Auto-generate:
              - Summary tables
              - Metrics boxes
              - Mermaid visual charts
              - Trend indicators
              - Highlight anomalies
              - Suggestions for next actions

          If the result is empty → generate a friendly Markdown empty state:
          - Show reasons why it may be empty
          - Suggest helpful next steps

          Data Visualization Rules:

          When numeric grouping exists (e.g., priority, status): - Generate a
          Mermaid pie or bar chart automatically.

          Example pie:
              pie showData
                "Done" : 10
                "Todo" : 3

          Example line chart (for dates):
              line
                title Todos Over Time
                xAxis 2024-01, 2024-02, 2024-03
                yAxis 1, 5, 9

          If the dataset looks hierarchical:
          - Generate a Mermaid mindmap.

          Required Markdown Structure:

          Always follow this order:

          1. Title

          A short, human-readable title based on user intent.

          2. Query Summary

          One paragraph explaining what data the user requested.

          3. Data Overview

          If records exist:
          - A table summarizing the dataset
          - Highlight important values (high priority, overdue items, etc.)

          4. Visual Insights

          Optional but recommended:
          - Pie charts
          - Bar charts
          - Line charts
          - Mind maps

          Choose based on semantic meaning of the data.

          5. Intelligent Insights

          A bullet list of 2–4 smart observations:
          - Trends
          - Imbalances
          - Outliers
          - Bottlenecks
          - Priorities

          6. Recommendations

          Provide helpful next steps based on the user’s request, such as:
          - You have many high-priority tasks; consider focusing on them first.
          - Most tasks are stuck in “todo”; consider revising workflow.

          7. Possible Follow-Up Commands

          Give 2–3 suggested follow-up user prompts the system can handle.

          Important Constraints
          - Reference only data belonging to the authorized user_id.
          - Ignore or redact any data outside the user’s permission scope.
          - If the input summary or data is unclear, choose the most reasonable interpretation.

          User’s request:

          “$userMsg”
        ''';
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
