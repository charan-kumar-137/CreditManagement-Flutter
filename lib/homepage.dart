import 'package:flutter/material.dart';
import 'custom_widget.dart';
import 'database.dart';
import 'userpage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DBManager dbManager = new DBManager();
  List<User> users;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomScaffold(
        body: Container(
          child: Column(
            children: [
              HeadingTextStyle("Home"),
              FutureBuilder(
                future: dbManager.getUserList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    users = snapshot.data;
                    return Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: users == null ? 0 : users.length,
                          itemBuilder: (BuildContext context, int index) {
                            User user = users[index];
                            return Card(
                              elevation: 2,
                              shape: Border(right: BorderSide(color: Colors.black,width: 5)),
                              child: ListTile(
                                title: Row(
                                  children: [
                                    Text(" ${user.name} "),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Icon(Icons.arrow_forward_ios),
                                    Text(" ${user.credits} "),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UserPage(user.id)));
                                },
                              ),
                            );
                          }),
                    );
                  }
                  return CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
