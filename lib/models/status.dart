import 'package:litethreads/globals/variables.dart';

class HttpStatusSuccess {
  final String status;

  HttpStatusSuccess({required this.status});

  factory HttpStatusSuccess.fromJson(Map<String, dynamic> json) {
    if (json['status'] == 'ok') {
      if (json['response']['jwt'] != null && json['response']['jwt'] != "") {
        global_token = json['response']['jwt'];
      }

      if (global_username == "") {
        global_username = json['response']['user_info']['username'];
      }

      if (global_email == "") {
        global_email = json['response']['user_info']['email'];
      }
      return HttpStatusSuccess(
        status: json['status'],
      );
    } else {
      throw const FormatException('Failed to load album.');
    }
  }
}

class HttpStatusFail {
  final String status;
  final String missingFields;

  HttpStatusFail({required this.status, required this.missingFields});

  factory HttpStatusFail.fromJson(Map<String, dynamic> json) {
    return HttpStatusFail(
        status: json['status'],
        missingFields: json['response'] ?? "something went wrong"
        // missingFields: List<String>.from(json['response']),
        );
  }
}
