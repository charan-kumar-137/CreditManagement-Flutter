import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'custom_widget.dart';
import 'database.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final DBManager dbManager = new DBManager();

  List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomScaffold(
        body: Container(
          child: Column(
            children: [
              HeadingTextStyle("Transactions"),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    children: [
                      Table(
                        border:
                            TableBorder.all(width: 1.0, color: Colors.black),
                        children: [
                          TableRow(children: [
                            TableCell(
                              child: Center(
                                  child: Text(
                                "Sender",
                                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                              )),
                            ),
                            TableCell(
                              child: Center(
                                  child: Text(
                                "Receiver",
                                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                              )),
                            ),
                            TableCell(
                              child: Center(
                                  child: Text(
                                "Credits",
                                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                              )),
                            ),
                          ])
                        ],
                      ),
                      FutureBuilder(
                        future: dbManager.getTransactionList(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            transactions = snapshot.data;
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: transactions == null
                                  ? 0
                                  : transactions.length,
                              itemBuilder: (BuildContext context, int index) {
                                Transaction transaction = transactions[index];
                                return Table(
                                  border: TableBorder.all(
                                      width: 0.5, color: Colors.black),
                                  children: [
                                    TableRow(children: [
                                      TableCell(
                                        child: Center(
                                          child: Text("${transaction.sender}",style: TextStyle(fontSize: 15),),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child:
                                              Text("${transaction.receiver}",style: TextStyle(fontSize: 15),),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: Text("${transaction.credits}",style: TextStyle(fontSize: 15),),
                                        ),
                                      ),
                                    ])
                                  ],
                                );
                              },
                            );
                          }
                          return CircularProgressIndicator();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
