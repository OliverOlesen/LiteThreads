import 'package:flutter/material.dart';
import 'package:litethreads/components/fetch.dart';
import 'package:litethreads/components/user_card.dart';
import 'package:litethreads/globals/stylesheet.dart';
import 'package:litethreads/models/user.dart';
import 'package:litethreads/views/user_specifik.dart';

class FollowingView extends StatefulWidget {
  const FollowingView({super.key});

  @override
  State<FollowingView> createState() => _FollowingViewState();
}

class _FollowingViewState extends State<FollowingView> {
  late Future<List<User>> _followingUsers;

  @override
  void initState() {
    super.initState();
    _followingUsers = getFollowedUsers("get_followed_users");
  }

  Future<void> _refresh() async {
    // Call your refresh function or update the data fetching logic here
    setState(() {
      _followingUsers = getFollowedUsers("get_followed_users");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundcolor,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder(
          future: _followingUsers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.connectionState == ConnectionState.done) {
              return ListView(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Users you follow",
                      style: TextStyle(fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ...List.generate(
                    snapshot.data!.length,
                    (index) => InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return UserSpecificView(
                                user: snapshot.data![index].username);
                          },
                        ));
                      },
                      child: userCard(
                          index, snapshot.data![index].username, "follow"),
                    ),
                  ),
                ],
              );
            } else {
              return Container(); // Handle other cases if needed
            }
          },
        ),
      ),
    );
  }
}
