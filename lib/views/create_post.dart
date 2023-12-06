import 'package:flutter/material.dart';
import 'package:litethreads/components/fetch.dart';
import 'package:litethreads/globals/variables.dart';
import 'package:litethreads/models/group.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({super.key});

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  late Future<List<Group>> groupsIFollow;

  List<String> listvalues = List.empty(growable: true);
  List<DropdownMenuItem> listItems = [];
  String dropdownValue = global_username;

  @override
  void initState() {
    super.initState();

    groupsIFollow = getGroups("get_users_followed_and_moderated_groups");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: "Title",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: TextField(
                controller: contentController,
                decoration: const InputDecoration(hintText: "Content Text"),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text("Pick where to post"),
            ),
            FutureBuilder(
              future: groupsIFollow,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  List<DropdownMenuItem> tempItems = [
                    DropdownMenuItem(
                        value: global_username,
                        child: Text("My Wall - $global_username"))
                  ];
                  for (var i = 0; i < snapshot.data!.length; i++) {
                    tempItems.add(DropdownMenuItem(
                        value: snapshot.data![i].name,
                        child: Text(snapshot.data![i].name,
                            overflow: TextOverflow.visible)));
                  }
                  listItems = tempItems;
                  return Container(
                    decoration: BoxDecoration(color: Colors.grey[300]),
                    child: DropdownButton(
                        // padding: const EdgeInsets.only(top: 5, bottom: 5),
                        value: dropdownValue,
                        padding: const EdgeInsets.all(10),
                        elevation: 16,
                        isDense: true,
                        hint: Text(dropdownValue),
                        items: listItems,
                        isExpanded: true,
                        onChanged: ((value) {
                          setState(() {
                            dropdownValue = value;
                          });
                        })),
                  );
                } else {
                  return Container();
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Center(
                  child: ElevatedButton(
                      onPressed: () {
                        if (dropdownValue == global_username) {
                          postInteraction(
                              "create_user_post?username=$global_username&title=${titleController.text}&content=${contentController.text}");
                          titleController.text = "";
                          contentController.text = "";
                        } else {
                          postInteraction(
                              "create_group_post?username=$global_username&title=${titleController.text}&content=${contentController.text}&group_name=$dropdownValue");
                          titleController.text = "";
                          contentController.text = "";
                        }
                      },
                      child: const Text("Create"))),
            )
          ],
        ),
      ),
    );
  }
}
