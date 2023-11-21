class HttpStatusSuccess {
  final String status;
  final String response;

  HttpStatusSuccess({required this.status, required this.response});

  factory HttpStatusSuccess.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'status': String status, 'response': String message} =>
        HttpStatusSuccess(status: status, response: message),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}

class HttpStatusFail {
  final String status;
  final List<String> missingFields;

  HttpStatusFail({required this.status, required this.missingFields});

  factory HttpStatusFail.fromJson(Map<String, dynamic> json) {
    return HttpStatusFail(
      status: json['status'],
      missingFields: List<String>.from(json['response']['missing_fields']),
    );
  }
}
