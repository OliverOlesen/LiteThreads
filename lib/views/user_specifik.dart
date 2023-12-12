import 'package:flutter/material.dart';
import 'package:litethreads/components/fetch.dart';
import 'package:litethreads/components/post_card.dart';
import 'package:litethreads/globals/stylesheet.dart';
import 'package:litethreads/globals/variables.dart';
import 'package:litethreads/models/post.dart';
import 'package:litethreads/models/user.dart';
import 'package:litethreads/views/group_specific.dart';

class UserSpecificView extends StatefulWidget {
  final String user;
  const UserSpecificView({super.key, required this.user});

  @override
  State<UserSpecificView> createState() => _UserSpecificViewState();
}

class _UserSpecificViewState extends State<UserSpecificView> {
  late Future<List<Post>> wallContent;
  late Future<List<User>> followedUsers;
  late Widget content;

  late Widget follows;

  @override
  void initState() {
    super.initState();
    wallContent = getSpecificPosts("get_users_wall_post?specific_username=${widget.user}");

    followedUsers = getFollowedUsers("get_followed_users");
  }

  Future<void> _refresh() async {
    // Add any necessary logic to refresh the data
    setState(() {
      wallContent = getSpecificPosts("get_users_wall_post?specific_username=${widget.user}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: Scaffold(
        backgroundColor: backgroundcolor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: appBarTextColors),
          backgroundColor: appBarBackgroundColor,
          title: Text(widget.user, style: TextStyle(color: appBarTextColors)),
          actions: [
            FutureBuilder(
              future: followedUsers,
              builder: (context, snapshot) {
                Widget follows = Container();

                if (snapshot.connectionState == ConnectionState.done) {
                  bool isUserFollowed = false;

                  for (var i = 0; i < snapshot.data!.length; i++) {
                    if (snapshot.data![i].username.contains(widget.user)) {
                      isUserFollowed = true;
                      break;
                    }
                  }

                  follows = TextButton(
                    onPressed: () {
                      String endpoint = isUserFollowed ? "follow_unfollow_user?follow_username=${widget.user}" : "follow_unfollow_user?follow_username=${widget.user}";

                      postInteraction(endpoint);
                      setState(() {
                        followedUsers = getFollowedUsers("get_followed_users");
                      });
                    },
                    child: Text(
                      isUserFollowed ? "Unfollow" : "Follow",
                      style: TextStyle(color: appBarTextColors),
                    ),
                  );
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  follows = Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return follows;
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: wallContent,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data!.isNotEmpty) {
                content = ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    DateTime now = DateTime.now();
                    DateTime when = snapshot.data![index].creationDate;

                    Duration diff = now.difference(when);
                    return Container(
                      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1.0,
                            blurRadius: 1.0,
                            offset: const Offset(0, 5.0), // changes the shadow position
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => GroupSpecificView(
                                                  groupName: snapshot.data![index].group_name,
                                                  following: true,
                                                  mod: false,
                                                )));
                                  },
                                  child: snapshot.data![index].group_name != "" ? Text("/${snapshot.data![index].group_name}") : Container()),
                              if (snapshot.data![index].username == global_username)
                                InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: const Text("Delete Post?"),
                                                content: const Text("You are about to delete this post. \nYou can't undo this action.\nAre you sure?"),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        postInteraction("archive_post?post_id=${snapshot.data![index].id}");
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text("Delete")),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text("Cancel"))
                                                ],
                                              ));
                                    },
                                    child: const Text("X")),
                            ],
                          ),
                          Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserSpecificView(user: snapshot.data![index].username)));
                                  },
                                  child: Text(snapshot.data![index].username)),
                              Text(" - ${formatDuration(diff)}"),
                            ],
                          ),
                          Text(snapshot.data![index].title, style: const TextStyle(fontSize: 24)),
                          Text(
                            snapshot.data![index].content,
                            style: const TextStyle(fontSize: 16),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    postInteraction("vote_on_post?username=$global_username&post_id=${snapshot.data![index].id}&reaction_like=1").then((value) {
                                      setState(() {
                                        wallContent = getSpecificPosts("get_users_wall_post?specific_username=${widget.user}");
                                      });
                                    });
                                  },
                                  icon: Icon(
                                    Icons.thumb_up,
                                    color: snapshot.data![index].userVote == 1 ? Colors.lightBlue : Colors.grey,
                                  )),
                              Text("${snapshot.data![index].likes}"),
                              IconButton(
                                  onPressed: () {
                                    postInteraction("vote_on_post?username=$global_username&post_id=${snapshot.data![index].id}&reaction_like=0").then((value) {
                                      setState(() {
                                        wallContent = getSpecificPosts("get_users_wall_post?specific_username=${widget.user}");
                                      });
                                    });
                                  },
                                  icon: Icon(
                                    Icons.thumb_down,
                                    color: snapshot.data![index].userVote == 0 ? Colors.lightBlue : Colors.grey,
                                  )),
                              Text("${snapshot.data![index].dislikes}")
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              } else {
                content = const Center(child: Text("No Posts Found"));
              }
              return content;
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              content = const Center(child: CircularProgressIndicator());
            } else {
              content = const Center(child: Text("We encountered some issues displaying posts.\nPlease try again later"));
            }
            return content;
          },
        ),
      ),
    );
  }
}
