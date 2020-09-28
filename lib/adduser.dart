import 'package:flutter/material.dart';
import 'custom_widget.dart';
import 'database.dart';

class AddUser extends StatefulWidget {
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final DBManager dbManager = new DBManager();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _creditsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: CustomScaffold(
          body: Container(
            child: Column(
              children: [
                HeadingTextStyle("Add User"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(labelText: "Enter User name"),
                              controller: _nameController,
                              validator: (val) =>
                                  val.isEmpty ? 'Username can\'t be empty' : null,
                            ),
                            TextFormField(
                              decoration:
                                  InputDecoration(labelText: "Enter User Credits"),
                              controller: _creditsController,
                              keyboardType: TextInputType.number,
                              validator: (val) =>
                                  val.isEmpty ? 'User Credits can\'t be empty' : null,
                            ),
                            SizedBox(height: 20,),
                            RaisedButton(
                              child: Text('Submit'),
                              color: Colors.white,
                              elevation: 5,
                              onPressed: () {
                                _submitUser(context);
                              },
                            ),
                            SizedBox(height: 20,),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _submitUser(BuildContext context) {
    if (_formKey.currentState.validate()) {
      String name = _nameController.text;
      int credits = int.parse(_creditsController.text);
      if (credits < 0) {

        Future ul = dbManager.getUserList();
        ul.then((value){
          List<User> uls = value;
          print("debug submit $uls");
        });


        _showDialog("Error", "Invalid credits");
        return;
      }
      User user = new User(name: name, credits: credits);
      dbManager.insertUser(user).then((value) {
        _nameController.clear();
        _creditsController.clear();
        _showDialog("Success", "User has been added");
      });


    }
  }

  Future<void> _showDialog(String status, String text) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(status),
            content: Text(text),
            actions: [
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
