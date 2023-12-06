import 'package:flutter/material.dart';
import 'package:litethreads/components/custom_spacer.dart';
import 'package:litethreads/components/fetch.dart';
import 'package:litethreads/globals/stylesheet.dart';
import 'package:litethreads/models/category.dart';

class CreateGroupView extends StatefulWidget {
  const CreateGroupView({super.key});

  @override
  State<CreateGroupView> createState() => _CreateGroupViewState();
}

class _CreateGroupViewState extends State<CreateGroupView> {
  TextEditingController titleController = TextEditingController();
  List<DropdownMenuItem> listItems = [];
  bool isPrivate = false;
  bool isAgeRestricted = false;
  bool error = false;
  String dropdownValue = "";

  late Future<List<AppCategory>> categories;

  @override
  void initState() {
    super.initState();
    categories = getCategories("get_categories").then((value) {
      for (var i = 0; i < value.length; i++) {
        listItems.add(DropdownMenuItem(
            value: value[i].name,
            child: Text(value[i].name, overflow: TextOverflow.visible)));
      }
      dropdownValue = listItems.first.value;
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create New Group",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: appBarBackgroundColor,
        iconTheme: IconThemeData(color: appBarTextColors),
      ),
      backgroundColor: backgroundcolor,
      body: SingleChildScrollView(
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
              FutureBuilder(
                future: categories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    error = false;
                    return Container(
                      decoration: BoxDecoration(color: Colors.grey[300]),
                      child: DropdownButton(
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
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    error = true;
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    error = true;
                    return const Center(
                      child: Text(
                          "Something went wrong trying to collect categories"),
                    );
                  }
                },
              ),
              customSpacer(context, 0.07),
              Row(
                children: [
                  Checkbox(
                      value: isPrivate,
                      onChanged: (val) {
                        setState(() {
                          isPrivate = val!;
                        });
                      }),
                  const Text("Private"),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                      value: isAgeRestricted,
                      onChanged: (val) {
                        setState(() {
                          isAgeRestricted = val!;
                        });
                      }),
                  const Text("Age Restricted"),
                ],
              ),
              error == false
                  ? Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Center(
                          child: ElevatedButton(
                              onPressed: () {
                                FutureBuilder(
                                  future: createStuff(
                                      "create_new_group?name=${titleController.text}&category_name=$dropdownValue&is_private=$isPrivate&is_age_restricted=$isAgeRestricted"),
                                  builder: (context, snapshot) {
                                    if (snapshot.data!.contains("ok")) {
                                      titleController.text = "";
                                      dropdownValue = listItems.first.value;
                                      isPrivate = false;
                                      isAgeRestricted = false;
                                      Navigator.pop(context);
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text("Error"),
                                          content: const Text(
                                              "Failed to create group.\nPlease try again"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Dismiss")),
                                          ],
                                        ),
                                      );
                                    }
                                    return Container();
                                  },
                                );
                              },
                              child: const Text("Create"))),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
