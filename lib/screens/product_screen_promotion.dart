import 'dart:convert';

import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:pmc_app/API/constats/constant_api.dart';
import 'package:pmc_app/API/constats/styles.dart';
import 'package:pmc_app/models/cart_model.dart';
import 'package:pmc_app/models/cart_provider.dart';
import 'package:pmc_app/models/db_helper.dart';
import 'package:pmc_app/models/product_variant.dart' as pvariant;
import 'package:pmc_app/models/product_variant.dart';

import 'package:pmc_app/models/promotion_model.dart';
import 'package:pmc_app/models/wish.model.dart';
import 'package:pmc_app/models/wish_provider.dart';
import 'package:pmc_app/screens/screen_cart.dart';

import 'package:pmc_app/screens/wishlist.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';
import 'package:share/share.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_variant.dart';

class ProductScreenPromotion extends StatefulWidget {
  Beauty beauty;
  String type;

  ProductScreenPromotion({Key? key, required this.beauty, required this.type})
      : super(key: key);

  @override
  _ProductScreenPromotionState createState() => _ProductScreenPromotionState();
}

class _ProductScreenPromotionState extends State<ProductScreenPromotion> {
  bool onPressed = false;
  DBHelper dbhelper = DBHelper();
  DBHelpers dbHelpers = DBHelpers();
  var count = 0;
  int quantity = 1;
  DBHelper? cartDb;
  bool isAddtoCartCalled = false;
  CartProvider? cartp;
  WishProvider? wish;
  bool isload = true;
  List<Cart> list = [];
  bool loading = true;

  List<pvariant.Color>? colors = [];
  List<pvariant.Design>? design = [];
  List<pvariant.Eight>? eight = [];

  List<pvariant.FLAVOR>? flvor = [];
  List<pvariant.Flavour>? flavour2 = [];
  List<pvariant.Mg>? mG = [];
  List<pvariant.Model>? models = [];
  List<pvariant.PackageQuantity>? packageQuantity = [];
  List<pvariant.Power>? power = [];
  List<pvariant.ProductPageType>? productPageType = [];
  List<pvariant.Scent>? scents = [];
  List<pvariant.Size> sizes = [];
  List<pvariant.Template>? template = [];
  List<pvariant.Type>? type = [];
  List<pvariant.Volume>? volume = [];

  List<pvariant.Powe>? powe1 = [];

  List<String> toDatabase = [];
  int selectedValueIndex = 0;
  String selectedPower = '';
  String selectedSize = '';
  String selectedDesign = '';
  String selectedColor = '';
  String selectedType = '';
  String selectedFlavour = "";
  String selectedFlvor = "";
  String selectedTemplate = "";

  String selectedproductPage = "";
  // String attributeValueToTheDatabase = '';
  String selectedpackageQuantity = "";
  String selectedScent = "";
  String selectedmG = "";
  String selectedl85 = "";
  String selectedVolume = "";
  String selectedModel = "";

  String newImage = "";

  addDatabase() {
    String values = toDatabase.join(',');
  }

  @override
  void initState() {
    cartDb = DBHelper();
    cartDb!.getCartList();
    // update(widget.beauty.price);
    // getVariants(widget.beauty.id);
    // Timer()
    WidgetsBinding.instance.addPostFrameCallback((t) {
      cartp = Provider.of<CartProvider>(context, listen: false);
      wish = Provider.of<WishProvider>(context, listen: false);
      print(widget.beauty.id);
      getVariants(widget.beauty.id);
      cartp!.getData().then((value) {
        print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
        setState(() {
          list = value;
          print(list.length);
          // checkProductAddedorNot(attributeId() ?? widget.beauty.id);
        });
      });
      wish!.getData().then((value) {
        setState(() {
          list = value;
          print(list.length);
        });
        checkProductInWish();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.beauty.name),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ScreenCart()));
            },
            child: Container(
              margin: EdgeInsets.only(right: 7),
              child: Row(
                children: [
                  Center(
                    child: Badge(
                      position: BadgePosition(end: 1, top: 0.5),
                      showBadge: true,
                      badgeContent: Consumer<WishProvider>(
                        builder: (context, value, child) {
                          return Text(value.getCounter().toString(),
                              style: TextStyle(color: white));
                        },
                      ),
                      animationType: BadgeAnimationType.fade,
                      animationDuration: Duration(milliseconds: 300),
                      child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WishList()));
                          },
                          icon: Icon(Icons.favorite)),
                    ),
                  ),
                  Center(
                    child: Badge(
                        position: BadgePosition(end: -5, top: 0),
                        showBadge: true,
                        badgeContent: Consumer<CartProvider>(
                          builder: (context, value, child) {
                            return Text(value.getCounter().toString(),
                                style: TextStyle(color: white));
                          },
                        ),
                        animationType: BadgeAnimationType.fade,
                        animationDuration: Duration(milliseconds: 300),
                        child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ScreenCart()));
                            },
                            icon: Icon(Icons.shopping_bag_outlined))),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          7,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Image.network(
                          //     'https://png.pngtree.com/png-clipart/20190516/original/pngtree-instagram-icon-png-image_3584852.png'),
                          Card(
                            elevation: 10,
                            child: Stack(children: [
                              Container(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: InteractiveViewer(
                                    minScale: 0.1,
                                    maxScale: 4.0,
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: (widget.beauty.image != null &&
                                              widget.beauty.image.isNotEmpty)
                                          ? Image.memory(
                                              base64Decode((newImage != null &&
                                                      newImage.isNotEmpty)
                                                  ? newImage
                                                  : widget.beauty.image),
                                              gaplessPlayback: true,
                                              height: 250,
                                              width: 250,
                                            )
                                          : Container(
                                              child: Image.asset(
                                                "assets/images/no_img.png",
                                                gaplessPlayback: true,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              )),
                              Align(
                                alignment: Alignment.topRight,
                                child: Column(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            onPressed = !onPressed;
                                            addfav();
                                          });
                                        },
                                        icon: Icon(
                                          (onPressed)
                                              ? Icons.favorite
                                              : Icons.favorite_border_outlined,
                                          color: (onPressed) ? red : grey,
                                        )),
                                    shareIcon(widget.beauty.name)
                                  ],
                                ),
                              ),
                            ]),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0, top: 8),
                            child: Text(
                              widget.beauty.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: black, fontSize: 17),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          if (widget.beauty.discount_price != null &&
                              widget.beauty.discount_price.isNotEmpty)
                            Text(
                              r"QAR  " + widget.beauty.discount_price,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          if (widget.beauty.discount_price.isEmpty)
                            Text(
                              r"QAR  " + widget.beauty.price.toStringAsFixed(2),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          // if (design!.isNotEmpty)
                          //   VariantList(design!, 'design', 'Design'),
                          // if (sizes.isNotEmpty)
                          //   VariantList(sizes, 'size', 'Size'),

                          // if (type!.isNotEmpty)
                          //   VariantList(type!, 'type', 'Type'),
                          // if (scents!.isNotEmpty)
                          //   VariantList(scents!, 'scents', 'Scent'),
                          // if (flavour2!.isNotEmpty)
                          //   VariantList(flavour2!, 'flavour2', 'Flavour'),
                          // if (flvor!.isNotEmpty)
                          //   VariantList(flvor!, 'flvor', 'Flavour'),
                          // if (eight!.isNotEmpty)
                          //   VariantList(eight!, 'eight', 'l85'),
                          // if (productPageType!.isNotEmpty)
                          //   VariantList(productPageType!, 'productType',
                          //       'Product Type'),
                          // if (powe1!.isNotEmpty)
                          //   VariantList(powe1!, 'powe', 'Power'),
                          // if (packageQuantity!.isNotEmpty)
                          //   VariantList(packageQuantity!, 'packageQuantity',
                          //       'Package Quantity'),
                          if (power!.isNotEmpty)
                            //VariantList(power!, 'power', 'Power'),
                            getDropList(power!, 'power', 'Select power'),
                          if (colors!.isNotEmpty)
                            getDropList(colors!, 'color', 'Select color'),
                          if (sizes.isNotEmpty)
                            getDropList(sizes, 'size', 'Select size'),
                          if (flavour2!.isNotEmpty)
                            getDropList(flavour2!, 'flavour', 'Select Flavour'),
                          if (powe1!.isNotEmpty)
                            getDropList(powe1!, 'powe', 'Select Powe'),
                          if (packageQuantity!.isNotEmpty)
                            getDropList(packageQuantity!, 'packageQuantity',
                                'Select Package quantity'),
                          if (flvor!.isNotEmpty)
                            getDropList(flvor!, 'flvor', 'Select Flavour'),
                          if (productPageType!.isNotEmpty)
                            getDropList(productPageType!, 'productPageType',
                                'Select Product Page'),
                          if (design!.isNotEmpty)
                            getDropList(design!, 'design', 'Select Design'),
                          if (models!.isNotEmpty)
                            getDropList(models!, 'model', 'Select Model'),
                          if (scents!.isNotEmpty)
                            getDropList(scents!, 'scent', 'Select Scent'),
                          if (scents!.isNotEmpty)
                            getDropList(mG!, 'mG', 'Select mG'),
                          if (scents!.isNotEmpty)
                            getDropList(
                                template!, 'template', 'Select Template'),
                          if (volume!.isNotEmpty)
                            getDropList(volume!, 'volume', 'Select Volume'),
                          if (type!.isNotEmpty)
                            getDropList(type!, 'type', 'Select Type'),

                          //  VariantList(colors!, 'color', 'Color'),

                          // DropdownButtonFormField(
                          //     onChanged: (value) {
                          //       // print(value);
                          //       setState(() {
                          //         print(selectedColor);
                          //         // final sp = selectedColor.split('/');

                          //         // print(sp[1]);
                          //       });
                          //     },
                          //     items: colors!.map((e) {
                          //       return DropdownMenuItem(
                          //           onTap: () async {
                          //             getImage(e.attValueId!);
                          //             checkProductAddedorNot(e.attValueId!);
                          //             selectedColor = e.name! +
                          //                 "/" +
                          //                 e.attValueId!.toString();
                          //             selectedAttributeColorId =
                          //                 e.attValueId!;
                          //           },
                          //           child: Text(e.name!),
                          //           value: e.name! +
                          //               "/" +
                          //               e.attValueId!.toString());
                          //     }).toList()),

                          // DropdownButton<String>(
                          //   items: colordrop.map((item) {
                          //     return new DropdownMenuItem(
                          //         child: new Text(item!), value: selectedColor);
                          //   }).toList(),
                          //   onChanged: (selectedColor) {
                          //     setState(() {
                          //       selectedColor != this.selectedColor;
                          //     });
                          //     for (var i = 0; i < colors!.length; i++) {
                          //       selectedColor = colors![i].name! +
                          //           "/" +
                          //           colors![i].attValueId!.toString();
                          //       selectedColorIndex = i;
                          //       getImage(colors![i].attValueId!);
                          //     }
                          //   },
                          // ),

                          // if (mG!.isNotEmpty) VariantList(mG!, 'mg'),
                          // if (template!.isNotEmpty)
                          //   VariantList(template!, 'template'),

                          SizedBox(
                            height: 8,
                          ),

                          if (widget.beauty.description != null &&
                              widget.beauty.description.isNotEmpty)
                            Row(
                              children: [
                                Text(
                                  "details".tr(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          if (widget.beauty.description != null)
                            SizedBox(
                              height: 10,
                            ),
                          Text(
                            widget.beauty.description,
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 5, left: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: primaryColor),
                          borderRadius: BorderRadius.circular(
                            7,
                          ),
                          color: primaryColor),
                      height: 32,
                      width: 100,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                                onTap: () {
                                  double price = widget.beauty.price;

                                  quantity--;
                                  double? newPrice = price * quantity;
                                  print("new price : $newPrice");

                                  if (quantity >= 1) {
                                    dbhelper
                                        .updateQuantity(Cart(
                                      colorname: colorname,
                                      powername: powername,
                                      sizename: sizename,
                                      volumename: volumename,
                                      modelname: modelname,
                                      color: selectedColor,
                                      power: selectedPower,
                                      attType: selectedType,
                                      size: selectedSize,
                                      flavour: selectedFlavour,
                                      flvr: selectedFlvor,
                                      model: selectedModel,
                                      l85: selectedl85,
                                      mg: selectedmG,
                                      type: widget.type,
                                      did: attributeId() ?? widget.beauty.id,
                                      pid: widget.beauty.id,
                                      name: widget.beauty.name,
                                      initialprice: widget.beauty.price,
                                      price: newPrice,
                                      quantity: quantity,
                                      image: (newImage != null &&
                                              newImage.isNotEmpty)
                                          ? newImage
                                          : widget.beauty.image,
                                    ))
                                        .then((value) {
                                      setState(() {});
                                    }).onError((error, stackTrace) {
                                      print(error.toString());
                                    });
                                  }
                                  // double price = widget.beauty.price;

                                  // quantity--;
                                  // double? newPrice;
                                  // print("new price : $newPrice");
                                  // if (widget.type == '1') {
                                  //   if (quantity.isEven) {
                                  //     print("even");
                                  //     newPrice = price * (quantity / 2);
                                  //     print(newPrice);
                                  //     update(newPrice);
                                  //   } else {
                                  //     if (quantity == 1) {
                                  //       newPrice = (price * quantity);
                                  //       update(newPrice);
                                  //     } else {
                                  //       newPrice = price * ((quantity + 1) / 2);
                                  //       update(newPrice);
                                  //     }
                                  //     print(newPrice);
                                  //   }
                                  // } else if (widget.type == '2') {
                                  //   newPrice = double.parse(
                                  //           widget.beauty.discount_price != null
                                  //               ? widget.beauty.discount_price
                                  //               : widget.beauty.price
                                  //                   .toString()) *
                                  //       quantity;
                                  //   update(newPrice);
                                  // } else if (widget.type == '0') {
                                  //   newPrice = price * quantity;
                                  //   update(newPrice);
                                  // }
                                },
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      '-',
                                      style:
                                          TextStyle(fontSize: 25, color: white),
                                    ),
                                  ),
                                )),
                            Container(
                                width: 30,
                                color: white,
                                child: Center(
                                  child: Text(
                                    '$quantity',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )),
                            InkWell(
                              onTap: () {
                                // double price = widget.beauty.price;

                                // quantity++;
                                // double? newPrice = price * quantity;

                                // if (quantity >= 1) {
                                //   dbhelper
                                //       .updateQuantity(Cart(
                                //           type: '0',
                                //           did: widget.beauty.id,
                                //           pid: widget.beauty.id,
                                //           name: widget.beauty.name,
                                //           initialprice: widget.beauty.price,
                                //           price: newPrice,
                                //           quantity: quantity,
                                //           image: widget.beauty.image))
                                //       .then((value) {
                                //     cartp!.removeTotal(widget.beauty.price);

                                //     setState(() {});
                                //   }).onError((error, stackTrace) {
                                //     print(error.toString());
                                //   });
                                // }
                                quantity++;
                                double price = widget.beauty.price;
                                double? newPrice = price * quantity;
                                // update(double newPrice) {

                                if (quantity > 1) {
                                  dbhelper
                                      .updateQuantity(Cart(
                                    colorname: colorname,
                                    powername: powername,
                                    sizename: sizename,
                                    volumename: volumename,
                                    modelname: modelname,
                                    color: selectedColor,
                                    power: selectedPower,
                                    attType: selectedType,
                                    size: selectedSize,
                                    flavour: selectedFlavour,
                                    flvr: selectedFlvor,
                                    model: selectedModel,
                                    l85: selectedl85,
                                    mg: selectedmG,
                                    type: widget.type,
                                    did: attributeId() ?? widget.beauty.id,
                                    pid: widget.beauty.id,
                                    name: widget.beauty.name,
                                    initialprice: widget.beauty.price,
                                    price: newPrice,
                                    quantity: quantity,
                                    image: (newImage != null &&
                                            newImage.isNotEmpty)
                                        ? newImage
                                        : widget.beauty.image,
                                  ))
                                      .then((value) {
                                    setState(() {});
                                  }).onError((error, stackTrace) {
                                    print(error.toString());
                                  });
                                }

                                //  }
                              },
                              child: Container(
                                child: Center(
                                  child: Text(
                                    '+',
                                    style:
                                        TextStyle(fontSize: 25, color: white),
                                  ),
                                ),
                              ),
                            )
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () async {
              double initialPrice = double.parse(
                  widget.beauty.discount_price != null &&
                          widget.beauty.discount_price.isNotEmpty
                      ? widget.beauty.discount_price
                      : widget.beauty.price.toString());

              dbhelper
                  .insert(Cart(
                      colorname: colorname,
                      powername: powername,
                      sizename: sizename,
                      volumename: volumename,
                      modelname: modelname,
                      color: selectedColor,
                      power: selectedPower,
                      attType: selectedType,
                      size: selectedSize,
                      flavour: selectedFlavour,
                      flvr: selectedFlvor,
                      model: selectedModel,
                      l85: selectedl85,
                      mg: selectedmG,
                      type: widget.type,
                      did: attributeId() ?? widget.beauty.id,
                      pid: widget.beauty.id,
                      name: widget.beauty.name,
                      image: (newImage != null && newImage.isNotEmpty)
                          ? newImage
                          : widget.beauty.image,
                      initialprice: initialPrice,
                      price: widget.beauty.price,
                      quantity: 1))
                  .then((value) {
                print('added');
                getBuyOne();
                setState(() {
                  // isAddtoCartCalled = true;

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: yellow,
                      margin: EdgeInsets.all(10),
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        "Product Added to Cart",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: black),
                      )));
                });
              }).onError((error, stackTrace) {
                print(error.toString());
              });
              if (quantity > 1) {
                double price = widget.beauty.price;

                double? newPrice = price * quantity;
                dbhelper
                    .updateQuantity(Cart(
                  colorname: colorname,
                  powername: powername,
                  sizename: sizename,
                  volumename: volumename,
                  modelname: modelname,
                  color: selectedColor,
                  power: selectedPower,
                  attType: selectedType,
                  size: selectedSize,
                  flavour: selectedFlavour,
                  flvr: selectedFlvor,
                  model: selectedModel,
                  l85: selectedl85,
                  mg: selectedmG,
                  type: widget.type,
                  did: attributeId() ?? widget.beauty.id,
                  pid: widget.beauty.id,
                  name: widget.beauty.name,
                  initialprice: widget.beauty.price,
                  price: newPrice,
                  quantity: quantity,
                  image: (newImage != null && newImage.isNotEmpty)
                      ? newImage
                      : widget.beauty.image,
                ))
                    .then((value) {
                  setState(() {});
                }).onError((error, stackTrace) {
                  print(error.toString());
                });
              }

              //  }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: !isAddtoCartCalled ? primaryColor : yellow,
                ),
                width: double.infinity,
                height: 40,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'add_to_cart'.tr(),
                        style: TextStyle(
                            color: !isAddtoCartCalled ? white : black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      SizedBox(
                        width: 9,
                      ),
                      Icon(
                        Icons.shopping_cart,
                        color: white,
                        size: 28,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  checkProductAddedorNot(int? id) async {
    await Provider.of<CartProvider>(context, listen: false).getData();
    if (list.length != 0) {
      for (int j = 0; j < list.length; j++) {
        if (list[j].did == (id ?? widget.beauty.id)) {
          setState(() {
            isAddtoCartCalled = true;
            quantity = list[j].quantity;
          });
        } else if (list[j].did != (id ?? widget.beauty.id)) {
          setState(() {
            isAddtoCartCalled = false;
          });
        } else {}
      }
    }
  }

  checkProductInWish() {
    if (list.length != 0) {
      for (int j = 0; j < list.length; j++) {
        if (list[j].did == widget.beauty.id) {
          setState(() {
            onPressed = true;
          });
        }
      }
    }
  }

  addfav() {
    if (onPressed) {
      wish!.addCounter();
      dbHelpers.insert(Cart(
          colorname: colorname,
          powername: powername,
          sizename: sizename,
          volumename: volumename,
          modelname: modelname,
          color: selectedColor,
          power: selectedPower,
          attType: selectedType,
          size: selectedSize,
          flavour: selectedFlavour,
          flvr: selectedFlvor,
          model: selectedModel,
          l85: selectedl85,
          mg: selectedmG,
          type: '',
          did: attributeId() ?? widget.beauty.id,
          pid: widget.beauty.id,
          name: widget.beauty.name,
          image: (newImage != null && newImage.isNotEmpty)
              ? newImage
              : widget.beauty.image,
          initialprice: widget.beauty.price,
          price: widget.beauty.price,
          quantity: 1));
    } else {
      wish?.removeCounter();
      dbHelpers.delete(widget.beauty.id);
    }
  }

  update(double newPrice) {
    if (quantity > 0) {
      dbhelper
          .updateQuantity(Cart(
        colorname: colorname,
        powername: powername,
        sizename: sizename,
        volumename: volumename,
        modelname: modelname,
        color: selectedColor,
        power: selectedPower,
        attType: selectedType,
        size: selectedSize,
        flavour: selectedFlavour,
        flvr: selectedFlvor,
        model: selectedModel,
        l85: selectedl85,
        mg: selectedmG,
        type: widget.type,
        did: attributeId() ?? widget.beauty.id,
        pid: widget.beauty.id,
        name: widget.beauty.name,
        initialprice: widget.beauty.price,
        price: newPrice,
        quantity: quantity,
        image: (newImage != null && newImage.isNotEmpty)
            ? newImage
            : widget.beauty.image,
      ))
          .then((value) {
        setState(() {});
      }).onError((error, stackTrace) {
        print(error.toString());
      });
    }
  }

  List colordrop = [];
  // List ab = [];
  // String? clr;

  Future getVariants(int id) async {
    String? lang;
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('language') != null) {
      lang = 'ar';
    } else {
      lang = 'en';
    }
    final response = await http.get(
        Uri.parse(base_url + 'api/read/product/details?id=$id&lang=$lang'));
    print(response);
    if (response.statusCode == 200) {
      print(response.body);
      var responseData = json.decode(response.body);
      // print(responseData);
      ProductVariant data = ProductVariant.fromJson(responseData);

      // isload = false;

      // print(data.attributes!.color!.length);

      if (data.attributes!.mG != null) {
        mG!.addAll(data.attributes!.mG!);
      }
      if (data.attributes!.dESIGN != null) {
        design!.addAll(data.attributes!.dESIGN!);
      }

      if (data.attributes!.size != null) {
        sizes.addAll(data.attributes!.size!);
      }

      if (data.attributes!.flavour != null) {
        flavour2!.addAll(data.attributes!.flavour!);
      }

      if (data.attributes!.scent != null) {
        scents!.addAll(data.attributes!.scent!);
      }

      if (data.attributes!.fLAVOR != null) {
        flvor!.addAll(data.attributes!.fLAVOR!);
      }

      if (data.attributes!.l85 != null) {
        eight!.addAll(data.attributes!.l85!);
      }

      if (data.attributes!.productPageType != null) {
        productPageType!.addAll(data.attributes!.productPageType!);
      }
      if (data.attributes!.volume != null) {
        volume!.addAll(data.attributes!.volume!);
      }
      if (data.attributes!.model != null) {
        models!.addAll(data.attributes!.model!);
      }

      if (data.attributes!.powe != null) {
        powe1!.addAll(data.attributes!.powe!);
        loading = false;
      }

      if (data.attributes!.packageQuantity != null) {
        packageQuantity!.addAll(data.attributes!.packageQuantity!);
      }

      if (data.attributes!.power != null) {
        power!.addAll(data.attributes!.power!);
        loading = false;
      }

      if (data.attributes!.tEMPLATES != null) {
        template!.addAll(data.attributes!.tEMPLATES!);
      }

      if (data.attributes!.color != null) {
        print("|||||||||||||Colors Lenght||||||||||||||");
        print(data.attributes!.color!.length);
        colors = data.attributes!.color!;
        // print(colors!);
        for (var i = 0; i < colors!.length; i++) {
          colordrop.add(colors![i].name!);
          // colordrop.join('""');
        }

        loading = false;
      }
      setState(() {});
      // attribute.forEach((e) {
      //   toDatabase.add(e.name + "/" + e.value);
      // });
      // attributeValueToTheDatabase = toDatabase.join(',');
    } else {
      print('aaaaaaaaaaaaaaaaaaa');
    }
  }

  getDrop() {}

  int selectedColorIndex = 0;
  int selectedSizeIndex = 0;
  int selectedTypeIndex = 0;
  int selectedFlavour2Index = 0;
  int selectedFlavrIndex = 0;
  int selectedDesignIndex = 0;
  int selectedIndexScent = 0;
  int selectedpackageQuantityIndex = 0;
  int selectedproductPageIndex = 0;
  int selectedMgIndex = 0;
  int selectedPoweIndex = 0;
  int selectedPower2Index = 0;
  int selectedVolumeIndex = 0;
  int selectedModelIndex = 0;

  int getselectedIndex(String type) {
    if (type == "color") {
      return selectedColorIndex;
    }
    if (type == "package quantity") {
      return selectedpackageQuantityIndex;
    }

    if (type == "size") {
      return selectedSizeIndex;
    }
    if (type == "flavour2") {
      return selectedFlavour2Index;
    }

    if (type == "type") {
      return selectedTypeIndex;
    }
    if (type == "flvr") {
      return selectedFlavrIndex;
    }
    if (type == "design") {
      return selectedDesignIndex;
    }
    if (type == "scent") {
      return selectedIndexScent;
    }

    if (type == "productPage") {
      return selectedproductPageIndex;
    }
    if (type == "mG") {
      return selectedMgIndex;
    }
    if (type == "powe") {
      return selectedPoweIndex;
    }
    if (type == 'power') {
      return selectedPower2Index;
    }
    if (type == 'model') {
      return selectedModelIndex;
    }
    if (type == 'volume') {
      return selectedVolumeIndex;
    }

    return 0;
  }

  int? selectedAttributeColorId;

  int? selectedAttributePowerId;

  int? selectedAttributeSizeId;

  int? selectedAttributeDesignId;

  int? selectedAttributePoweId;

  int? selectedAttributeModelId;
  int? selectedVolumeId;

  int? selectedAttributePackageQuantityId;

  int? selectedAttribueProductPageId;
  int? selectedDesignIndexId;
  int? selectedFlavr1Id;
  int? selectedFlavour2Id;
  int? selectedTypeId;
  int? selectedScentId;
  int? selectedl85Id;
  int? selectedMgId;
  int? selectedTemplateId;

  int? attributeId() {
    if (selectedAttributePoweId != null) {
      return selectedAttributePoweId;
    }
    if (selectedTemplateId != null) {
      return selectedTemplateId;
    }
    if (selectedAttributeSizeId != null) {
      return selectedAttributeSizeId;
    }

    if (selectedAttributeModelId != null) {
      return selectedAttributeModelId;
    }
    if (selectedVolumeId != null) {
      return selectedVolumeId;
    }
    if (selectedMgId != null) {
      return selectedMgId;
    }
    if (selectedl85Id != null) {
      return selectedl85Id;
    }
    if (selectedScentId != null) {
      return selectedScentId;
    }

    if (selectedTypeId != null) {
      return selectedTypeId;
    }

    if (selectedFlavour2Id != null) {
      return selectedFlavour2Id;
    }
    if (selectedDesignIndexId != null) {
      return selectedDesignIndexId;
    }
    if (selectedFlavr1Id != null) {
      return selectedFlavr1Id;
    }
    if (selectedAttributePackageQuantityId != null) {
      return selectedAttributePackageQuantityId;
    }

    if (selectedAttributeColorId != null) {
      return selectedAttributeColorId;
    }
    if (selectedAttributePowerId != null) {
      return selectedAttributePowerId;
    }
    if (selectedAttribueProductPageId != null) {
      return selectedAttribueProductPageId;
    }
    return null;
  }

  // VariantList(List Vlist, String type, String textName) {
  //   return Container(
  //     height: 100,
  //     child: Column(
  //       children: [
  //         Row(
  //           children: [
  //             Text(
  //               textName,
  //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  //             ),
  //           ],
  //         ),
  //         SizedBox(
  //           height: 5,
  //         ),
  //         Expanded(
  //           child: ListView.builder(
  //               itemCount: Vlist.length,
  //               scrollDirection: Axis.horizontal,
  //               itemBuilder: (context, index) {
  //                 String values = Vlist[index].name.toString();
  //                 print(values);
  //                 return Padding(
  //                   padding: const EdgeInsets.all(5.0),
  //                   child: InkWell(
  //                     onTap: () {
  //                       if (type == 'size') {
  //                         setState(() {
  //                           selectedSize = Vlist[index].name +
  //                               "/" +
  //                               Vlist[index].attValueId.toString();
  //                           selectedSizeIndex = index;
  //                         });
  //                       }
  //                       if (type == "design") {
  //                         setState(() {
  //                           selectedDesign = Vlist[index].name +
  //                               "/" +
  //                               Vlist[index].attValueId.toString();
  //                           selectedDesignIndex = index;
  //                         });
  //                       }

  //                       if (type == "color") {
  //                         setState(() {
  //                           selectedColor = Vlist[index].name +
  //                               "/" +
  //                               Vlist[index].attValueId.toString();
  //                           selectedColorIndex = index;
  //                           selectedAttributeColorId = Vlist[index].attValueId;
  //                           // checkProductAddedorNot(Vlist[index].attValueId);
  //                           getImage(Vlist[index].attValueId);
  //                         });
  //                         print(Vlist[index].name +
  //                             "/" +
  //                             Vlist[index].attValueId.toString());
  //                         var v = Vlist[index].name +
  //                             "/" +
  //                             Vlist[index].attValueId.toString();
  //                         final sp = v.split('/');
  //                         print(sp[1]);
  //                         print('lllllllllllllllllllllllllll');
  //                         getImage(Vlist[index].attValueId);
  //                       }

  //                       if (type == "type") {
  //                         setState(() {
  //                           selectedType = Vlist[index].name +
  //                               "/" +
  //                               Vlist[index].attValueId.toString();
  //                           selectedTypeIndex = index;
  //                           // checkProductAddedorNot(Vlist[index].attValueId);
  //                           getImage(Vlist[index].attValueId);
  //                         });
  //                       }
  //                       if (type == "flavour2") {
  //                         setState(() {
  //                           selectedFlavour = Vlist[index].name +
  //                               "/" +
  //                               Vlist[index].attValueId.toString();
  //                           selectedFlavour2Index = index;
  //                           // checkProductAddedorNot(Vlist[index].attValueId);
  //                           getImage(Vlist[index].attValueId);
  //                         });
  //                       }
  //                       if (type == "flvor") {
  //                         setState(() {
  //                           selectedFlvor = Vlist[index].name +
  //                               "/" +
  //                               Vlist[index].attValueId.toString();
  //                           selectedFlavrIndex = index;
  //                           //  checkProductAddedorNot(Vlist[index].attValueId);
  //                           getImage(Vlist[index].attValueId);
  //                         });
  //                       }

  //                       if (type == "scent") {
  //                         setState(() {
  //                           selectedScent = Vlist[index].name +
  //                               "/" +
  //                               Vlist[index].attValueId.toString();
  //                           selectedIndexScent = index;
  //                           //  checkProductAddedorNot(Vlist[index].attValueId);
  //                           getImage(Vlist[index].attValueId);
  //                         });
  //                       }

  //                       if (type == "packageQuantity") {
  //                         setState(() {
  //                           selectedpackageQuantity = Vlist[index].name +
  //                               "/" +
  //                               Vlist[index].attValueId.toString();
  //                           selectedpackageQuantityIndex = index;
  //                           //  checkProductAddedorNot(Vlist[index].attValueId);
  //                           getImage(Vlist[index].attValueId);
  //                         });
  //                       }

  //                       if (type == "selectedProductPage") {
  //                         setState(() {
  //                           selectedproductPage = Vlist[index].name +
  //                               "/" +
  //                               Vlist[index].attValueId.toString();
  //                           selectedproductPageIndex = index;
  //                           // checkProductAddedorNot(Vlist[index].attValueId);
  //                           getImage(Vlist[index].attValueId);
  //                         });
  //                       }

  //                       if (type == "mG") {
  //                         setState(() {
  //                           selectedmG = Vlist[index].name +
  //                               "/" +
  //                               Vlist[index].attValueId.toString();
  //                           selectedMgIndex = index;
  //                           //  checkProductAddedorNot(Vlist[index].attValueId);
  //                           getImage(Vlist[index].attValueId);
  //                         });
  //                       }
  //                       if (type == "powe") {
  //                         setState(() {
  //                           selectedmG = Vlist[index].name +
  //                               "/" +
  //                               Vlist[index].attValueId.toString();
  //                           selectedPoweIndex = index;
  //                           getImage(Vlist[index].attValueId);
  //                           //  checkProductAddedorNot(Vlist[index].attValueId);
  //                         });
  //                       }
  //                       if (type == "power") {
  //                         setState(() {
  //                           selectedPower = Vlist[index].name +
  //                               "/" +
  //                               Vlist[index].attValueId.toString();
  //                           selectedPower2Index = index;
  //                           selectedAttributePowerId = Vlist[index].attValueId;
  //                           getImage(Vlist[index].attValueId);
  //                           // checkProductAddedorNot(Vlist[index].attValueId);
  //                           getImage(Vlist[index].attValueId);
  //                         });
  //                       }
  //                     },
  //                     child: Container(
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(7),
  //                         color: getselectedIndex(type) == index
  //                             ? primaryColor
  //                             : Colors.grey,
  //                       ),
  //                       width: 90,
  //                       height: 10,
  //                       child: Center(
  //                         child: Text(
  //                           values,
  //                           textAlign: TextAlign.center,
  //                           style: TextStyle(color: white),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 );
  //               }),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  getBuyOne() async {
    List<Cart> list = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> order_list = [];
    final sale_id = prefs.getInt('sale_id') ?? "";

    final token = prefs.getString('token') ?? "";
    Map<String, dynamic> data = {
      "token": token,
      "product_id": widget.beauty.id,
      "qty": 1,
      "att_value_id": [
        if (selectedColor.isNotEmpty) selectedColor,
        if (selectedPower.isNotEmpty) selectedPower,
        if (selectedSize.isNotEmpty) selectedSize
      ],
      "sale_id": sale_id,
      "increment": true
    };
    // var formData = FormData.fromMap(data);
    Dio dio = Dio();

    final response = await dio.post(base_url + 'api/add/cart', data: data);

    if (response.statusCode == 200) {
      print(response.data);

      Map<String, dynamic> map = Map<String, dynamic>.from(response.data);
      setState(() {
        if (map['result']['sale_id'] != null) {
          prefs.setInt('sale_id', map['result']['sale_id']);
        }
      });
    }
  }

  getImage(int attID) async {
    Map<String, dynamic> data = {
      "template_id": widget.beauty.id,
      "att_value_id": [attID]
    };
    // var formData = FormData.fromMap(data);
    Dio dio = Dio();

    final response =
        await dio.post(base_url + 'api/get/product/image', data: data);

    if (response.statusCode == 200) {
      print(response.data);

      Map<String, dynamic> map = Map<String, dynamic>.from(response.data);
      setState(() {
        if (map['result']['image'] != null) {
          newImage = map['result']['image'];
        }
      });
    }
  }

  String colorname = "";
  String powername = "";
  String sizename = "";
  String modelname = "";
  String volumename = "";
  getDropList(List lists, String type, String name) {
    print('qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq');
    return DropdownButtonFormField(
        onChanged: (value) {
          // print(value);
          setState(() {
            print(selectedColor);
            // final sp = selectedColor.split('/');

            // print(sp[1]);
          });
        },
        hint: Text(name),
        items: lists.map((e) {
          return DropdownMenuItem(
              onTap: () async {
                if (type == "power") {
                  getImage(e.attValueId!);
                  //checkProductAddedorNot();
                  selectedPower = e.attValueId!.toString();
                  selectedAttributePowerId = e.attValueId!;
                  checkProductAddedorNot(e.attValueId!);
                  powername = e.name;
                }
                if (type == "color") {
                  getImage(e.attValueId!);
                  checkProductAddedorNot(e.attValueId!);
                  selectedColor = e.attValueId!.toString();
                  selectedAttributeColorId = e.attValueId!;
                  checkProductAddedorNot(e.attValueId!);
                  colorname = e.name;
                }
                if (type == "size") {
                  getImage(e.attValueId!);
                  checkProductAddedorNot(e.attValueId!);
                  selectedSize = e.attValueId!.toString();
                  selectedAttributeSizeId = e.attValueId!;
                  checkProductAddedorNot(e.attValueId!);
                  sizename = e.name;
                }
                if (type == "design") {
                  setState(() {
                    selectedDesign = e.attValueId!.toString();
                    selectedDesignIndexId = e.attValueId!;
                    getImage(e.attValueId!);
                    checkProductAddedorNot(e.attValueId!);
                  });
                }

                if (type == "type") {
                  setState(() {
                    selectedType = e.attValueId!.toString();
                    selectedTypeId = e.attValueId!;
                    checkProductAddedorNot(e.attValueId!);
                    getImage(e.attValueId!);
                  });
                }
                if (type == "flavour2") {
                  setState(() {
                    selectedFlavour = e.attValueId!.toString();
                    selectedFlavour2Id = e.attValueId!;
                    checkProductAddedorNot(e.attValueId!);
                    getImage(e.attValueId!);
                  });
                }
                if (type == "flvor") {
                  setState(() {
                    selectedFlvor = e.attValueId!.toString();
                    selectedFlavr1Id = e.attValueId!;
                    checkProductAddedorNot(e.attValueId!);
                    getImage(e.attValueId!);
                  });
                }

                if (type == "scent") {
                  setState(() {
                    selectedScent = e.attValueId!.toString();
                    selectedScentId = e.attValueId!;
                    checkProductAddedorNot(e.attValueId!);
                    getImage(e.attValueId!);
                  });
                }

                if (type == "packageQuantity") {
                  setState(() {
                    selectedpackageQuantity = e.attValueId!.toString();
                    selectedAttributePackageQuantityId = e.attValueId!;
                    checkProductAddedorNot(e.attValueId!);
                    getImage(e.attValueId!);
                  });
                }

                if (type == "selectedProductPage") {
                  setState(() {
                    selectedproductPage = e.attValueId!.toString();
                    selectedAttribueProductPageId = e.attValueId!;
                    checkProductAddedorNot(e.attValueId!);
                    getImage(e.attValueId!);
                  });
                }

                if (type == "mG") {
                  setState(() {
                    selectedmG = e.attValueId!.toString();
                    selectedMgId = e.attValueId!;
                    checkProductAddedorNot(e.attValueId!);
                    getImage(e.attValueId!);
                  });
                }
                if (type == "powe") {
                  setState(() {
                    selectedmG = e.attValueId!.toString();
                    selectedAttributePoweId = e.attValueId!;
                    getImage(e.attValueId!);
                    checkProductAddedorNot(e.attValueId!);
                  });
                }
                if (type == "l85") {
                  setState(() {
                    selectedl85 = e.attValueId!.toString();
                    selectedl85Id = e.attValueId!;
                    getImage(e.attValueId!);
                    checkProductAddedorNot(e.attValueId!);
                  });
                }
                if (type == "volume") {
                  setState(() {
                    selectedVolume = e.attValueId!.toString();
                    selectedVolumeId = e.attValueId!;
                    getImage(e.attValueId!);
                    checkProductAddedorNot(e.attValueId!);
                    volumename = e.name;
                  });
                }
                if (type == "model") {
                  setState(() {
                    selectedModel = e.attValueId!.toString();
                    selectedAttributeModelId = e.attValueId!;
                    getImage(e.attValueId!);
                    checkProductAddedorNot(e.attValueId!);
                    modelname = e.name;
                  });
                }
                if (type == "template") {
                  setState(() {
                    selectedTemplate = e.attValueId!.toString();
                    selectedTemplateId = e.attValueId!;
                    getImage(e.attValueId!);
                    checkProductAddedorNot(e.attValueId!);
                  });
                }
              },
              child: Text(e.name!),
              value: e.name! + "/" + e.attValueId!.toString());
        }).toList());
  }
}
