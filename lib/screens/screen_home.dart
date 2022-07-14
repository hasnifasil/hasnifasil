import 'dart:typed_data';

import 'package:badges/badges.dart';
import 'package:dio/dio.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:pmc_app/API/constats/constant_api.dart';
import 'package:pmc_app/API/constats/styles.dart';
import 'package:pmc_app/models/banner_model.dart';
import 'package:pmc_app/models/cart_provider.dart';
import 'package:pmc_app/models/category_sub.dart';
import 'package:pmc_app/models/latest_products_model.dart';
import 'package:pmc_app/models/main_promotion.dart';
import 'package:pmc_app/models/promotion_model.dart';
import 'package:pmc_app/provider/carousal_provider.dart';
import 'package:pmc_app/provider/cart_length_provider.dart';
import 'package:pmc_app/provider/catoegory_parent_provider.dart';

import 'dart:convert';

import 'package:pmc_app/provider/featured_provider.dart';
import 'package:pmc_app/provider/selling_api_provider.dart';

import 'package:pmc_app/provider/latest_prod_provider.dart';
import 'package:pmc_app/screens/brand1.dart';
import 'package:pmc_app/screens/dashboard.dart';
import 'package:pmc_app/screens/poduct_screen_latest.dart';

import 'package:pmc_app/screens/promo_buyone.dart';
import 'package:pmc_app/screens/screen_cart.dart';
import 'package:pmc_app/screens/screen_person.dart';
import 'package:pmc_app/screens/screen_profile.dart';
import 'package:pmc_app/screens/screen_search.dart';
import 'package:pmc_app/screens/screens.dart';
import 'package:pmc_app/screens/subcat.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pmc_app/screens/view_all_latest.dart';
import 'package:pmc_app/screens/viewall_featured.dart';

import 'package:pmc_app/screens/viewall_mostselling.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenHome extends StatefulWidget {
  ScreenHome({Key? key}) : super(key: key);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  List<Banners> list = [];
  List<Promotions> plist = [];
  bool isLoading = true;
  bool isl = true;
  int activeIndex = 0;
  @override
  void initState() {
    arabicSelectedorNot();
    getLatest();
    getFeatured();
    getSelling();
    getBanners();
    getPromotions();
Provider.of<CartLengthProvider>(context, listen: false)
        .getCartLength();
    Provider.of<CategoryAPIProvider>(context, listen: false)
        .getCategData(context);
    getEmail();
    super.initState();
  }

  Uint8List? _bytesImage;

  Future getBanners() async {
    Dio dio = Dio();
    try {
      final response = await dio.get(
        base_url + 'api/read/banners',
      );
      print(response);
      if (response.statusCode == 200) {
        MainBanners dataa = MainBanners.fromJson((response.data));
        setState(() {
          list = dataa.banners;
          isl = false;
          print(dataa);
        });
      } else {
        return response.data;
      }
    } catch (e) {}
  }

  bool isLatestLoading = true;
  String? lang;
  List<Products> latestList = [];
  Future getLatest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language') != null) {
      lang = 'ar';
    } else {
      lang = 'en';
    }
    Dio dio = Dio();
    try {
      final response = await dio.get(
        base_url + 'api/read/latest/products?lang=$lang&page=1',
      );
      print(response);
      if (response.statusCode == 200) {
        print(response.data);
        ProductClass dataa = ProductClass.fromJson((response.data));
        setState(() {
          latestList = dataa.products;
          isLatestLoading = false;
          print(dataa);
        });
      } else {
        return response.data;
      }
    } catch (e) {
      print(e);
    }
  }

  bool isFeaturedLoading = true;
  List<Products> featuredList = [];
  Future getFeatured() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language') != null) {
      lang = 'ar';
    } else {
      lang = 'en';
    }
    Dio dio = Dio();
    try {
      final response = await dio.get(
        base_url + 'api/read/featured/products?lang=$lang&page=1',
      );
      print(response);
      if (response.statusCode == 200) {
        print(response.data);
        ProductClass dataa = ProductClass.fromJson((response.data));
        setState(() {
          featuredList = dataa.products;
          isFeaturedLoading = false;
          print(dataa);
        });
      } else {
        return response.data;
      }
    } catch (e) {
      print(e);
    }
  }

  bool isSellingLoading = true;
  List<Products> sellingList = [];
  Future getSelling() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language') != null) {
      lang = 'ar';
       languageArabic=true; 
    } else {
      lang = 'en';
    }
    Dio dio = Dio();
    try {
      final response = await dio.get(
        base_url + 'api/read/selling/products?lang=$lang&page=1',
      );
      print(response);
      if (response.statusCode == 200) {
        print(response.data);
        ProductClass dataa = ProductClass.fromJson((response.data));
        setState(() {
          sellingList = dataa.products;
          isSellingLoading = false;
          print(dataa);
        });
      } else {
        return response.data;
      }
    } catch (e) {
      print(e);
    }
  }

  String getType(int i) {
    if (i == 0) {
      return '2';
    } else if (i == 1) {
      return '1';
    } else if (i == 2) {
      return '1';
    }
    return '0';
  }

  Future getPromotions() async {
    Dio dio = Dio();
    try {
      final response = await dio.get(
        base_url + 'api/read/promotions',
      );

      print(response);
      if (response.statusCode == 200) {
        Mainpromotion dataa = Mainpromotion.fromJson((response.data));
        setState(() {
          plist = dataa.promotions;
          isl = false;
          print(dataa);
        });
      } else {
        return response.data;
      }
    } catch (e) {}
  }


  String? emaill;
  Future getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    if (token != null) {
      emaill = prefs.getString('email');
      print(emaill);
      print('${emaill![0]}');
    }
  }
  bool languageArabic=false;
  arabicSelectedorNot() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
//final lang=prefs.getString('language');
if(prefs.getString('language')!=null){
  setState(() {
   languageArabic=true; 
  });
  
  
}
  }


  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          //extendBody: true,
          //  drawer: ScreenProfile(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Container(
              height: 50,
              width: 50,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.green[700],
                onPressed: () {
                  String url = "https://wa.me/+919745004552/?text=Hello";
                  launch(url);
                },
                child: Image.asset(
                  "assets/images/whatssapp.png",
                  gaplessPlayback: true,
                ),
              ),
            ),
          ),
          backgroundColor: primaryColor,
          body: NestedScrollView(
              // floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverAppBar(leading:Icon(Icons.arrow_right,size:1,color:primaryColor),
                      // pinned: true,
                      floating: true,
                      iconTheme: IconThemeData(color: white),
                      title: Row(
                        children: [
                          SizedBox(
                            width:(languageArabic?4:18) ,
                          ),
                          SvgPicture.asset(
                            "assets/images/Pmc.svg",
                            height: 45,
                            width: 180,
                          ),
                        ],
                      ),
                      actions: [
                        if (emaill != null&&emaill!.isNotEmpty)
                          InkWell(onTap: (){
                             Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                               PersonScreen()));
                          },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: white),
                                color: white,
                                shape: BoxShape.circle,
                              ),
                              height: 33,
                              width: 35,
                              margin: EdgeInsets.only(right: 6),
                              child: Center(
                                child: Text(
                                  (emaill != null) ? emaill![0].toUpperCase() : '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 21,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(45),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, top: 3, bottom: 3),
                          child: Column(
                            children: [
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ScreenSearch()));
                                  },
                                  child:Stack(children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          color: white,
                                          border: Border.all(color: grey),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      height: 40,
                                      child: Center(
                                        child: InkWell(
                                          child: Row(children: [
                                            Icon(Icons.search),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'search'.tr(),
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ),
      
                                    Align(
                                      alignment:(languageArabic==true)? Alignment.centerLeft:Alignment.centerRight,
                                      child: Padding(
                                        padding:  EdgeInsets.only(
                                            right:(languageArabic==true)?280:4 ,
                                            left:(languageArabic==true)? 4.0:280,
                                            top: 4,
                                            bottom: 1),
                                        child: Container(
                                          height: 38,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: yellow,
                                          ),
                                          child: Icon(Icons.search),
                                        ),
                                      ),
                                    ) ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      elevation: 0,
                    ),
                  ],
              body: Container(
                decoration: containerBox(),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            height: 140,
                            decoration: containerBox(),
                            child: Consumer<CategoryAPIProvider>(
                                builder: (context, snapshot, _) {
                              if (snapshot.isLoading == true) {
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 6,
                                  itemBuilder: ((context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(25),
                                          child: FadeShimmer(
                                            height: 70,
                                            width: 100,
                                            radius: 4,
                                            highlightColor: Color.fromARGB(
                                                255, 190, 190, 196),
                                            baseColor: Color.fromARGB(
                                                255, 215, 227, 240),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                );
                              } else {
                                return snapshot.getCategList.length != 0
                                    ? ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (ctx, index) {
                                          String _imgString =
                                              snapshot.getCategList[index].image;
    
                                          // _bytesImage =
                                          //     Base64Decoder().convert(_imgString);
    
                                         // if (_bytesImage != null) {
                                            return InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SubCategry(
                                                                id: snapshot
                                                                    .getCategList[
                                                                        index]
                                                                    .id,
                                                                name: snapshot
                                                                    .getCategList[
                                                                        index]
                                                                    .name)));
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: Colors.white),
                                                  margin: EdgeInsets.all(6),
                                                  padding: EdgeInsets.all(2),
                                                  height: double.infinity,
                                                  width: 110,
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.only(top: 6),
                                                    decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color:
                                                                  Color.fromARGB(
                                                                      255,
                                                                      217,
                                                                      218,
                                                                      213),
                                                              spreadRadius: 3,
                                                              blurRadius: 4)
                                                        ],
                                                        border: Border.all(
                                                            color: primaryColor,
                                                            width: .1),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                25),
                                                        color: Colors.white),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Center(
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(20),
                                                            child: (snapshot.getCategList[index].image!=null&&snapshot.getCategList[index].image.isNotEmpty) ?Image.memory(
                                                          base64.decode(snapshot.getCategList[index].image)  ,
                                                              height: 70,
                                                              gaplessPlayback:
                                                                  true,
                                                            ):Container(child: Image.asset(
                  "assets/images/no_img.png",height: 70,
                  gaplessPlayback: true,
                ),),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 47,
                                                          color: Color.fromARGB(
                                                              255, 240, 236, 236),
                                                          child: Center(
                                                            child: Text(
                                                              snapshot
                                                                  .getCategList[
                                                                      index]
                                                                  .name,
                                                              maxLines: 2,
                                                              textAlign: TextAlign
                                                                  .center,
                                                              style: TextStyle(
                                                                color:
                                                                    primaryColor,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                            );
                                          // }
    
                                          // return Center(
                                          //     child: CircularProgressIndicator());
                                        },
                                        separatorBuilder: (ctx, index) {
                                          return Divider(
                                            thickness: 100,
                                            color: black,
                                          );
                                        },
                                        itemCount: snapshot.getCategList.length,
                                      )
                                    : Center(
                                        child: Text('refreshing'.tr()),
                                      );
                              }
                            }),
                          ),
                        ),
                      ]),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      isl
                          ? Container(
                              height: 200,
                              child: Center(child: CircularProgressIndicator()))
                          : Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  CarouselSlider.builder(
                                      options: CarouselOptions(
                                          onPageChanged: (index, reason) {
                                            Provider.of<Carousal>(context,
                                                    listen: false)
                                                .getIndex(index);
                                          },
                                          viewportFraction: 1,
                                          height: 192,
                                          autoPlay: true,
                                         //reverse: true,
                                          enableInfiniteScroll: false,
                                          autoPlayInterval: Duration(seconds: 4)),
                                      itemCount: list.length,
                                      itemBuilder: (context, index, realindex) {
                                        final images = list[index].image;
                                        return 
                                        InkWell(
                                          onTap: () {if(list[index].id==1){

                                          }else{
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ScreenBrand1(
                                                          id: list[index].id,
                                                          name: list[index].name,
                                                        )));
                                          }},
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10)),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 2),
                                              child: Image.network(images,
                                                  gaplessPlayback: true,
                                                )),
                                        );
                                      }),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Consumer<Carousal>(
                                    builder: (context, value, child) =>
                                        AnimatedSmoothIndicator(
                                      effect: JumpingDotEffect(
                                          activeDotColor: yellow,
                                          dotHeight: 8,
                                          dotWidth: 8,
                                          dotColor: primaryColor),
                                      count: list.length,
                                      activeIndex: value.activeIndex,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      SizedBox(
                        height: 15,
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'offers'.tr(),
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 193,
                        width: double.infinity,
                        padding: EdgeInsets.only(
                          right: 3,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: CarouselSlider.builder(
                                  options: CarouselOptions(
                                      enlargeCenterPage: true,
                                      autoPlay: true,
                                      viewportFraction: 2,
                                      height: double.infinity,
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      reverse: true,
                                      enableInfiniteScroll: false,
                                      autoPlayInterval: Duration(seconds: 4)),
                                  itemCount: plist.length,
                                  itemBuilder: (context, index, realindex) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => PromoBuyOne(
                                                      type: getType(index),
                                                      id: plist[index].id,
                                                      name: plist[index].name,
                                                    )));
                                      },
                                      child: isl
                                          ? CircularProgressIndicator()
                                          : Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15)),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.network(
                                                  plist[index].image,gaplessPlayback: true,
                                                  width: double.infinity,
                                                ),
                                              ),
                                            ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                      Column(children: [
              SizedBox(height: 2,),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('latest_products'.tr(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewLatest()));
                                      },
                                      child: Row(
                                        children: [
                                          Text("view_all".tr()),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 20,
                                          )
                                        ],
                                      )),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: Container(
                            height: 220,
                            decoration: containerBox(),
                            child: isLatestLoading
                                ? fadeshimmer()
                                : ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (ctx, index) {
                                    return InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LatestProductSel(
                                                            latestp: latestList[
                                                                index])));
                                          },
                                          child: products(
                                              latestList[index].name,
                                        latestList[index].image  ,
                                              latestList[index]
                                                  .price
                                                  .toStringAsFixed(2)),
                                        );
                                   
                                    },
                                    separatorBuilder: (ctx, index) {
                                      return Divider(
                                        thickness: 100,
                                        color: black,
                                      );
                                    },
                                    itemCount: latestList.length),
                            // }
                          ),
                        ),
                      ]),
                      Divider(
                        thickness: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'most_selling'.tr(),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => ViewSelling()));
                                  },
                                  child: Row(
                                    children: [
                                      Text("view_all".tr()),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 20,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 220,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white,
                            ),
                            color: white),
                        child: isSellingLoading
                            ? fadeshimmer()
                            : ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (ctx, index) {
                                  String _imgString = sellingList[index].image;
    
                                  _bytesImage =
                                      Base64Decoder().convert(_imgString);
                                  if (_bytesImage != null) {
                                    return InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LatestProductSel(
                                                          latestp: sellingList[
                                                              index])));
                                        },
                                        child: products(
                                            sellingList[index].name,
                                           sellingList[index].image ,
                                            sellingList[index]
                                                .price
                                                .toStringAsFixed(2)));
                                  }
    
                                  return Center(
                                      child: CircularProgressIndicator());
                                },
                                separatorBuilder: (ctx, index) {
                                  return Divider(
                                    thickness: 100,
                                    color: black,
                                  );
                                },
                                itemCount: sellingList.length),
                      ),
                      Divider(
                        thickness: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'featured_product'.tr(),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewFeatured()));
                                    },
                                    child: Row(
                                      children: [
                                        Text("view_all".tr()),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 20,
                                        )
                                      ],
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(2),
                        height: 220,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            color: Colors.white),
                        child: isFeaturedLoading
                            ? fadeshimmer()
                            : ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (ctx, index) {
                                  String _imgStrin = featuredList[index].image;
    
                                  _bytesImage =
                                      Base64Decoder().convert(_imgStrin);
                                  if (_bytesImage != null) {
                                    return InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LatestProductSel(
                                                          latestp: featuredList[
                                                              index])));
                                        },
                                        child: products(
                                            featuredList[index].name,
                                           featuredList[index].image,
                                            featuredList[index]
                                                .price
                                                .toStringAsFixed(2)));
                                  }
                                  return Center(
                                      child: CircularProgressIndicator());
                                },
                                separatorBuilder: (ctx, index) {
                                  return const Divider(
                                    thickness: 5,
                                  );
                                },
                                itemCount: featuredList.length),
                      ),
                      Container(
                        width: 100,
                        child: Divider(
                          thickness: 5,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ))),
    );
  }

  buildIndicator() {
    AnimatedSmoothIndicator(
      count: 0,
      activeIndex: activeIndex,
    );
  }

  buildImage(String images, int index) => Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        color: Colors.grey,
        child: Image.asset(images, fit: BoxFit.cover),
      );
}
