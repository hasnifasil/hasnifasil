

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pmc_app/API/constats/constant_api.dart';
import 'package:pmc_app/API/constats/styles.dart';
import 'package:pmc_app/models/cart_model.dart';
import 'package:pmc_app/models/cart_provider.dart';
import 'package:pmc_app/models/db_helper.dart';
import 'package:pmc_app/screens/order_cancel.dart';
import 'package:pmc_app/screens/order_succesfull.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {

  String? txn_ref;
  int? acquirer_id;
  String? reference;
  String? addressId;
  bool isLoaded = false;
    List<Cart> list = [];
  CartProvider? cartList = CartProvider();
 DBHelper dbHelper = DBHelper();
  @override
   void initState() {
     payment();
     super.initState();
   }
  
  payment() async {
    Dio dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    addressId=prefs.getString('add_id');
    final token = prefs.getString('token');
    reference = prefs.getString('reference');
    Map<String, dynamic> data = {
      'token': token,
      'reference': reference,
      'type': 'card',
      'partner_id':addressId
    };

    print(data);
    final response =
        await dio.post(base_url + 'api/create/transaction', data: data);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = Map<String, dynamic>.from(response.data);
      print(response.data);
      prefs.setString('transaction_ref', (map['result']['txn_ref']));
      prefs.setInt('acquirer_id', (map['result']['acquirer_id']));
      txn_ref=prefs.getString('transaction_ref');
      acquirer_id=prefs.getInt('acquirer_id');
      setState(() {
         isLoaded = true;
      });
    
    }
     

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: !isLoaded
            ? Center(child: CircularProgressIndicator())
            : WebView(
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl:
                  base_url+'payment/cybros/webview?acquirer_id=$acquirer_id&reference=$reference&tx_reference=$txn_ref',
                onPageStarted: (String url) {
                  print(url);
                  if (url.contains('done')) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Successfull()));
                  } else if (url.contains('pending')) {
                     Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrderCancelled()));
                  }
                }),
      ),
    );
  }
}
