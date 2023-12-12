import 'package:http/http.dart' as http;
import 'package:litethreads/globals/variables.dart';
import 'package:litethreads/models/category.dart';
import 'package:litethreads/models/group.dart';
import 'package:litethreads/models/post.dart';
import 'package:litethreads/models/status.dart';
import 'dart:convert';

import 'package:litethreads/models/user.dart';

Future fetch(String request) async {
  final response = await http.get(Uri.parse("$API_URL/$request"));

  try {
    HttpStatusSuccess ok = HttpStatusSuccess.fromJson(jsonDecode(response.body));
    return ok;
  } catch (e) {
    HttpStatusFail fail = HttpStatusFail.fromJson(jsonDecode(response.body));
    return fail;
  }
}

Future<List<Group>> getGroups(String request) async {
  final response = await http.get(Uri.parse("$API_URL/$request"), headers: {"Authorization": global_token});

  if (response.body.contains("No groups") || response.body.contains("User does not follow any groups")) {
    return List.empty();
  }

  try {
    List<Group> groupsFull = List.empty(growable: true);
    List<Group> groups1 = List.empty(growable: true);
    List<Group> groups2 = List.empty(growable: true);
    if (request.contains("get_users_followed_and_moderated_groups")) {
      if (!jsonDecode(response.body)['response']['followed_groups'].contains("User does not follow any groups")) {
        groups1.addAll(List<Map<String, dynamic>>.from(
          jsonDecode(response.body)['response']['followed_groups'],
        ).map((json) => Group.fromJson(json)).toList());
      }

      if (!jsonDecode(response.body)['response']['moderated_groups'].contains("User does not moderate any groups")) {
        groups2.addAll(List<Map<String, dynamic>>.from(
          jsonDecode(response.body)['response']['moderated_groups'],
        ).map((json) {
          json['moderator'] = true;
          return Group.fromJson(json);
        }).toList());

        List<int> toRemove = List.empty(growable: true);
        if (groups1.isNotEmpty && groups2.isNotEmpty) {
          for (var i = 0; i < groups1.length; i++) {
            for (var ii = 0; ii < groups2.length; ii++) {
              if (groups1[i].name == groups2[ii].name) {
                toRemove.add(i);
              }
            }
          }
        }

        toRemove.sort();
        for (var i = toRemove.length - 1; i >= 0; i--) {
          groups1.removeAt(toRemove[i]);
        }

        if (groups1.isNotEmpty) {
          groupsFull.addAll(groups1);
        }
        if (groups2.isNotEmpty) {
          groupsFull.addAll(groups2);
        }
      }
    } else if (request.contains("get_users_followed_category_groups")) {
      groupsFull.addAll(List<Map<String, dynamic>>.from(
        jsonDecode(response.body)['response']['groups_in_categories'],
      ).map((json) => Group.fromJson(json)).toList());
    } else {
      groupsFull = List.empty();
    }

    return groupsFull;
  } catch (e) {
    return List.empty();
  }
}

Future<List<Post>> getPosts(String request) async {
  final response = await http.get(
    Uri.parse("$API_URL/$request"),
    headers: {"Authorization": global_token},
  );

  try {
    List<Map<String, dynamic>> postsJsonUserList = List.empty(growable: true);
    List<Map<String, dynamic>> postsJsonGroupsList = List.empty(growable: true);
    List<Post> posts = List.empty(growable: true);

    if (request.contains("get_user_followed_users_and_groups_posts")) {
      if (!jsonDecode(response.body)['response']['Users'].contains("No posts")) {
        postsJsonUserList = List<Map<String, dynamic>>.from(
          jsonDecode(response.body)['response']['Users'],
        );
        posts.addAll(postsJsonUserList.map((json) => Post.fromJson(json)).toList());
      }

      if (!jsonDecode(response.body)['response']['Groups'].contains("No posts")) {
        postsJsonGroupsList = List<Map<String, dynamic>>.from(
          jsonDecode(response.body)['response']['Groups'],
        );
        posts.addAll(postsJsonGroupsList.map((json) => Post.fromJson(json)).toList());
      }
    }

    if (request.contains("get_user_category_posts")) {
      if (!jsonDecode(response.body)['response'].contains("No posts from followed categories")) {
        postsJsonGroupsList = List<Map<String, dynamic>>.from(jsonDecode(response.body)['response']);
        posts.addAll(postsJsonGroupsList.map((e) => Post.fromJson(e)).toList());
      }
    }

    posts.sort((a, b) => b.creationDate.compareTo(a.creationDate)); // Newest first

    return posts;
  } catch (e) {
    throw Exception(e);
  }
}

Future postInteraction(String request) async {
  final response = await http.get(
    Uri.parse("$API_URL/$request"),
    headers: {"Authorization": global_token},
  );

  try {
    HttpStatusSuccess ok = HttpStatusSuccess.fromJson(jsonDecode(response.body));
    return ok;
  } catch (e) {
    HttpStatusFail fail = HttpStatusFail.fromJson(jsonDecode(response.body));
    return fail;
  }
}

Future<List<Post>> getSpecificPosts(String request) async {
  final response = await http.get(
    Uri.parse("$API_URL/$request"),
    headers: {"Authorization": global_token},
  );

  try {
    List<Map<String, dynamic>> postsJsonGroupsList = List.empty(growable: true);
    List<Post> posts = List.empty(growable: true);

    if (!jsonDecode(response.body)['response'].contains("No posts")) {
      postsJsonGroupsList = List<Map<String, dynamic>>.from(
        jsonDecode(response.body)['response'],
      );
      posts.addAll(postsJsonGroupsList.map((json) => Post.fromJson(json)).toList());

      posts.sort((a, b) => b.creationDate.compareTo(a.creationDate));
    }
    return posts;
  } catch (e) {
    return List.empty();
  }
}

Future<List<User>> getFollowedUsers(String request) async {
  final response = await http.get(
    Uri.parse("$API_URL/$request"),
    headers: {"Authorization": global_token},
  );
  List<Map<String, dynamic>> userJsonList = List.empty(growable: true);
  List<User> users = List.empty(growable: true);

  try {
    userJsonList = List<Map<String, dynamic>>.from(jsonDecode(response.body)['response']);
    users.addAll(userJsonList.map((json) => User.fromJson(json)).toList());
    return users;
  } catch (e) {
    return List.empty();
  }
}

Future<List<AppCategory>> getCategories(String request) async {
  final response = await http.get(
    Uri.parse("$API_URL/$request"),
    headers: {"Authorization": global_token},
  );

  try {
    List<AppCategory> categories = List.empty(growable: true);
    List<Map<String, dynamic>> temp = List<Map<String, dynamic>>.from(jsonDecode(response.body)['response']);

    categories.addAll(temp.map((json) => AppCategory.fromJson(json)).toList());
    return categories;
  } catch (e) {
    return List.empty();
  }
}

Future<String> createStuff(String request) async {
  final response = await http.get(
    Uri.parse("$API_URL/$request"),
    headers: {"Authorization": global_token},
  );

  try {
    String temp = jsonDecode(response.body)['status'];

    return temp;
  } catch (e) {
    return "Fail";
  }
}
