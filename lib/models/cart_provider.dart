import 'package:flutter/cupertino.dart';
import 'package:pmc_app/models/cart_model.dart';
import 'package:pmc_app/models/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  DBHelper db = DBHelper();
  int _counter = 0;
  int get counter => _counter;
  double total = 0.0;
  // double get total => _total;

  late Future<List<Cart>> _cart;
  Future<List<Cart>> get cart => _cart;
  List<Cart> list = [];
  Future<List<Cart>> getData() async {
    _cart = db.getCartList();
    list = await _cart;
    getTotalPrice();
    notifyListeners();
    return _cart;
  }

  void _setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_item', _counter);
    prefs.setDouble('total', total);

    notifyListeners();
  }

  void _getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_item') ?? 0;
    // total = prefs.getDouble('total') ?? 0.0;

    notifyListeners();
  }

  void addCounter() {
    _counter++;
    _setPrefItems();
    notifyListeners();
  }

  void removeCounter() {
    _counter--;
    _setPrefItems();

    notifyListeners();
  }

  int getCounter() {
    _getPrefItems();
    return _counter;
  }

  void addTotalPrice(double price) {
    // _total = _total + price;
    _setPrefItems();

    notifyListeners();
  }

  void removeTotal(double price) {
    // _total = _total - price;
    _setPrefItems();
    notifyListeners();
  }

  double getTotal() {
    // _getPrefItems();
    // print("Total :" + _total.toString());
    // print("<><><><><><>");
    // print(total);
    return total;
  }

  double getTotalPrice() {
    double p = 0;
    for (int i = 0; i < list.length; i++) {
      p = p + list[i].price;
      // notifyListeners();

      // print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      // print(p);
      // print(total);
    }
    return p;
  }
}
