class ApiResponse {
  final String status;
  final ResponseData response;

  ApiResponse({required this.status, required this.response});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'],
      response: ResponseData.fromJson(json['response']),
    );
  }
}

class ResponseData {
  final List<Group> followedGroups;

  ResponseData({required this.followedGroups});

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      followedGroups: List<Group>.from(
        json['followed_groups'].map((group) => Group.fromJson(group)),
      ),
    );
  }
}

class Group {
  final String name;
  final String? categoryName;
  final String? creationDate;
  final bool moderator;

  Group({
    required this.name,
    required this.categoryName,
    required this.creationDate,
    required this.moderator,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      name: json['group_name'],
      categoryName: json['category_name'] ?? "",
      creationDate: json['creation_date'] ?? "",
      moderator: json['moderator'] ?? false,
    );
  }
}
