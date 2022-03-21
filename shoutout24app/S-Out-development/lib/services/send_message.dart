import 'package:shoutout24/model/contactModel.dart';
import 'package:shoutout24/networking/http_client.dart';

class SendMessageService {
  static Future<void> sendMessage(
      {String message, List<ContactModel> contacts}) async {
    var body = {
      "body": message,
      "to": contacts.map((e) => e.mobileNo).toList()
    };
    print(body);

    return await HttpClient.instance.postData("messages", body);
  }
}
