import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<int> likes = [];
  List<int> dislikes = [];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        likes.add(0);
        dislikes.add(0);
        return customCard(index); // Use the customCard function here
      },
    );
  }

  void likePressed(List<int> list, int i) {
    setState(() {
      list[i]++;
    });
  }

  Container customCard(int i) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1.0,
            blurRadius: 1.0,
            offset: Offset(0, 5.0), // changes the shadow position
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Text("Group Name Author CreateDate"),
          Text("Group Name"),
          Row(
            children: [
              Text("Author"),
              Text("CreateDate"),
              // Text("${}"),
            ],
          ),
          const Text("Subject", style: TextStyle(fontSize: 24)),
          const Text(
            "Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitiamolestiae quas vel sint commodi repudiandae consequuntur voluptatum laborumnumquam blanditiis harum quisquam eius sed odit fugiat iusto fuga praesentiumoptio, eaque rerum! Provident similique accusantium nemo autem. Veritatisobcaecati tenetur iure eius earum ut molestias architecto voluptate aliquamnihil, eveniet aliquid culpa officia aut! ",
            style: TextStyle(fontSize: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    likePressed(likes, i);
                  },
                  icon: const Icon(Icons.thumb_up)),
              Text("${likes[i]}"),
              IconButton(
                  onPressed: () {
                    likePressed(dislikes, i);
                  },
                  icon: const Icon(Icons.thumb_down)),
              Text("${dislikes[i]}")
            ],
          )
        ],
      ),
    );
  }
}
