import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkHelper {

  final String url;
  NetworkHelper(this.url);

  Future getApiData() async {
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var data = response.body;
      return jsonDecode(data);
    } else {
      // ignore: avoid_print
      print(response.statusCode);
    }
  }
}