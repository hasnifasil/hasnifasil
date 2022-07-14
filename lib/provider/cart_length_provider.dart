import 'package:flutter/material.dart';
import 'package:pmc_app/API/cart_lenth_api.dart';

class CartLengthProvider extends ChangeNotifier {
int cartLength=0;
   Future getCartLength() async {
    await CartLength().getCartLength().then((response) {
    cartLength=response['length'];
    print(cartLength);
    notifyListeners();
    
   });
}}

