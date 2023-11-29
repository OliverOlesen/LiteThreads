import 'package:http/http.dart' as http;
import 'package:litethreads/globals/variables.dart';
import 'package:litethreads/models/group.dart';
import 'package:litethreads/models/post.dart';
import 'package:litethreads/models/status.dart';
import 'dart:convert';

Future fetch(String request, dynamic body) async {
  final response = await http.get(Uri.parse("$API_URL/$request"));

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

Future<List<Group>> getGroups(String request) async {
  final response = await http.get(Uri.parse("$API_URL/$request"));

  try {
    List<Group> groups;
    if (request.contains("get_users_followed_groups")) {
      groups =
          List.from(jsonDecode(response.body)['response']['followed_groups'])
              .map((json) => Group.fromJson({'name': json}))
              .toList();
    } else if (request.contains("get_users_followed_category_groups")) {
      groups = List.from(
              jsonDecode(response.body)['response']['groups_in_categories'])
          .map((json) => Group.fromJson({'name': json}))
          .toList();
    } else {
      groups = List.empty();
    }
    return groups;
  } catch (e) {
    throw Exception(e);
  }
}

Future<List<Post>> getPosts(String request) async {
  final response = await http.get(Uri.parse("$API_URL/$request"));
  try {
    List<Post> posts = List.from(jsonDecode(response.body))
        .map((json) => Post.fromJson(json))
        .toList();
    return posts;
  } catch (e) {
    throw Exception(e);
  }
}
