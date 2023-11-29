import 'package:flutter/material.dart';
import 'package:litethreads/components/group_card.dart';
import 'package:litethreads/models/group.dart';

class PreferenceDiscoverPage extends StatefulWidget {
  final Future<List<Group>> groupsIFollow;
  final Future<List<Group>> groupsToDiscover;

  const PreferenceDiscoverPage({
    Key? key,
    required this.groupsIFollow,
    required this.groupsToDiscover,
  }) : super(key: key);

  @override
  State<PreferenceDiscoverPage> createState() => _PreferenceDiscoverPageState();
}

class _PreferenceDiscoverPageState extends State<PreferenceDiscoverPage> {
  late Future<List<Group>> _followingGroups;
  late Future<List<Group>> _discoverGroups;

  @override
  void initState() {
    super.initState();
    _followingGroups = widget.groupsIFollow;
    _discoverGroups = widget.groupsToDiscover;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomSheet: const TabBar(
          tabs: [Icon(Icons.favorite), Icon(Icons.explore)],
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
                  return SingleChildScrollView(
                    child: Column(children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text("Groups you follow",
                            style: TextStyle(fontSize: 22),
                            textAlign: TextAlign.center),
                      ),
                      ...List.generate(
                        snapshot.data!.length,
                        (index) => groupCard(
                          index,
                          "",
                          snapshot.data![index].name,
                          "follow",
                        ),
                      ),
                    ]),
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
                } else if (snapshot.hasData) {
                  return SingleChildScrollView(
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
                        (index) => groupCard(
                          index,
                          "",
                          snapshot.data![index].name,
                          "unfollow",
                        ),
                      ),
                    ]),
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
