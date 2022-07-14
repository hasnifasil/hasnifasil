import 'package:path_provider/path_provider.dart';
import 'package:pmc_app/models/cart_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'cart.db');
    var db = await openDatabase(path, version: 2, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE cart (did INTEGER PRIMARY KEY,pid INTEGER UNEQUE,name TEXT,image BLOB,initialprice REAL,price REAL,quantity INTEGER,type TEXT,color TEXT,power TEXT,size TEXT,attType TEXT,model TEXT,flavour TEXT,flvr TEXT,l85 TEXT,mg TEXT,colorname TEXT,powername TEXT,sizename TEXT,volumename TEXT,modelname TEXT)');
  }

  Future<Cart> insert(Cart cart) async {
    var dbClient = await db;
    await dbClient!.insert('cart', cart.toMap());
    return cart;
  }

  Future<List<Cart>> getCartList() async {
    List<Map<String, Object?>> queryResult = [];
    var dbClient = await db;
    if (dbClient != null) {
      queryResult = await dbClient.query('cart');
    }

    return queryResult.map((e) => Cart.fromMap(e)).toList();
  }

  Future<int> delete(int did) async {
    var dbClient = await db;
    return await dbClient!.delete('cart', where: 'did=?', whereArgs: [did]);
  }

  Future<int> updateQuantity(Cart cart) async {
    var dbClient = await db;
    return await dbClient!
        .update('cart', cart.toMap(), where: 'did = ?', whereArgs: [cart.did]);
  }

  Future deteteTbleCContent() async {
    var dbClient = await db;
    return await dbClient!.delete('cart');
  }
}

class DBHelpers {
  static Database? _db;
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'wish.db');
    var db = await openDatabase(path, version: 2, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE wish (did INTEGER PRIMARY KEY,pid INTEGER UNEQUE,name TEXT,image BLOB,initialprice REAL,price REAL,quantity INTEGER,type TEXT,color TEXT,power TEXT,size TEXT,attType TEXT,model TEXT,flavour TEXT,flvr TEXT,l85 TEXT,mg TEXT,colorname TEXT,powername TEXT,sizename TEXT,volumename TEXT,modelname TEXT)');
  }

  Future<Cart> insert(Cart cart) async {
    var dbClient = await db;
    await dbClient!.insert('wish', cart.toMap());
    return cart;
  }

  Future<List<Cart>> getCartList() async {
    List<Map<String, Object?>> queryResult = [];
    var dbClient = await db;
    if (dbClient != null) {
      queryResult = await dbClient.query('wish');
    }

    return queryResult.map((e) => Cart.fromMap(e)).toList();
  }

  Future<int> delete(int did) async {
    var dbClient = await db;
    return await dbClient!.delete('wish', where: 'did=?', whereArgs: [did]);
  }

  Future<int> updateQuantity(Cart cart) async {
    var dbClient = await db;
    return await dbClient!
        .update('wish', cart.toMap(), where: 'did = ?', whereArgs: [cart.did]);
  }

  Future deteteTbleCContent() async {
    var dbClient = await db;
    return await dbClient!.delete('wish');
  }
}
