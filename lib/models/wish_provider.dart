import 'package:flutter/cupertino.dart';
import 'package:pmc_app/models/cart_model.dart';
import 'package:pmc_app/models/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishProvider with ChangeNotifier {
  DBHelpers db = DBHelpers();
  int _counter = 0;
  int get counter => _counter;
  double _total = 0.0;
  double get total => _total;

  late Future<List<Cart>> _cart;
  Future<List<Cart>> get cart => _cart;
  Future<List<Cart>> getData() async {
    _cart = db.getCartList();
    return _cart;
  }

  void _setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('wish_item', _counter);
    prefs.setDouble('tot', _total);

    // notifyListeners();
  }

  void _getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('wish_item') ?? 0;
    _total = prefs.getDouble('tot') ?? 0.0;
    // print("Wishb List Count:" + _counter.toString());
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
    _total = _total + price;
    _setPrefItems();

    notifyListeners();
  }

  void removeTotal(double price) {
    _total = _total - price;
    _setPrefItems();
    notifyListeners();
  }

  double getTotal() {
    _getPrefItems();
    return _total;
  }
}
