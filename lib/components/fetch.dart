import 'package:http/http.dart' as http;
import 'package:litethreads/globals/variables.dart';
import 'package:litethreads/models/status.dart';
import 'dart:convert';

Future fetch(String request, dynamic body) async {
  final response = await http.post(Uri.parse("$API_URL/$request"), body: body);

  Map<String, dynamic> tempResponseBody = {"status": "ok", "response": ""};

  try {
    // HttpStatusSuccess ok =
    //     HttpStatusSuccess.fromJson(jsonDecode(response.body));
    HttpStatusSuccess ok =
        HttpStatusSuccess.fromJson(jsonDecode(jsonEncode(tempResponseBody)));
    return ok;
  } catch (e) {
    HttpStatusFail fail = HttpStatusFail.fromJson(jsonDecode(response.body));
    return fail;
  }
}
