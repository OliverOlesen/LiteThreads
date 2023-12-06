import 'package:flutter/material.dart';
import 'package:litethreads/components/fetch.dart';
import 'package:litethreads/components/group_card.dart';
import 'package:litethreads/globals/stylesheet.dart';
import 'package:litethreads/models/group.dart';
import 'package:litethreads/views/group_specific.dart';

class PreferenceDiscoverPage extends StatefulWidget {
  const PreferenceDiscoverPage({Key? key}) : super(key: key);

  @override
  State<PreferenceDiscoverPage> createState() => _PreferenceDiscoverPageState();
}

class _PreferenceDiscoverPageState extends State<PreferenceDiscoverPage> {
  late Future<List<Group>> _followingGroups;
  late Future<List<Group>> _discoverGroups;

  @override
  void initState() {
    super.initState();
    _followingGroups = getGroups("get_users_followed_and_moderated_groups");
    _discoverGroups = getGroups("get_users_followed_category_groups");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: backgroundcolor,
        appBar: const TabBar(
          labelColor: Colors.lightBlue,
          indicatorColor: Colors.lightBlue,
          tabs: [
            Icon(Icons.favorite_border_outlined),
            Icon(Icons.explore_outlined)
          ],
        ),
        body: TabBarView(
          children: [
            FutureBuilder(
              future: _followingGroups,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _followingGroups = getGroups(
                            "get_users_followed_and_moderated_groups");
                        _discoverGroups =
                            getGroups("get_users_followed_category_groups");
                      });
                    },
                    child: SingleChildScrollView(
                      child: Column(children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Center(
                            child: Text("Groups you follow",
                                style: TextStyle(fontSize: 22),
                                textAlign: TextAlign.center),
                          ),
                        ),
                        ...List.generate(
                          snapshot.data!.length,
                          (index) => InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return GroupSpecificView(
                                    groupName: snapshot.data![index].name,
                                    following: true,
                                    mod: snapshot.data![index].moderator,
                                  );
                                },
                              ));
                            },
                            child: groupCard(
                                index,
                                snapshot.data![index].categoryName ?? "",
                                snapshot.data![index].name,
                                "follow"),
                          ),
                        ),
                      ]),
                    ),
                  );
                } else {
                  return Container(); // Handle other cases if needed
                }
              },
            ),
            FutureBuilder(
              future: _discoverGroups,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _followingGroups = getGroups(
                            "get_users_followed_and_moderated_groups");
                        _discoverGroups =
                            getGroups("get_users_followed_category_groups");
                      });
                    },
                    child: SingleChildScrollView(
                      child: Column(children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Discover new groups from your preference",
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ...List.generate(
                          snapshot.data!.length,
                          (index) => InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GroupSpecificView(
                                          groupName: snapshot.data![index].name,
                                          following: false,
                                          mod: snapshot.data![index].moderator,
                                        )),
                              );
                            },
                            child: groupCard(
                                index,
                                snapshot.data![index].categoryName ?? "",
                                snapshot.data![index].name,
                                "unfollow"),
                          ),
                        ),
                      ]),
                    ),
                  );
                } else {
                  return Container(); // Handle other cases if needed
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
