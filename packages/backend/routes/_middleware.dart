import 'package:backend_dart_frog/backend.dart';

Handler middleware(Handler handler) {
  return (context) async {
    // Then forward the request to the respective handler.
    // Inject connection into request context
    final response = await handler
        .use(requestLogger())
        // .use(_provideCORS) //!
        .use(provider<Pool>((context) => connectionPool))
        .call(context);

    // Return a response.
    return response;
  };
}

//! For running on web you need to setup CORS to bypass crome and localhost issues
//! It's prefered to test on mobile while dev, but in production you will have no issues with web
// /// ✅ Custom CORS middleware
// Handler _provideCORS(Handler handler) {
//   return (context) async {
//     // Handle preflight (OPTIONS) requests
//     if (context.request.method == HttpMethod.options) {
//       return Response(
//         statusCode: 200,
//         headers: _corsHeaders,
//       );
//     }

//     // Handle normal requests
//     final response = await handler(context);
//     return response.copyWith(headers: {
//       ...response.headers,
//       ..._corsHeaders,
//     });
//   };
// }

// /// ✅ Define CORS headers globally
// const _corsHeaders = {
//   'Access-Control-Allow-Origin': '*',
//   'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
//   'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept, Authorization',
// };
