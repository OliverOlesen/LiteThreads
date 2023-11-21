import 'package:flutter/material.dart';
import 'package:litethreads/components/group_card.dart';

class PreferenceDiscoverPage extends StatefulWidget {
  const PreferenceDiscoverPage({super.key});

  @override
  State<PreferenceDiscoverPage> createState() => _PreferenceDiscoverPageState();
}

class _PreferenceDiscoverPageState extends State<PreferenceDiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomSheet: const TabBar(
          tabs: [Icon(Icons.abc), Icon(Icons.abc_outlined)],
        ),
        body: TabBarView(children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < 5; i++) groupCard(i, "follow"),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < 10; i++) groupCard(i, "unfollow"),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
