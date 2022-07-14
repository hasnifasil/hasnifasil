import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pmc_app/API/constats/styles.dart';
import 'package:pmc_app/models/cart_model.dart';
import 'package:pmc_app/models/db_helper.dart';
import 'package:pmc_app/screens/screen_cart.dart';
import 'package:pmc_app/screens/screen_splas.dart';
import 'package:pmc_app/screens/wishlist.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_provider.dart';

class PersonScreen extends StatefulWidget {
  const PersonScreen({Key? key}) : super(key: key);

  @override
  State<PersonScreen> createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {

@override
void initState(){
  cartList = Provider.of<CartProvider>(context, listen: false);
      cartList!.getData(); 
  getEmail();
  super.initState();
}
  Future deleteAll({required List<Cart> list}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   
       setState(() {
        for (int i = 0; i < list.length; i++) {
          dbHelper.delete(list[i].did!);
          cartList!.removeCounter();
        }

       // widget.set();
      });
  }
String? emaill;
  DBHelper dbHelper = DBHelper();
      List<Cart> list = [];
  CartProvider? cartList = CartProvider();
   getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    if (token != null) {
      setState(() {
         emaill = prefs.getString('email');
      });
     
      print(emaill);
      print('${emaill![0]}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(appBar: AppBar(title: Text(emaill!=null?emaill!:'',overflow: TextOverflow.ellipsis,),),
      body: Container(
                        child: Column(children: [
                          
                      
                         dashBoard(context),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ScreenCart()));
                          },
                          leading: iconDrawer(Icons.shopping_cart),
                          title: Text('my_cart'.tr(),
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),

                         ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        WishList()));
                          },
                          leading: iconDrawer(Icons.favorite),
                          title: Text('wish_list'.tr(),
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                         InkWell(
                                onTap: () {
                               deleteAll(list: cartList!.list);
                                  signOut();
                                 
                                 
        
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Splash(
                                                login: "0",
                                              )));
                                },
                                child: ListTile(
                                  leading: iconDrawer(Icons.logout_outlined),
                                  title: Text('sign_out'.tr(),
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ),
                       
                        ]),
                      ),);
    
  }
}