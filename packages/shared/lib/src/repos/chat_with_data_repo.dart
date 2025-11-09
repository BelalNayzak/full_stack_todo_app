import 'package:shared/shared.dart';

abstract class ChatWithDataRepo {
  Future<ChatResponseModel> chatWithData(int userId, String userMsg);
}
