import 'dart:convert';
import 'dart:developer';

import 'dart:typed_data';

import 'package:badges/badges.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:pmc_app/API/constats/constant_api.dart';
import 'package:pmc_app/API/constats/styles.dart';
import 'package:pmc_app/models/add_to_cart_model.dart';
import 'package:pmc_app/models/cart_model.dart';
import 'package:pmc_app/models/cart_provider.dart';
import 'package:pmc_app/models/db_helper.dart';
import 'package:pmc_app/models/latest_products_model.dart';
import 'package:pmc_app/models/product_variant.dart';
import 'package:pmc_app/models/read_cart_data_model.dart';
import 'package:pmc_app/models/wish_provider.dart';
import 'package:pmc_app/provider/cartListing_provider.dart';
import 'package:pmc_app/provider/cart_length_provider.dart';
import 'package:pmc_app/screens/product_screen_promotion.dart';
import 'package:pmc_app/screens/screen_cart.dart';
import 'package:pmc_app/screens/wishlist.dart';
import 'package:pmc_app/models/product_variant.dart' as pvariant;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LatestProductSel extends StatefulWidget {
  Products latestp;

  LatestProductSel({Key? key, required this.latestp}) : super(key: key);

  @override
  State<LatestProductSel> createState() => _LatestProductSelState();
}

class _LatestProductSelState extends State<LatestProductSel> {
  bool isStockQuntityLoading = false;
  bool onPressed = false;
  DBHelper dbhelper = DBHelper();
  DBHelpers dbHelpers = DBHelpers();
  CartProvider? cartp;
  WishProvider? wish;
  int quantity = 1;
  bool isAddtoCartCalled = false;
  List<Cart> list = [];
  bool addedtoCart = false;
  List<pvariant.Color>? colors = [];
  List<pvariant.Design>? design = [];
  List<pvariant.Eight>? eight = [];
  String colorpass = "";
  List<pvariant.FLAVOR>? flvor = [];
  List<pvariant.Flavour>? flavour2 = [];
  List<pvariant.Mg>? mG = [];
  List<pvariant.Model>? model = [];
  List<pvariant.PackageQuantity>? packageQuantity = [];
  List<pvariant.Power>? power = [];
  List<pvariant.ProductPageType>? productPageType = [];
  List<pvariant.Scent>? scents = [];
  List<pvariant.Size>? sizes = [];
  List<pvariant.Template>? template = [];
  List<pvariant.Type>? type = [];
  List<pvariant.Volume>? volume = [];
  late bool loading;
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
  bool isShowquantity = false;
  int stock = 0;

  @override
  void initState() {
    getQuantityOneOfItem();
    getQuantityOfItem(widget.latestp.id, [
      if (selectedColor.isNotEmpty) selectedColor,
      if (selectedPower.isNotEmpty) selectedPower,
      if (selectedDesign.isNotEmpty) selectedDesign,
      if (selectedFlavour.isNotEmpty) selectedFlavour,
      if (selectedFlvor.isNotEmpty) selectedFlvor,
      if (selectedModel.isNotEmpty) selectedModel,
      if (selectedScent.isNotEmpty) selectedScent,
      if (selectedSize.isNotEmpty) selectedSize,
      if (selectedTemplate.isNotEmpty) selectedTemplate,
      if (selectedType.isNotEmpty) selectedType,
      if (selectedVolume.isNotEmpty) selectedVolume,
      if (selectedl85.isNotEmpty) selectedl85,
      if (selectedmG.isNotEmpty) selectedmG,
      if (selectedpackageQuantity.isNotEmpty) selectedpackageQuantity,
      if (selectedproductPage.isNotEmpty) selectedproductPage
    ]);

    WidgetsBinding.instance.addPostFrameCallback((t) {
      cartp = Provider.of<CartProvider>(context, listen: false);
      wish = Provider.of<WishProvider>(context, listen: false);
      Provider.of<CartLengthProvider>(context, listen: false).getCartLength();
      ;
      getVariants(widget.latestp.id);

      cartp!.getData().then((value) {
        setState(() {
          list = value;
          print(list.length);
        });
        checkProductAddedorNot(widget.latestp.id);
      });

      wish!.getData().then((value) {
        setState(() {
          list = value;
          print(list.length);
        });
        checkProductInWish();
      });
    });
    // TODO: implement initState
    print(widget.latestp.image);

    super.initState();
  }

  bool isIncrement = false;
  Uint8List? image;

  double stockQuantity = 0.0;
  getQuantityOfItem(int product_Id, att_val_id) async {
    isStockQuntityLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final sale_id = prefs.getInt('sale_id') ?? "";
    Dio dio = Dio();
    Map<String, dynamic> data = {
      "att_value_id": att_val_id,
      "product_id": product_Id,
    };
    final response =
        await dio.post(base_url + 'api/read/product/stock', data: data);

    if (response.statusCode == 200) {
      print(response.data);
      Map<dynamic, dynamic> map = Map<String, dynamic>.from(response.data);
      stockQuantity = map['result']['forecasted_qty'];
      setState(() {
        isStockQuntityLoading = true;
        stock = 1;
      });
    }
    //setState(() {});
  }

  double productQuantity = 0.0;
  getQuantityOneOfItem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final sale_id = prefs.getInt('sale_id') ?? "";
    Dio dio = Dio();

    Map<String, dynamic> data = {
      "product_id": widget.latestp.id,
      "att_value_id": [
        if (selectedColor.isNotEmpty) selectedColor,
        if (selectedPower.isNotEmpty) selectedPower,
        if (selectedDesign.isNotEmpty) selectedDesign,
        if (selectedFlavour.isNotEmpty) selectedFlavour,
        if (selectedFlvor.isNotEmpty) selectedFlvor,
        if (selectedModel.isNotEmpty) selectedModel,
        if (selectedScent.isNotEmpty) selectedScent,
        if (selectedSize.isNotEmpty) selectedSize,
        if (selectedTemplate.isNotEmpty) selectedTemplate,
        if (selectedType.isNotEmpty) selectedType,
        if (selectedVolume.isNotEmpty) selectedVolume,
        if (selectedl85.isNotEmpty) selectedl85,
        if (selectedmG.isNotEmpty) selectedmG,
        if (selectedpackageQuantity.isNotEmpty) selectedpackageQuantity,
        if (selectedproductPage.isNotEmpty) selectedproductPage
      ],
      "sale_id": sale_id
    };
    final response =
        await dio.post(base_url + 'api/read/sale/product/qty', data: data);
    print(data);
    if (response.statusCode == 200) {
      print(response.data);
      Map<dynamic, dynamic> map = Map<String, dynamic>.from(response.data);
      setState(() {
        productQuantity = map['result']['qty'];
      });

      // setState(() {

      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.latestp.name), actions: [
        Container(
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
                    badgeContent: Consumer<CartLengthProvider>(
                      builder: ((context, value, child) {
                        return Text(value.cartLength.toString(),
                            style: TextStyle(color: white));
                      }),
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
      ]),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(9),
                margin: EdgeInsets.all(9),
                child: Column(
                  children: [
                    Card(
                      shape: cardStyle(),
                      elevation: 7,
                      child: Stack(children: [
                        Container(
                            child: Center(
                          child: InteractiveViewer(
                              // clipBehavior: Clip.none,
                              //panEnabled: false,scaleEnabled:false,
                              // minScale: 0.1,
                              maxScale: 4.0,
                              boundaryMargin:
                                  const EdgeInsets.all(double.infinity),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: widget.latestp.image != null &&
                                        widget.latestp.image.isNotEmpty
                                    ? Image.memory(
                                        base64Decode(
                                          (widget.latestp.image != null &&
                                                  widget
                                                      .latestp.image.isNotEmpty)
                                              ? widget.latestp.image
                                              : newImage,
                                        ),
                                        height: 250,
                                        gaplessPlayback: true,
                                      )
                                    : Container(
                                        child: Image.asset(
                                          "assets/images/no_img.png",
                                          gaplessPlayback: true,
                                          height: 100,
                                          width: 100,
                                        ),
                                      ),
                              )),
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
                                      : Icons.favorite_border,
                                  color: (onPressed) ? red : grey,
                                ),
                              ),
                              shareIcon(widget.latestp.name)
                            ],
                          ),
                        )
                      ]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        widget.latestp.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    )),
                    Text('QAR  ' + widget.latestp.price.toStringAsFixed(2),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 2,
                    ),
                    Divider(
                      thickness: 4,
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    if (power!.isNotEmpty)
                      //VariantList(power!, 'power', 'Power'),
                      getDropList(power!, 'power', 'slect_power'.tr()),
                    if (colors!.isNotEmpty)
                      getDropList(colors!, 'color', 'select_color'.tr()),
                    if (sizes!.isNotEmpty)
                      getDropList(sizes!, 'size', 'select_size'.tr()),
                    if (flavour2!.isNotEmpty)
                      getDropList(flavour2!, 'flavour', 'select_flavour'.tr()),
                    if (powe1!.isNotEmpty)
                      getDropList(powe1!, 'powe', 'slect_power'.tr()),
                    if (packageQuantity!.isNotEmpty)
                      getDropList(packageQuantity!, 'packageQuantity',
                          'select_package_quantity'.tr()),
                    if (flvor!.isNotEmpty)
                      getDropList(flvor!, 'flvor', 'select_flavour'.tr()),
                    if (productPageType!.isNotEmpty)
                      getDropList(productPageType!, 'productPageType',
                          'select_product_page'.tr()),
                    if (design!.isNotEmpty)
                      getDropList(design!, 'design', 'select_design'.tr()),
                    if (model!.isNotEmpty)
                      getDropList(model!, 'model', 'select_model'.tr()),
                    if (scents!.isNotEmpty)
                      getDropList(scents!, 'scent', 'select_scent'.tr()),
                    if (scents!.isNotEmpty) getDropList(mG!, 'mG', 'Select mG'),
                    if (scents!.isNotEmpty)
                      getDropList(
                          template!, 'template', 'select_template'.tr()),
                    if (volume!.isNotEmpty)
                      getDropList(volume!, 'volume', 'select_volume'.tr()),
                    if (type!.isNotEmpty)
                      getDropList(type!, 'type', 'select_type'.tr()),
                    if (widget.latestp.description != null)
                      SizedBox(
                        height: 10,
                      ),
                    if (widget.latestp.description != null &&
                        widget.latestp.description!.isNotEmpty)
                      Row(
                        children: [
                          Text(
                            "details".tr(),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    Text(
                      widget.latestp.description!,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    if (productQuantity >= 1)
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
                                  getBuyOne(false, 1);
                                  getQuantityOneOfItem();
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
                                    productQuantity.toStringAsFixed(0),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )),
                            InkWell(
                              onTap: () {
                                getQuantityOneOfItem();
                                getBuyOne(true, 1);
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
                          ],
                        ),
                      ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Material(
            child: InkWell(
              onTap: () {
                if (stock == 1) {
                  print(stockQuantity);
                  print('aaaaaaaaaaaaaaaaaakkk');
                  if (stockQuantity >= 1.0) {
                    getBuyOne(true, 1);
                    Provider.of<CartLengthProvider>(context, listen: false)
                        .getCartLength();
                    print('added');
                    setState(() {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: yellow,
                          margin: EdgeInsets.all(10),
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            "product_added_to_cart".tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: black),
                          )));

                      Provider.of<CartListProvider>(context, listen: false)
                          .getCartListData();
                      setState(() {});

                      // isAddtoCartCalled = true;
                    });

                    ;
                  } else {
                    setState(() {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: yellow,
                          margin: EdgeInsets.all(12),
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            "out_of_stock".tr() + "!!!",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: black, fontSize: 18),
                          )));

                      checkProductAddedorNot(widget.latestp.id);
                      // isAddtoCartCalled = true;
                    });
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: primaryColor
                      //  color: !isAddtoCartCalled ? primaryColor : yellow,
                      ),
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'add_to_cart'.tr(),
                          style: TextStyle(
                              //  color: !isAddtoCartCalled ? white : black,
                              fontWeight: FontWeight.bold,
                              color: white,
                              fontSize: 18),
                        ),
                        SizedBox(
                          width: 9,
                        ),
                        Icon(
                          Icons.shopping_cart,
                          color: white,
                          //color: white, size: 28,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  checkProductAddedorNot(int id) async {
    print("Check 1 reached ");
    await Provider.of<CartProvider>(context, listen: false).getData();
    if (cartp != null) {
      print(" cart point reached");
      if (cartp!.list.length != 0) {
        print("cart lenght");
        for (int j = 0; j < cartp!.list.length; j++) {
          // if (cartp!.list[j].did == attributeId()) {
          if (cartp!.list[j].did == id) {
            setState(() {
              quantity = cartp!.list[j].quantity;
              isAddtoCartCalled = true;
              print("check 2 reached");
            });

            if (cartp!.list[j].did == widget.latestp.id) {
              setState(() {
                isAddtoCartCalled = true;
                print("check 3 reached");
              });
            }
          }
        }
      }
    }
  }

  checkProductInWish() {
    if (list.length != 0) {
      for (int j = 0; j < list.length; j++) {
        if (list[j].did == widget.latestp.id) {
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
          type: '0',
          color: selectedColor,
          power: selectedPower,
          attType: selectedType,
          size: selectedSize,
          flavour: selectedFlavour,
          flvr: selectedFlvor,
          model: selectedModel,
          l85: selectedl85,
          mg: selectedmG,
          did: attributeId() ?? widget.latestp.id,
          pid: widget.latestp.id,
          name: widget.latestp.name,
          image: widget.latestp.image,
          initialprice: widget.latestp.price,
          price: widget.latestp.price,
          quantity: 1));
    } else {
      wish?.removeCounter();
      dbHelpers.delete(widget.latestp.id);
    }
  }

  getLanguage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('language') != null) {
    } else {}
  }

  List<Detail> cartItemsList = [];
  getCartListItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> order_list = [];
    final sale_id = prefs.getInt('sale_id') ?? "";
    Dio dio = Dio();

    final response =
        await dio.get(base_url + 'api/read/cart/data?sale_id=$sale_id');

    if (response.statusCode == 200) {
      Map<dynamic, dynamic> map = Map<String, dynamic>.from(response.data);
      print(response.data);

      cartItemsList.clear();
      AllCartItems data = AllCartItems.fromJson(response.data);

      cartItemsList.addAll(data.details!);

      print(response.data);
    } else {
      print(response.data);
    }
  }

  bool isAttributeThere = false;
  Future getVariants(int id) async {
    String? lang;
    SharedPreferences pref = await SharedPreferences.getInstance();
    // pref.remove('sale_id');
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
      if (data.attributes!.dESIGN != null) {
        design!.addAll(data.attributes!.dESIGN!);
        isAttributeThere = true;
      }

      if (data.attributes!.size != null) {
        sizes!.addAll(data.attributes!.size!);
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

      if (data.attributes!.powe != null) {
        powe1!.addAll(data.attributes!.powe!);
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
        loading = true;
        print("|||||||||||||Colors Lenght||||||||||||||");
        print(data.attributes!.color!.length);
        colors!.addAll(data.attributes!.color!);
        loading = false;
      }
      setState(() {});
    } else {
      print('aaaaaaaaaaaaaaaaaaa');
      setState(() {
        isAttributeThere = false;
      });
    }
  }

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

  String productExistorNot = "";
  int quty = 0;
  // List<Details> cartDetail=[];
  getBuyOne(bool incrDecr, int qty) async {
    List<Cart> list = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> order_list = [];
    final sale_id = prefs.getInt('sale_id') ?? "";

    final token = prefs.getString('token') ?? "";
    Map<String, dynamic> data = {
      "token": token,
      "product_id": widget.latestp.id,
      "qty": qty,
      "att_value_id": [
        if (selectedColor.isNotEmpty) selectedColor,
        if (selectedPower.isNotEmpty) selectedPower,
        if (selectedDesign.isNotEmpty) selectedDesign,
        if (selectedFlavour.isNotEmpty) selectedFlavour,
        if (selectedFlvor.isNotEmpty) selectedFlvor,
        if (selectedModel.isNotEmpty) selectedModel,
        if (selectedScent.isNotEmpty) selectedScent,
        if (selectedSize.isNotEmpty) selectedSize,
        if (selectedTemplate.isNotEmpty) selectedTemplate,
        if (selectedType.isNotEmpty) selectedType,
        if (selectedVolume.isNotEmpty) selectedVolume,
        if (selectedl85.isNotEmpty) selectedl85,
        if (selectedmG.isNotEmpty) selectedmG,
        if (selectedpackageQuantity.isNotEmpty) selectedpackageQuantity,
        if (selectedproductPage.isNotEmpty) selectedproductPage
      ],
      "sale_id": sale_id,
      "increment": incrDecr
    };
    print(data);

    setState(() {
      isIncrement = true;
    });
    // var formData = FormData.fromMap(data);
    Dio dio = Dio();

    final response = await dio.post(base_url + 'api/add/cart', data: data);
    print(response.data);

    if (response.statusCode == 200) {
      Map<String, dynamic> map = Map<String, dynamic>.from(response.data);
      print(response.data);
      getQuantityOneOfItem();
      setState(() {
        isIncrement = false;
        if (map['result']['qty'] != null) {
          quty = map['result']['qty'];
          productExistorNot = map['result']['message'];
        }
      });
      if (map['result']['message'] == 'no product') {
        setState(() {
          isShowquantity = true;
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

      setState(() {
        if (map['result']['sale_id'] != null) {
          prefs.setInt('sale_id', map['result']['sale_id']);
        }
      });
    }
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
  //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
  //             )
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
  //                           selectedSize = Vlist[index].name;
  //                           selectedSizeIndex = index;
  //                         });
  //                       }
  //                       if (type == "design") {
  //                         setState(() {
  //                           selectedDesign = Vlist[index].name;
  //                           selectedColorIndex = index;
  //                         });
  //                       }

  //                       if (type == "color") {
  //                         checkProductAddedorNot(Vlist[index].attValueId);
  //                         setState(() {
  //                           selectedColor = Vlist[index].name +
  //                               "/" +
  //                               Vlist[index].attValueId.toString();
  //                           selectedColorIndex = index;

  //                           selectedAttributeColorId = Vlist[index].attValueId;
  //                           checkProductAddedorNot(Vlist[index].attValueId);
  //                           getImage(Vlist[index].attValueId);
  //                         });
  //                       }
  //                       if (type == "type") {
  //                         setState(() {
  //                           selectedType = Vlist[index].name +
  //                               "/" +
  //                               Vlist[index].attValueId.toString();
  //                           selectedTypeIndex = index;
  //                           checkProductAddedorNot(Vlist[index].attValueId);
  //                           getImage(Vlist[index].attValueId);
  //                         });
  //                       }
  //                       if (type == "flavour2") {
  //                         setState(() {
  //                           selectedFlavour = Vlist[index].name +
  //                               "/" +
  //                               Vlist[index].attValueId.toString();
  //                           selectedFlavour2Index = index;
  //                           checkProductAddedorNot(Vlist[index].attValueId);
  //                           getImage(Vlist[index].attValueId);
  //                         });
  //                       }
  //                       if (type == "flvor") {
  //                         setState(() {
  //                           checkProductAddedorNot(Vlist[index].attValueId);
  //                           selectedAttributeColorId = Vlist[index].id;
  //                           selectedFlvor = Vlist[index].name +
  //                               "/" +
  //                               Vlist[index].attValueId.toString();
  //                           selectedFlavrIndex = index;
  //                           checkProductAddedorNot(Vlist[index].attValueId);
  //                           getImage(Vlist[index].attValueId);
  //                         });
  //                       }

  //                       if (type == "scent") {
  //                         setState(() {
  //                           selectedScent = Vlist[index].name +
  //                               "/" +
  //                               Vlist[index].attValueId.toString();
  //                           selectedIndexScent = index;
  //                           checkProductAddedorNot(Vlist[index].attValueId);
  //                           getImage(Vlist[index].attValueId);
  //                         });
  //                       }

  //                       if (type == "packageQuantity") {
  //                         setState(() {
  //                           selectedpackageQuantity = Vlist[index].name +
  //                               "/" +
  //                               Vlist[index].attValueId.toString();
  //                           selectedpackageQuantityIndex = index;
  //                           checkProductAddedorNot(Vlist[index].attValueId);
  //                           getImage(Vlist[index].attValueId);
  //                         });
  //                       }

  //                       if (type == "selectedProductPage") {
  //                         setState(() {
  //                           selectedproductPage = Vlist[index].name +
  //                               "/" +
  //                               Vlist[index].attValueId.toString();
  //                           selectedproductPageIndex = index;
  //                           checkProductAddedorNot(Vlist[index].attValueId);
  //                           getImage(Vlist[index].attValueId);
  //                         });
  //                       }

  //                       if (type == "mG") {
  //                         setState(() {
  //                           selectedmG = Vlist[index].name +
  //                               "/" +
  //                               Vlist[index].attValueId.toString();
  //                           selectedMgIndex = index;
  //                           checkProductAddedorNot(Vlist[index].attValueId);
  //                           getImage(Vlist[index].attValueId);
  //                         });
  //                       }
  //                       if (type == "powe") {
  //                         setState(() {
  //                           selectedmG = Vlist[index].name +
  //                               "/" +
  //                               Vlist[index].attValueId.toString();
  //                           selectedPoweIndex = index;
  //                           checkProductAddedorNot(Vlist[index].attValueId);
  //                           getImage(Vlist[index].attValueId);
  //                         });
  //                       }
  //                       if (type == "power") {
  //                         setState(() {
  //                           selectedPower = Vlist[index].name +
  //                               "/" +
  //                               Vlist[index].attValueId.toString();
  //                           selectedPower2Index = index;
  //                           checkProductAddedorNot(Vlist[index].attValueId);
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
  String colorname = "";
  String powername = "";
  String sizename = "";
  String modelname = "";
  String volumename = "";

  String newImage = "";
  getImage(int attID) async {
    Map<String, dynamic> data = {
      "template_id": widget.latestp.id,
      "att_value_id": [attID]
    };

    Dio dio = Dio();

    final response =
        await dio.post(base_url + 'api/get/product/image', data: data);

    if (response.statusCode == 200) {
      print(response.data);

      Map<String, dynamic> map = Map<String, dynamic>.from(response.data);
      if (map['result']['image'] != null && map['result']['image'].isNotEmpty) {
        setState(() {
          newImage = map['result']['image'] ?? "";
        });
      }
    }
  }

  getDropList(List lists, String type, String name) {
    return DropdownButtonFormField(
        onChanged: (value) {
          setState(() {
            print(selectedColor);
            // final sp = selectedColor.split('/');

            // print(sp[1]);
          });
        },
        hint: Text(
          name,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        items: lists.map((e) {
          return DropdownMenuItem(
              onTap: () async {
                getQuantityOneOfItem();
                if (type == "power") {
                  getImage(e.attValueId!);

                  //checkProductAddedorNot();
                  selectedPower = e.attValueId!.toString();
                  selectedAttributePowerId = e.attValueId!;
                  checkProductAddedorNot(e.attValueId!);
                }
                if (type == "color") {
                  getImage(e.attValueId!);
                  checkProductAddedorNot(e.attValueId!);
                  selectedColor = e.attValueId!.toString();
                  selectedAttributeColorId = e.attValueId!;
                  print("Attribute id");
                  print(selectedAttributeColorId);
                  checkProductAddedorNot(e.attValueId!);
                  colorname = e.name;
                }
                if (type == "size") {
                  getImage(e.attValueId!);
                  checkProductAddedorNot(e.attValueId!);
                  selectedSize = e.attValueId!.toString();
                  selectedAttributeSizeId = e.attValueId!;
                  checkProductAddedorNot(e.attValueId!);
                  sizename = e.name!;
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
                  });
                }
                if (type == "model") {
                  setState(() {
                    selectedModel = e.attValueId!.toString();
                    selectedAttributeModelId = e.attValueId!;
                    getImage(e.attValueId!);
                    checkProductAddedorNot(e.attValueId!);
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

  Future getPromotion() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('token') != null) final token = pref.getString('token');

    final response =
        await http.get(Uri.parse(base_url + 'api/read/product/details)'));
    print(response);
    if (response.statusCode == 200) {
      print(response.body);
    }
  }
}
