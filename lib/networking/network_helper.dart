import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiKey = "f2007f6cd6b0479eacff63b69ec08ebd";

class NetworkHelper {
  NetworkHelper({this.url, this.headers});
  final String url;
  final Map<String, String> headers;

  Future getData() async {
    var response;

    if (headers != null)
      response = await http.get(url, headers: headers);
    else
      response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw 'Response code = ' + response.statusCode.toString();
    }
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
  }
}

//var url = 'http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiID';
