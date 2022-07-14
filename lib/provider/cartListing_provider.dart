import 'package:flutter/cupertino.dart';
import 'package:pmc_app/API/cart_listing_api.dart';
import 'package:pmc_app/models/read_cart_data_model.dart';

class CartListProvider extends ChangeNotifier{
double total=0.0;
 cartListApi _cartListItems = cartListApi();
  late AllCartItems _allCartItems;

  List<Detail> getCartList = [];
  bool isl = true;
  Future getCartListData() async {
   
    isl = true;
     
   
    getCartList.clear();
     

    var cartData = await _cartListItems.getCartListItems();

    if (cartData != null) {
      
   
     _allCartItems=AllCartItems.fromJson(cartData);
      getCartList.addAll(_allCartItems.details!);
      isl = false;
total= _cartListItems.totalAmounts;
      notifyListeners();
    }
  }


}