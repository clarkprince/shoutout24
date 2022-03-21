import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class HttpClient {
  static final HttpClient _singleton = HttpClient();

  static HttpClient get instance => _singleton;

  Future<dynamic> postData(String url, dynamic body) async {
    var responseJson;
    var header = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader:
          'Basic NTE5NEY4MTAwOTJDNDMzN0JDMTQ3Rjg5NUMxN0RFQ0EtMDEtMTpLZDBfWSNMTzZYQ3FHWUtQSnJHbF85aHlpa0x4Nw=='
    };
    try {
      final response = await http.post("https://api.bulksms.com/v1/" + url,
          body: json.encode(body), headers: header);
      print(response.body);
      print(response.statusCode);
      responseJson = response.statusCode;
    } on SocketException {
      throw ('No Internet connection');
    }
    return responseJson;
  }
}
