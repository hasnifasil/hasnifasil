import 'dart:async';
import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:pmc_app/API/constats/constant_api.dart';
import 'package:pmc_app/API/constats/styles.dart';
import 'package:pmc_app/models/cart_model.dart';
import 'package:pmc_app/models/cart_provider.dart';
import 'package:pmc_app/models/db_helper.dart';
import 'package:pmc_app/models/wish_provider.dart';
import 'package:pmc_app/provider/cart_length_provider.dart';
import 'package:pmc_app/screens/screen_cart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishList extends StatefulWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  DBHelpers dbHelpers = DBHelpers();
  DBHelper dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    setStatecall();
  }

  setStatecall() {
    Timer(const Duration(seconds: 1), () {
      print("!!!!!!!!!!!!!!!!!!!!!!");
      setState(() {});
    });
  }

  getBuyOne(bool incrDecr, int qty, int proid, att_values) async {
    List<Cart> list = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> order_list = [];
    final sale_id = prefs.getInt('sale_id') ?? "";

    final token = prefs.getString('token') ?? "";
    Map<String, dynamic> data = {
      "token": token,
      "product_id": proid,
      "qty": qty,
      "att_value_id": att_values,
      "sale_id": sale_id,
      "increment": incrDecr
    };
    print(data);

    setState(() {});
    // var formData = FormData.fromMap(data);
    Dio dio = Dio();

    final response = await dio.post(base_url + 'api/add/cart', data: data);
    print(response.data);

    if (response.statusCode == 200) {
      Map<String, dynamic> map = Map<String, dynamic>.from(response.data);
      print(response.data);

      setState(() {
        if (map['result']['qty'] != null) {}
      });
      if (map['result']['message'] == 'no product') {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: yellow,
              margin: EdgeInsets.all(10),
              behavior: SnackBarBehavior.floating,
              content: Text(
                "Sorry..Product not available",
                textAlign: TextAlign.center,
                style: TextStyle(color: black),
              )));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final wish = Provider.of<WishProvider>(context, listen: false);
    final cartp = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('wish_list'.tr())),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 3, left: 18, right: 13),
        decoration: containerBox(),
        child: Column(
          children: [
            FutureBuilder(
                future: wish.getData(),
                builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 200,
                            ),
                            Center(
                                child: Text(
                              'no_product_in_wish'.tr(),
                              style: TextStyle(fontSize: 17),
                            )),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 5,
                                shadowColor: Colors.grey[700],
                                margin: EdgeInsets.all(7),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          (snapshot.data![index].image != null)
                                              ? Image.memory(
                                                  base64Decode(
                                                    snapshot.data![index].image,
                                                  ),
                                                  gaplessPlayback: true,
                                                  width: 100,
                                                  height: 100,
                                                )
                                              : Image.asset(
                                                  "assets/images/no_img.png",
                                                  gaplessPlayback: true,
                                                ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      snapshot.data![index].name
                                                          .toString()
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        overflow:
                                                            TextOverflow.clip,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'QAR  ' +
                                                      snapshot
                                                          .data![index].price
                                                          .toStringAsFixed(2),
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          print(
                                                              'hiiiiiiiiiiiiiiiiiiiiiiiiiiiii');

                                                          dbHelper
                                                              .insert(Cart(
                                                                  colorname: snapshot
                                                                      .data![
                                                                          index]
                                                                      .colorname,
                                                                  powername: snapshot
                                                                      .data![
                                                                          index]
                                                                      .powername,
                                                                  sizename: snapshot
                                                                      .data![
                                                                          index]
                                                                      .sizename,
                                                                  volumename: snapshot
                                                                      .data![
                                                                          index]
                                                                      .volumename,
                                                                  modelname: snapshot
                                                                      .data![
                                                                          index]
                                                                      .modelname,
                                                                  color: snapshot
                                                                      .data![
                                                                          index]
                                                                      .color,
                                                                  power: snapshot
                                                                      .data![
                                                                          index]
                                                                      .power,
                                                                  attType: snapshot
                                                                      .data![
                                                                          index]
                                                                      .attType,
                                                                  size: snapshot
                                                                      .data![
                                                                          index]
                                                                      .size,
                                                                  model: snapshot
                                                                      .data![
                                                                          index]
                                                                      .model,
                                                                  l85: snapshot
                                                                      .data![
                                                                          index]
                                                                      .l85,
                                                                  mg: snapshot
                                                                      .data![
                                                                          index]
                                                                      .mg,
                                                                  flavour: snapshot
                                                                      .data![
                                                                          index]
                                                                      .flavour,
                                                                  flvr: snapshot
                                                                      .data![
                                                                          index]
                                                                      .flvr,
                                                                  type: '0',
                                                                  did: snapshot
                                                                      .data![
                                                                          index]
                                                                      .did,
                                                                  pid: snapshot
                                                                      .data![
                                                                          index]
                                                                      .pid,
                                                                  name:
                                                                      snapshot.data![index].name,
                                                                  image: snapshot.data![index].image,
                                                                  initialprice: snapshot.data![index].price,
                                                                  price: snapshot.data![index].price,
                                                                  quantity: 1))
                                                              .then((value) {
                                                            print('added');
                                                            cartp.addTotalPrice(
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .price);
                                                            cartp.addCounter();

                                                            dbHelpers.delete(
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .did!);
                                                            if (wish.counter >
                                                                0) {
                                                              wish.removeCounter();
                                                              setState(() {});
                                                              print('removed');
                                                            }
                                                          }).onError((error, stackTrace) {
                                                            print(error
                                                                .toString());
                                                            wish.removeCounter();
                                                          });
                                                          setState(() {
                                                            dbHelpers.delete(
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .did!);

                                                            // wish.removeCounter();
                                                          });
                                                          getBuyOne(
                                                              true,
                                                              1,
                                                              snapshot
                                                                  .data![index]
                                                                  .did!,
                                                              [
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .color,
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .power,
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .size,
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .model
                                                              ]);
                                                          Provider.of<CartLengthProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .getCartLength();
                                                        },
                                                        child: Text(
                                                          'Move to Cart',
                                                          style: TextStyle(
                                                              fontSize: 17),
                                                        )),
                                                    InkWell(
                                                        onTap: () {
                                                          dbHelpers
                                                              .delete(snapshot
                                                                  .data![index]
                                                                  .did!)
                                                              .then((value) {
                                                            print("Successs");
                                                          });
                                                          if (wish.counter >
                                                              0) {
                                                            wish.removeCounter();
                                                          }
                                                          setState(() {});
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            const Icon(
                                                              Icons.delete,
                                                              color: Colors.red,
                                                            ),
                                                          ],
                                                        )),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                  }
                  return Text('');
                }),
          ],
        ),
      ),
    );
  }
}
