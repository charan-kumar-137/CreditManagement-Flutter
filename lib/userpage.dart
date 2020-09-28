import 'package:flutter/material.dart';
import 'custom_widget.dart';
import 'database.dart';

class UserPage extends StatefulWidget {
  final int id;

  UserPage(this.id);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final DBManager dbManager = new DBManager();
  final _formKey = GlobalKey<FormState>();
  final _creditsController = TextEditingController();
  User sender;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomScaffold(
        body: Container(
          child: Column(
            children: [
              HeadingTextStyle('User'),
              FutureBuilder(
                future: dbManager.getUserById(widget.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    sender = snapshot.data;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                "${sender.name}",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${sender.credits} Credits",
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        )),
                      ],
                    );
                  }
                  return CircularProgressIndicator();
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Container(
                    width: 250,
                    child: TextFormField(
                      decoration: new InputDecoration(
                          labelText: "Enter credits to send"),
                      controller: _creditsController,
                      keyboardType: TextInputType.number,
                      validator: (val) =>
                          val.isEmpty ? 'Can\'t be empty' : null,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(" Select a Receiver to send the credits "),
                ],
              ),
              FutureBuilder(
                future: dbManager.getUserList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<User> receivers = snapshot.data;
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: receivers.length,
                        itemBuilder: (BuildContext context, int index) {
                          User receiver = receivers[index];
                          return Card(
                            child: ListTile(
                              title: Text('${receiver.name}'),
                              onTap: () {
                                _sendCredits(context, receiver.id);
                              },
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return CircularProgressIndicator();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _sendCredits(BuildContext context, int receiverId) {
    if (_formKey.currentState.validate()) {
      int credits = int.parse(_creditsController.text);
      if (credits < 0 || credits > sender.credits) {
        _showDialog("Error", "Invalid Credits");
        return;
      }

      User s = User(
          id: sender.id, name: sender.name, credits: sender.credits - credits);
      dbManager.getUserById(receiverId).then((value) {
        _creditsController.clear();
        User r = User(
            id: value.id, name: value.name, credits: value.credits + credits);
        if (sender.id == receiverId) {
          _showDialog("Error", "You can\'t send credits to yourself");
          return;
        }
        Transaction transaction = Transaction(
            sender: sender.name, receiver: r.name, credits: credits);
        dbManager.updateUser(s).then((value) {
          dbManager.updateUser(r).then((value) {
            dbManager.insertTransaction(transaction).then((value) {
              _showDialog("Success", "Transaction Successful");
            });
          });
        });
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
