import 'package:flutter/material.dart';
import 'package:pmc_app/models/cart_model.dart';
import 'package:pmc_app/models/cart_provider.dart';
import 'package:pmc_app/models/db_helper.dart';
import 'package:pmc_app/provider/cart_length_provider.dart';
import 'package:pmc_app/screens/screen_home.dart';
import 'package:pmc_app/screens/screens.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Successfull extends StatefulWidget {
  const Successfull({Key? key}) : super(key: key);

  @override
  _SuccessfullState createState() => _SuccessfullState();
}

class _SuccessfullState extends State<Successfull> {
  @override
  void initState() {
    Provider.of<CartLengthProvider>(context, listen: false).cartLength=0;
    getReference(list: cartList!.list);
    super.initState();
  }
    List<Cart> list = [];
  CartProvider? cartList = CartProvider();
 DBHelper dbHelper = DBHelper();
  String? reference = "";
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(8),
          child: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check,
                    size: 100,
                    color: Colors.green,
                  ),
                  Text(
                    'Order Placed Succesfully',
                    style: TextStyle(fontSize: 23),
                  ),
                  Text(reference!),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Screens()));
                      },
                      child: Text('OK'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future getReference({required List<Cart> list}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    reference = prefs.getString('reference')!;
    prefs.remove('sale_id');
      
  }
}
