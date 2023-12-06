import 'package:flutter/material.dart';
import 'package:litethreads/components/fetch.dart';
import 'package:litethreads/globals/variables.dart';
import 'package:litethreads/models/category.dart';
import 'package:litethreads/views/create_group.dart';
import 'package:litethreads/views/create_post.dart';
import 'package:litethreads/views/following.dart';
import 'package:litethreads/views/group_discover.dart';
import 'package:litethreads/views/home.dart';
import 'package:litethreads/views/preferences_discover.dart';

class PageNavigation extends StatefulWidget {
  final String? email;
  final String? username;

  const PageNavigation({super.key, this.email, this.username});

  @override
  State<PageNavigation> createState() => _PageNavigationState();
}

class _PageNavigationState extends State<PageNavigation> {
  int _selectedIndex = 0;

  late Future<List<AppCategory>> categories;
  late Future<List<AppCategory>> userFollowedCategories;

  int followingCount = 0;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  late Widget drawerContent;

  @override
  void initState() {
    super.initState();

    categories = getCategories("get_categories");
    userFollowedCategories = getCategories("get_users_followed_categories");
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      const HomePage(),
      const GroupDiscoverPage(),
      const CreatePostView(),
      const PreferenceDiscoverPage(),
      const FollowingView(),
    ];

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      floatingActionButton: _selectedIndex == 3
          ? FloatingActionButton(
              backgroundColor: Colors.lightBlue,
              child: const Icon(
                Icons.create_new_folder_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateGroupView()));
              },
            )
          : null,
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: FutureBuilder(
            future: Future.wait([categories, userFollowedCategories]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<AppCategory> categoryList = snapshot.data![0];
                List<AppCategory> userFollowed = snapshot.data![1];
                categoryList.sort((a, b) => a.name.compareTo(b.name));
                userFollowed.sort((a, b) => a.name.compareTo(b.name));

                drawerContent = ListView(
                  children: [
                    const SizedBox(height: 10), // Add some spacing

                    const Row(
                      children: [
                        Icon(
                          Icons.check,
                          size: 30,
                        ),
                        Text(" Preferences", style: TextStyle(fontSize: 24)),
                      ],
                    ),
                    const SizedBox(height: 10), // Add some spacing

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: categoryList.length,
                      itemBuilder: (context, index) {
                        bool isFollowed = false;

                        for (int i = 0; i < userFollowed.length; i++) {
                          if (categoryList[index].name ==
                              userFollowed[i].name) {
                            isFollowed = true;
                            break;
                          } else {
                            isFollowed = false;
                          }
                        }
                        return ListTile(
                          title: Text(categoryList[index].name),
                          leading: Checkbox(
                            value: isFollowed,
                            onChanged: (value) {
                              postInteraction(
                                      "user_follow_unfollow_category?category_name=${categoryList[index].name}")
                                  .then((value) {
                                if (value.status == "ok") {
                                  setState(() {
                                    userFollowedCategories = getCategories(
                                        "get_users_followed_categories");
                                  });
                                }
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                drawerContent = const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                drawerContent = const Center(
                  child: Text("Something went wrong trying to fetch settings"),
                );
              }
              return drawerContent;
            },
          ),
        ),
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        shadowColor: Colors.grey,
        backgroundColor: Colors.blue,
        toolbarTextStyle: const TextStyle(color: Colors.white),
        title: const Text(
          "Lite Threads",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(global_username),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Icon(Icons.person),
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.blueAccent,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: "Discover",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: "New",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Groups",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Following",
          ),
        ],
      ),
    );
  }
}
