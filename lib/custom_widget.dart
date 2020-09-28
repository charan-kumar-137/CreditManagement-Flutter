import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'adduser.dart';
import 'homepage.dart';
import 'transactions.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CreditManagement",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(
                child: Text("Navigate"),
              ),
            ),
            ListTile(
              title: Text("Home"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            ListTile(
              title: Text("Add user"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddUser()));
              },
            ),
            ListTile(
              title: Text("Transactions"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TransactionPage()));
              },
            )
          ],
        ),
      ),
      body: this.body,
    );
  }
}

class HeadingTextStyle extends StatelessWidget {
  final String text;

  const HeadingTextStyle(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            '$text',
            style: TextStyle(fontSize: 35),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
