import 'package:shared/shared.dart';

abstract class ChatWithDataRepo {
  // Future<ChatResponseModel> chatWithData(String userMsg);
  Future<dynamic> chatWithData(String userMsg);
}
