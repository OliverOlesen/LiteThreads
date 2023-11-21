import 'package:flutter/material.dart';
import 'package:litethreads/views/group_discover.dart';
import 'package:litethreads/views/home.dart';
import 'package:litethreads/views/preferences_discover.dart';

class PageNavigation extends StatefulWidget {
  final String? email;
  final String? username;
  final String? password;
  final String? birthdate;

  const PageNavigation(
      {super.key, this.email, this.username, this.password, this.birthdate});

  @override
  State<PageNavigation> createState() => _PageNavigationState();
}

class _PageNavigationState extends State<PageNavigation> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    const List<Widget> _widgetOptions = <Widget>[
      HomePage(),
      GroupDiscoverPage(),
      GroupDiscoverPage(),
      PreferenceDiscoverPage(),
      GroupDiscoverPage(),
    ];

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.grey,
        backgroundColor: Colors.blue,
        toolbarTextStyle: TextStyle(color: Colors.white),
        actions: [
          Text(widget.username ?? ""),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings),
            color: Colors.white,
          )
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
