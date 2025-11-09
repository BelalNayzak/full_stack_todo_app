import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:frontend_flutter/frontend.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 900;

    // chatWithData('How many todos are there that i have finished ?');
    chatWithData('what is the last todo that I created ?', 3);

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error!)));
        }
        if (state.user != null ||
            (state.token != null && state.token!.isNotEmpty)) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        if (isWide) {
          return Scaffold(
            body: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(48),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        opacity: 0.3,
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/todo_bkg.png'),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primaryContainer,
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Login',
                            style: Theme.of(context).textTheme.displayMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Your tasks, organized beautifully',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Manage todos across devices with a modern, responsive UI',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Version 1.0.0',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Made with ❤️ by Belal Ashraf',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 480,
                        maxHeight: 400,
                      ),
                      child: ElevatedHoverCard(child: _buildForm(state)),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          body: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  Text(
                    'Login',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Spacer(),
                  ElevatedHoverCard(child: _buildForm(state)),
                  const SizedBox(height: 24),
                  Spacer(),
                  Text(
                    'Version 1.0.0',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Made with ❤️ by Belal Ashraf',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildForm(AuthState state) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Welcome back',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Sign in to continue',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Enter email';
              final ok = RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(v);
              return ok ? null : 'Enter valid email';
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Enter password' : null,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: state.isLoading ? null : _onLogin,
            child: state.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Login'),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const SignupScreen()),
              ),
              child: const Text("Don't have an account? Sign up"),
            ),
          ),
        ],
      ),
    );
  }

  void _onLogin() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().login(
      userModel: UserModel(
        id: null,
        name: null,
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }
}

// Future<ChatResponseModel> chatWithData(String userMsg) async {
Future<dynamic> chatWithData(String userMsg, int userId) async {
  // 1️⃣ Build prompt for LLM
  final prompt =
      '''
          You are a SQL generator for Postgres.
          Return ONLY valid JSON (no markdown, no code fences, no explanations).
          When generating SQL, always:
          - Use single quotes ('...') for string values.
          - Do NOT use double quotes for strings.
          - Do NOT wrap keywords like SELECT, FROM, WHERE in quotes.
          - Wrap table names and column names like todo, user in double quotes.
          - Use User's ID to get ONLY user's related data (knowing that: user_id = $userId).
          - Do NOT ge any data that is not attached to that user (user in not authorized to get any data not attached to him somehow).

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

  // 2️⃣ Call LLM (Gemeni)
  final llmResponse = await dio.Dio().post(
    // 'https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=${EnvConfigs.gemeniKey}',
    'https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=AIzaSyAWhc9SlOvXlWtl3HOViBPFWcMzs08NiAo',
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
  final sqlGeneratedQueryParams = llmParsedData['params'];

  print('xxxxxxxxx 1 : $sqlGeneratedQuery');
  print('xxxxxxxxx 2 : $sqlGeneratedQueryParams');

  // 3️⃣ Safety checks
  if (!sqlGeneratedQuery.toLowerCase().startsWith('select')) {
    print('xxxxxxxxx 3 : exception');
    throw Exception({'Unsafe SQL Query.'});
  }

  // // 4️⃣ Excecute query to supabase (Postgres)
  // final result = await connPool.execute(
  //   Sql.named(sqlGeneratedQuery),
  //   parameters: sqlGeneratedQueryParams,
  // );

  // final data = result
  //     .map((record) => ChatResponseModel.fromJson(record.toColumnMap()))
  //     .toList();

  // final data = result.map((record) => record.toColumnMap()).toList();

  // return data;
}
