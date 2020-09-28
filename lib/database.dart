import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class User {
  int id;
  String name;
  int credits;

  User({this.id, this.name, this.credits});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'credits': credits};
  }
}

class Transaction {
  int id;
  String sender;
  String receiver;
  int credits;

  Transaction({this.id, this.sender, this.receiver, this.credits});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender': sender,
      'receiver': receiver,
      'credits': credits
    };
  }
}

class DBManager {
  Database database;

  Future openDB() async {
    if (database == null) {
      database = await openDatabase(
          join(await getDatabasesPath(), 'CreditManagement.db'),
          version: 1, onCreate: (Database db, int version) async {
        await db.execute(
            "CREATE TABLE user(id INTEGER PRIMARY KEY, name TEXT,credits INTEGER)");
        await db.execute(
            "CREATE TABLE transactions(id INTEGER PRIMARY KEY, sender TEXT, receiver TEXT, credits INTEGER)");
      });
    }
  }

  Future insertUser(User user) async {
    await openDB();
    await database.insert('user', user.toMap());
  }

  Future<void> insertTransaction(Transaction transaction) async {
    await openDB();
    await database.insert('transactions', transaction.toMap());
  }

  Future<List<User>> getUserList() async {
    await openDB();
    final List<Map<String, dynamic>> maps = await database.query('user');

    return List.generate(maps.length, (i) {
      return User(
          id: maps[i]['id'],
          name: maps[i]['name'],
          credits: maps[i]['credits']);
    });
  }

  Future<List<Transaction>> getTransactionList() async {
    await openDB();
    final List<Map<String, dynamic>> maps = await database.query('transactions');

    return List.generate(maps.length, (index) {
      return Transaction(
          id: maps[index]['id'],
          sender: maps[index]['sender'],
          receiver: maps[index]['receiver'],
          credits: maps[index]['credits']);
    });
  }

  Future updateUser(User user) async {
    await openDB();
    await database
        .update('user', user.toMap(), where: "id = ?", whereArgs: [user.id]);
  }

  Future<User> getUserById(int id) async {
    await openDB();
    final List<Map<String, dynamic>> maps =
        await database.query('user', where: "id = ?", whereArgs: [id]);

    return User(
        id: maps[0]['id'],
        name: maps[0]['name'],
        credits: maps[0]['credits']);
  }
}
