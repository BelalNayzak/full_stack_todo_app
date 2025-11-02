import 'package:backend_dart_frog/backend.dart';

Handler middleware(Handler handler) {
  return (context) async {
    // Then forward the request to the respective handler.
    // Inject connection into request context
    final response = await handler
        .use(requestLogger())
        .use(provider<Pool>((context) => connectionPool))
        .use(webCORS) //! xxx
        .call(context);

    // Return a response.
    return response;
  };
}
