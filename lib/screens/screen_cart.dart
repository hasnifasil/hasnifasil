import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:pmc_app/API/constats/styles.dart';
import 'package:pmc_app/models/add_to_cart_model.dart';
import 'package:pmc_app/models/cart_model.dart';
import 'package:pmc_app/models/cart_provider.dart';
import 'package:pmc_app/models/db_helper.dart';
import 'package:pmc_app/models/read_cart_data_model.dart';
import 'package:pmc_app/models/wish_provider.dart';
import 'package:http/http.dart' as http;
import 'package:pmc_app/provider/cartListing_provider.dart';
import 'package:pmc_app/provider/cart_length_provider.dart';
import 'package:pmc_app/screens/checkout.dart';

import 'package:pmc_app/screens/screen_login.dart';
import 'package:pmc_app/screens/screens.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../API/constats/constant_api.dart';

class ScreenCart extends StatefulWidget {
  ScreenCart({Key? key}) : super(key: key);

  @override
  State<ScreenCart> createState() => _ScreenCartState();
}

class _ScreenCartState extends State<ScreenCart> {
  DBHelper? dbHelper = DBHelper();
  bool isIncrement = false;
  bool loading = false;
  List<Cart> list = [];
  bool isloading = true;
  double quantity = 1.0;

  @override
  void initState() {
    Provider.of<CartListProvider>(context, listen: false).getCartListData();

    super.initState();
  }

  bool deletingCartItem = false;
  deleteCartItem(int prod_id, int line_id) async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final sale_id = prefs.getInt('sale_id') ?? "";
    Dio dio = Dio();

    final token = prefs.getString('token') ?? "";
    Map<String, dynamic> data = {
      "token": token,
      "product_id": prod_id,
      "sale_id": sale_id,
      "line_id": line_id
    };

    final response =
        await dio.post(base_url + 'api/delete/cart/item', data: data);

    if (response.statusCode == 200) {
      Provider.of<CartListProvider>(context, listen: false).getCartListData();
      Provider.of<CartLengthProvider>(context, listen: false).getCartLength();
      Map<dynamic, dynamic> map = Map<String, dynamic>.from(response.data);
      print(response.data);
      setState(() {
        deletingCartItem = true;
      });
    }

    Navigator.pop(context);
    setState(() {});
  }

  bool isLoadingAddcartfun = false;

  //List<Details> cartDetail = [];
  getCart(bool incrDecr, String prod_id, att_val) async {
    isLoadingAddcartfun = true;
    showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        });
    // cartDetail.clear();
    List<Cart> list = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> order_list = [];
    final sale_id = prefs.getInt('sale_id') ?? "";
    Dio dio = Dio();

    final token = prefs.getString('token') ?? "";
    Map<String, dynamic> data = {
      "token": token,
      "product_id": prod_id,
      "qty": 1,
      "att_value_id": att_val,
      "sale_id": sale_id,
      "increment": incrDecr
    };
    print(data);
    final response = await dio.post(base_url + 'api/add/cart', data: data);

    if (response.statusCode == 200) {
      Provider.of<CartListProvider>(context, listen: false).getCartListData();
      Map<dynamic, dynamic> map = Map<String, dynamic>.from(response.data);
      print(response.data);

      setState(() {
        isIncrement = false;
      });

      // CartModel data = CartModel.fromJson(response.data);

      Navigator.pop(context);
      print(response.data);
    } else {}
    setState(() {
      isLoadingAddcartfun = false;
    });
  }

  bool isLoadingCart = true;
  dynamic totalAmount;
  List<Detail> cartItemsList = [];
  getCartListItems() async {
    cartItemsList.clear();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final sale_id = prefs.getInt('sale_id') ?? "";
    Dio dio = Dio();

    final response =
        await dio.get(base_url + 'api/read/cart/data?sale_id=$sale_id');
    print(response.data);
    if (response.statusCode == 200) {
      print(response.data);
      Map<dynamic, dynamic> map = Map<String, dynamic>.from(response.data);
      prefs.setString('reference', map['name']);
      print(response.data);
      if (map['total_amount'] != null) {
        setState(() {
          isLoadingCart = false;
          totalAmount = map['total_amount'] ?? 0.0;

          print(totalAmount);
        });
      }

      AllCartItems data = AllCartItems.fromJson(response.data);
      setState(() {
        cartItemsList.addAll(data.details!);
        isloading = false;
        isLoadingCart = false;
      });

      print(response.data);
    } else {
      print(response.data);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    CartProvider? cart = Provider.of<CartProvider>(context, listen: false);
    var wish = Provider.of<WishProvider>(context, listen: false);
    var count = 0;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
                leading: IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: ((context) => Screens())));
                    },
                    icon: Icon(Icons.arrow_back_ios)),
                elevation: 0,
                centerTitle: true,
                title: Text('cart'.tr()),
                actions: [
                  Container(
                    margin: EdgeInsets.only(right: 6),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                  )
                ]),
            body:
                (Provider.of<CartLengthProvider>(context, listen: false)
                            .cartLength !=
                        0)
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Consumer<CartListProvider>(
                            builder: (context, snapshot, _) {
                          return snapshot.isl == true
                              ? Center(child: CircularProgressIndicator())
                              : Column(children: [
                                  Expanded(
                                    child: Container(
                                      height: 200,
                                      child: ListView.builder(
                                          itemCount:
                                              snapshot.getCartList.length,
                                          itemBuilder: (context, index) {
                                            return Card(
                                              elevation: 6,
                                              shadowColor: grey,
                                              margin: EdgeInsets.all(7),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    (snapshot.getCartList[index]
                                                                    .image !=
                                                                null &&
                                                            snapshot
                                                                .getCartList[
                                                                    index]
                                                                .image!
                                                                .isNotEmpty)
                                                        ? Card(
                                                            elevation: 5,
                                                            child: Image.memory(
                                                              base64Decode(
                                                                snapshot
                                                                    .getCartList[
                                                                        index]
                                                                    .image!,
                                                              ),
                                                              gaplessPlayback:
                                                                  true,
                                                              width: 100,
                                                              height: 100,
                                                            ),
                                                          )
                                                        : Container(
                                                            height: 100,
                                                            width: 100,
                                                            child: Image.asset(
                                                              "assets/images/no_img.png",
                                                              gaplessPlayback:
                                                                  true,
                                                            )),
                                                    SizedBox(
                                                      width: 6,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                snapshot
                                                                    .getCartList[
                                                                        index]
                                                                    .name!,
                                                                maxLines: 3,
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            r"QAR " +
                                                                snapshot
                                                                    .getCartList[
                                                                        index]
                                                                    .price!
                                                                    .toStringAsFixed(
                                                                        2),
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    height: 35,
                                                                    width: 100,
                                                                    decoration: BoxDecoration(
                                                                        color:
                                                                            primaryColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(5)),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              4.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          InkWell(
                                                                              onTap: () {
                                                                                getCart(false, snapshot.getCartList[index].templateId.toString(), snapshot.getCartList[index].attValueId);
                                                                              },
                                                                              child: Icon(
                                                                                Icons.remove,
                                                                                color: white,
                                                                              )),
                                                                          Container(
                                                                            color:
                                                                                white,
                                                                            width:
                                                                                30,
                                                                            child:
                                                                                Center(
                                                                              child: Text(snapshot.getCartList[index].qty!.toStringAsFixed(0), style: TextStyle(color: black)),
                                                                            ),
                                                                          ),
                                                                          InkWell(
                                                                              onTap: () {
                                                                                getCart(true, snapshot.getCartList[index].templateId.toString(), snapshot.getCartList[index].attValueId);
                                                                              },
                                                                              child: Icon(
                                                                                Icons.add,
                                                                                color: white,
                                                                              )),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                      onTap:
                                                                          () {
                                                                        deleteCartItem(
                                                                            snapshot.getCartList[index].templateId!,
                                                                            snapshot.getCartList[index].lineId!);

                                                                        setState(
                                                                            () {});

                                                                        setState(
                                                                            () {
                                                                          deletingCartItem =
                                                                              false;
                                                                        });
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .delete,
                                                                        color:
                                                                            red,
                                                                      ))
                                                                ],
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),

                                      //      ListView.builder(
                                      //         itemCount: cartItemsList.length,
                                      //         itemBuilder: ((context, index) {
                                      //           return Card(
                                      //               elevation: 6,
                                      //               shadowColor: grey,
                                      //               margin: EdgeInsets.all(7),
                                      //               child: Container(
                                      //                 child: Column(
                                      //                   children: [
                                      //                     Container(
                                      //                       height: 35,
                                      //                       width: 100,
                                      //                       decoration: BoxDecoration(
                                      //                           color: primaryColor,
                                      //                           borderRadius:
                                      //                               BorderRadius.circular(5)),
                                      //                       child: Padding(
                                      //                         padding: const EdgeInsets.all(4.0),
                                      //                         child: Row(
                                      //                           mainAxisAlignment:
                                      //                               MainAxisAlignment.spaceBetween,
                                      //                           children: [
                                      //                             InkWell(
                                      //                                 onTap: isIncrement
                                      //                                     ? () {}
                                      //                                     : () {
                                      //                                         int quantity =
                                      //                                             cartItemsList[index]
                                      //                                                 .qty!
                                      //                                                 .toInt();

                                      //                                         quantity--;
                                      //                                           if(widget.callOtherProductData!=null){
                                      //                                           widget.callOtherProductData!();
                                      //                                         }

                                      //                                         getCart(
                                      //                                             false,
                                      //                                             cartItemsList[index]
                                      //                                                 .templateId
                                      //                                                 .toString(),
                                      //                                             cartItemsList[index]
                                      //                                                 .attValueId);
                                      //                                         getCartListItems();
                                      //                                         setState(() {});

                                      //                                         if (quantity > 0) {
                                      //                                           quantity =
                                      //                                               cartItemsList[
                                      //                                                       index]
                                      //                                                   .qty!
                                      //                                                   .toInt();
                                      //                                         }
                                      //                                       },
                                      //                                 child: Icon(
                                      //                                   Icons.remove,
                                      //                                   color: white,
                                      //                                 )),
                                      //                             Container(
                                      //                               color: white,
                                      //                               width: 30,
                                      //                               child: Center(
                                      //                                 child: Text(
                                      //                                     cartItemsList[index]
                                      //                                         .qty
                                      //                                         .toString(),
                                      //                                     style: TextStyle(
                                      //                                         color: black)),
                                      //                               ),
                                      //                             ),
                                      //                             InkWell(
                                      //                                 onTap: isIncrement
                                      //                                     ? () {}
                                      //                                     : () {
                                      //                                         int quantity =
                                      //                                             cartItemsList[index]
                                      //                                                 .qty!
                                      //                                                 .toInt();

                                      //                                         quantity++;
                                      //                                         if(widget.callOtherProductData!=null){
                                      //                                           widget.callOtherProductData!();
                                      //                                         }

                                      //                                         getCart(
                                      //                                             true,
                                      //                                             cartItemsList[index]
                                      //                                                 .templateId
                                      //                                                 .toString(),
                                      //                                             cartItemsList[index]
                                      //                                                 .attValueId);
                                      //                                         getCartListItems();
                                      //                                         setState(() {});
                                      //                                       },
                                      //                                 child: Icon(
                                      //                                   Icons.add,
                                      //                                   color: white,
                                      //                                 )),
                                      //                           ],
                                      //                         ),
                                      //                       ),
                                      //                     ),

                                      //                   ],
                                      //                 ),
                                      //               ));
                                      //         })),
                                      //   ),
                                      // ),

                                      // FutureBuilder(
                                      //     future: Provider.of<CartProvider>(context, listen: false)
                                      //         .getData(),
                                      //     builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
                                      //       if (snapshot.hasData) {
                                      //         if (snapshot.data!.isEmpty) {
                                      //           return Align(
                                      //             alignment: Alignment.center,
                                      //             child: Column(
                                      //               children: [
                                      //                 SizedBox(
                                      //                   height: 20,
                                      //                 ),
                                      //                 Image.asset(
                                      //                   cartImg,
                                      //                   height: 350,
                                      //                 ),
                                      //                 SizedBox(
                                      //                   height: 20,
                                      //                 ),
                                      //               ],
                                      //             ),
                                      //           );
                                      //         } else {
                                      //           return Expanded(
                                      //             child: ListView.builder(
                                      //                 itemCount: snapshot.data!.length,
                                      //                 itemBuilder: (context, index) {
                                      //                   return Card(
                                      //                     elevation: 6,
                                      //                     shadowColor: grey,
                                      //                     margin: EdgeInsets.all(7),
                                      //                     child: Padding(
                                      //                       padding: const EdgeInsets.all(8.0),
                                      //                       child: Column(
                                      //                         mainAxisAlignment:
                                      //                             MainAxisAlignment.center,
                                      //                         crossAxisAlignment:
                                      //                             CrossAxisAlignment.start,
                                      //                         children: [
                                      //                           Row(
                                      //                             mainAxisAlignment:
                                      //                                 MainAxisAlignment.start,
                                      //                             crossAxisAlignment:
                                      //                                 CrossAxisAlignment.center,
                                      //                             mainAxisSize: MainAxisSize.max,
                                      //                             children: [
                                      //                               (snapshot.data![index].image !=
                                      //                                           null &&
                                      //                                       snapshot.data![index]
                                      //                                           .image.isNotEmpty)
                                      //                                   ? Card(
                                      //                                       elevation: 5,
                                      //                                       child: Image.memory(
                                      //                                         base64Decode(
                                      //                                           snapshot.data![index]
                                      //                                               .image,
                                      //                                         ),
                                      //                                         gaplessPlayback: true,
                                      //                                         width: 100,
                                      //                                         height: 100,
                                      //                                       ),
                                      //                                     )
                                      //                                   : Container(
                                      //                                       height: 100,
                                      //                                       width: 100,
                                      //                                       decoration:
                                      //                                           BoxDecoration(),
                                      //                                       child: Card(
                                      //                                         elevation: 5,
                                      //                                         child: Image.asset(
                                      //                                           "assets/images/no_img.png",
                                      //                                           gaplessPlayback: true,
                                      //                                         ),
                                      //                                       )),
                                      //                               SizedBox(
                                      //                                 width: 6,
                                      //                               ),
                                      //                               Expanded(
                                      //                                 child: Column(
                                      //                                   mainAxisAlignment:
                                      //                                       MainAxisAlignment.start,
                                      //                                   crossAxisAlignment:
                                      //                                       CrossAxisAlignment.start,
                                      //                                   children: [
                                      //                                     Column(
                                      //                                       mainAxisAlignment:
                                      //                                           MainAxisAlignment
                                      //                                               .spaceBetween,
                                      //                                       children: [
                                      //                                         Text(
                                      //                                           snapshot
                                      //                                               .data![index].name
                                      //                                               .toString(),
                                      //                                           maxLines: 1,
                                      //                                           style: TextStyle(
                                      //                                             fontSize: 14,
                                      //                                             fontWeight:
                                      //                                                 FontWeight.w500,
                                      //                                           ),
                                      //                                         ),
                                      //                                         if (snapshot
                                      //                                                     .data![
                                      //                                                         index]
                                      //                                                     .color !=
                                      //                                                 null &&
                                      //                                             snapshot
                                      //                                                 .data![index]
                                      //                                                 .colorname
                                      //                                                 .isNotEmpty)
                                      //                                           Text(snapshot
                                      //                                               .data![index]
                                      //                                               .colorname),
                                      //                                         if (snapshot
                                      //                                                     .data![
                                      //                                                         index]
                                      //                                                     .power !=
                                      //                                                 null &&
                                      //                                             snapshot
                                      //                                                 .data![index]
                                      //                                                 .powername
                                      //                                                 .isNotEmpty)
                                      //                                           Text(snapshot
                                      //                                               .data![index]
                                      //                                               .powername),
                                      //                                         if (snapshot
                                      //                                                     .data![
                                      //                                                         index]
                                      //                                                     .size !=
                                      //                                                 null &&
                                      //                                             snapshot
                                      //                                                 .data![index]
                                      //                                                 .sizename
                                      //                                                 .isNotEmpty)
                                      //                                           Text(snapshot
                                      //                                               .data![index]
                                      //                                               .sizename)
                                      //                                       ],
                                      //                                     ),
                                      //                                     SizedBox(
                                      //                                       height: 5,
                                      //                                     ),
                                      //                                     Text(
                                      //                                       r"QAR " +
                                      //                                           snapshot.data![index]
                                      //                                               .initialprice
                                      //                                               .toStringAsFixed(
                                      //                                                   2),
                                      //                                       style: TextStyle(
                                      //                                           fontSize: 15,
                                      //                                           fontWeight:
                                      //                                               FontWeight.w500),
                                      //                                     ),
                                      //                                     SizedBox(
                                      //                                       height: 5,
                                      //                                     ),
                                      //                                     Row(
                                      //                                       mainAxisAlignment:
                                      //                                           MainAxisAlignment
                                      //                                               .spaceBetween,
                                      //                                       children: [
                                      //                                         InkWell(
                                      //                                           onTap: () {},
                                      //                                           child: Container(
                                      //                                             height: 35,
                                      //                                             width: 100,
                                      //                                             decoration: BoxDecoration(
                                      //                                                 color:
                                      //                                                     primaryColor,
                                      //                                                 borderRadius:
                                      //                                                     BorderRadius
                                      //                                                         .circular(
                                      //                                                             5)),
                                      //                                             child: Padding(
                                      //                                               padding:
                                      //                                                   const EdgeInsets
                                      //                                                       .all(4.0),
                                      //                                               child: Row(
                                      //                                                 mainAxisAlignment:
                                      //                                                     MainAxisAlignment
                                      //                                                         .spaceBetween,
                                      //                                                 children: [
                                      //                                                   InkWell(
                                      //                                                       onTap:
                                      //                                                          isIncrement?(){}: () {
                                      //                                                         int quantity = snapshot
                                      //                                                             .data![index]
                                      //                                                             .quantity;
                                      //                                                         double price = snapshot
                                      //                                                             .data![index]
                                      //                                                             .initialprice;
                                      //                                                         quantity--;
                                      //                                                         getCart(false ,snapshot.data![index].pid.toString(),snapshot.data![index].color);
                                      //                                                         double?
                                      //                                                             newPrice =
                                      //                                                             price *
                                      //                                                                 quantity;

                                      //                                                         if (quantity >
                                      //                                                             0) {
                                      //                                                           dbHelper!.updateQuantity(Cart(colorname: snapshot.data![index].colorname, powername: snapshot.data![index].powername, sizename: snapshot.data![index].sizename, volumename: snapshot.data![index].volumename, modelname: snapshot.data![index].modelname, color: snapshot.data![index].color, power: snapshot.data![index].power, attType: snapshot.data![index].attType, size: snapshot.data![index].size, model: snapshot.data![index].model, l85: snapshot.data![index].l85, mg: snapshot.data![index].mg, flavour: snapshot.data![index].flavour, flvr: snapshot.data![index].flvr, type: '0', did: snapshot.data![index].did, pid: snapshot.data![index].pid, name: snapshot.data![index].name, initialprice: snapshot.data![index].initialprice, price: newPrice, quantity: quantity, image: snapshot.data![index].image)).then(
                                      //                                                               (value) {
                                      //                                                             newPrice =
                                      //                                                                 0;
                                      //                                                             quantity =
                                      //                                                                 snapshot.data![index].quantity;
                                      //                                                             cart.removeTotal(double.parse(snapshot.data![index].initialprice.toString()));
                                      //                                                             setState(() {});
                                      //                                                           }).onError((error,
                                      //                                                               stackTrace) {
                                      //                                                             print(error.toString());
                                      //                                                           });
                                      //                                                         }
                                      //                                                       },
                                      //                                                       child:
                                      //                                                           Icon(
                                      //                                                         Icons
                                      //                                                             .remove,
                                      //                                                         color:
                                      //                                                             white,
                                      //                                                       )),
                                      //                                                   Container(
                                      //                                                     color:
                                      //                                                         white,
                                      //                                                     width: 30,
                                      //                                                     child:
                                      //                                                         Center(
                                      //                                                       child: Text(
                                      //                                                           snapshot
                                      //                                                               .data![
                                      //                                                                   index]
                                      //                                                               .quantity
                                      //                                                               .toString(),
                                      //                                                           style:
                                      //                                                               TextStyle(color: black)),
                                      //                                                     ),
                                      //                                                   ),
                                      //                                                   InkWell(
                                      //                                                       onTap:isIncrement?(){}:
                                      //                                                           () {
                                      //                                                         int quantity = snapshot
                                      //                                                             .data![index]
                                      //                                                             .quantity;
                                      //                                                         double price = snapshot
                                      //                                                             .data![index]
                                      //                                                             .initialprice;
                                      //                                                         quantity++;

                                      //                                                         double?
                                      //                                                             newPrice =
                                      //                                                             price *
                                      //                                                                 quantity;

                                      //                                                         dbHelper!
                                      //                                                             .updateQuantity(Cart(
                                      //                                                                 colorname: snapshot.data![index].colorname,
                                      //                                                                 powername: snapshot.data![index].powername,
                                      //                                                                 sizename: snapshot.data![index].sizename,
                                      //                                                                 volumename: snapshot.data![index].volumename,
                                      //                                                                 modelname: snapshot.data![index].modelname,
                                      //                                                                 color: snapshot.data![index].color,
                                      //                                                                 power: snapshot.data![index].power,
                                      //                                                                 attType: snapshot.data![index].attType,
                                      //                                                                 size: snapshot.data![index].size,
                                      //                                                                 model: snapshot.data![index].model,
                                      //                                                                 l85: snapshot.data![index].l85,
                                      //                                                                 mg: snapshot.data![index].mg,
                                      //                                                                 flavour: snapshot.data![index].flavour,
                                      //                                                                 flvr: snapshot.data![index].flvr,
                                      //                                                                 type: '0',
                                      //                                                                 did: snapshot.data![index].did,
                                      //                                                                 pid: snapshot.data![index].pid,
                                      //                                                                 name: snapshot.data![index].name,
                                      //                                                                 initialprice: snapshot.data![index].initialprice,
                                      //                                                                 price: newPrice,
                                      //                                                                 quantity: quantity,
                                      //                                                                 image: snapshot.data![index].image.toString()))
                                      //                                                             .then((value) {
                                      //                                                           newPrice =
                                      //                                                               0;
                                      //                                                           quantity =
                                      //                                                               0;
                                      //                                                           cart.addTotalPrice(double.parse(snapshot
                                      //                                                               .data![index]
                                      //                                                               .initialprice
                                      //                                                               .toString()));
                                      //                                                           setState(
                                      //                                                               () {});
                                      //                                                         }).onError((error, stackTrace) {
                                      //                                                           print(
                                      //                                                               error.toString());
                                      //                                                         });
                                      //                                                         getCart(true,snapshot.data![index].pid.toString(),snapshot.data![index].color);
                                      //                                                       },
                                      //                                                       child:
                                      //                                                           Icon(
                                      //                                                         Icons
                                      //                                                             .add,
                                      //                                                         color:
                                      //                                                             white,
                                      //                                                       )),
                                      //                                                 ],
                                      //                                               ),
                                      //                                             ),
                                      //                                           ),
                                      //                                         ),
                                      //                                         InkWell(
                                      //                                             onTap: () {
                                      //                                               dbHelper!.delete(
                                      //                                                   snapshot
                                      //                                                       .data![
                                      //                                                           index]
                                      //                                                       .did!);

                                      //                                               cart.removeTotal(double
                                      //                                                   .parse(snapshot
                                      //                                                       .data![
                                      //                                                           index]
                                      //                                                       .price
                                      //                                                       .toString()));
                                      //                                               if (cart.counter >=
                                      //                                                   1) {
                                      //                                                 cart.removeCounter();
                                      //                                               }
                                      //                                               setState(() {});
                                      //                                             },
                                      //                                             child: Icon(
                                      //                                               Icons.delete,
                                      //                                               color: red,
                                      //                                             ))
                                      //                                       ],
                                      //                                     ),
                                      //                                   ],
                                      //                                 ),
                                      //                               )
                                      //                             ],
                                      //                           )
                                      //                         ],
                                      //                       ),
                                      //                     ),
                                      //                   );
                                      //                 }),
                                      //           );
                                      //         }
                                      //       }
                                      //       return Text('');
                                      //     }),
                                      //   ,  Consumer<CartProvider>(builder: (context, value, child) {
                                      //       return Visibility(
                                      //         visible: value.getTotalPrice().toStringAsFixed(2) == "0.00"
                                      //             ? false
                                      //             : true,
                                      //         child: Column(
                                      //           children: [
                                      //             ReusableWidget(
                                      //               title: 'sub_total'.tr(),
                                      //               value: r'QAR ' +
                                      //                   value.getTotalPrice().toStringAsFixed(2),
                                      //             ),
                                      //             ReusableWidget(
                                      //               title: 'total'.tr(),
                                      //               value: r'QAR ' +
                                      //                   value.getTotalPrice().toStringAsFixed(2),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //       );
                                      //     }),
                                      //     Consumer<CartProvider>(
                                      //       builder: (context, p, c) {
                                      //         return Visibility(
                                      //           visible: p.getTotalPrice().toStringAsFixed(2) == "0.00"
                                      //               ? false
                                      //               : true,
                                      //           child: InkWell(
                                      //             onTap: () {
                                      //               isLogged(context);
                                      //             },
                                      //             child: Container(
                                      //               decoration: BoxDecoration(
                                      //                   borderRadius: BorderRadius.circular(5),
                                      //                   color: primaryColor),
                                      //               width: double.infinity,
                                      //               height: 40,
                                      //               child: Center(
                                      //                 child: Text('proceed_to_checkout'.tr(),
                                      //                     style: TextStyle(
                                      //                         fontSize: 20,
                                      //                         fontWeight: FontWeight.bold,
                                      //                         color: Colors.white)),
                                      //               ),
                                      //             ),
                                      //           ),
                                      //         );
                                      //       },
                                      //     ),
                                      //   ],
                                      // ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: (Provider.of<CartLengthProvider>(
                                                    context,
                                                    listen: false)
                                                .cartLength !=
                                            0)
                                        ? true
                                        : false,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('total'.tr(),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                Provider.of<CartListProvider>(
                                                        context,
                                                        listen: false)
                                                    .total
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: (Provider.of<CartLengthProvider>(
                                                    context,
                                                    listen: false)
                                                .cartLength !=
                                            0)
                                        ? true
                                        : false,
                                    child: InkWell(
                                      onTap: () {
                                        isLogged(context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: primaryColor),
                                        width: double.infinity,
                                        height: 40,
                                        child: Center(
                                          child: Text(
                                              'proceed_to_checkout'.tr(),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]);
                        }),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/empty_cart.png",
                              gaplessPlayback: true,
                            ),
                            Text(
                              'cart_empty'.tr(),
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      )));
  }

  Future isLogged(BuildContext ctx) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') == null) {
      Navigator.push(
          ctx, MaterialPageRoute(builder: (context) => ScreenLogin()));
    } else {
      Navigator.pushReplacement(
          ctx, MaterialPageRoute(builder: (context) => CheckoutScreen()));
    }
  }

  setStateCall() async {
    print("<><><><><><><>><");
    setState(() {});
  }
}

class ReusableWidget extends StatelessWidget {
  String title, value;
  ReusableWidget({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(
            value.toString(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ]),
      ),
    );
  }
}
