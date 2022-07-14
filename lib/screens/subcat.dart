import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pmc_app/models/category_sub.dart';
import 'package:pmc_app/screens/category/sub_categer_products.dart';
import 'package:pmc_app/screens/subsubcat.dart';

import '../API/constats/styles.dart';
import '../API/sub_category_api.dart';

class SubCategry extends StatefulWidget {
  final int id;
  final String name;
  const SubCategry({Key? key, required this.id, required this.name})
      : super(key: key);

  @override
  _SubCategryState createState() => _SubCategryState();
}

class _SubCategryState extends State<SubCategry> {
  bool isLoading = true;
  List<SubCategories> subList = [];

  @override
  void initState() {
    getSubList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
        ),
        body: Container(
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 250, childAspectRatio: 3 / 3),
              itemCount: subList.length,
              itemBuilder: (context, j) {
                return isLoading
                    ? CircularProgressIndicator()
                    : InkWell(
                        onTap: () {
                          if (subList[j].subSubCategories!.length != 0) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => SubSubCategory(
                                        list: subList[j].subSubCategories,
                                        name: subList[j]
                                            .subSubCategories![j]
                                            .name
                                            .toString())));
                          }
                          if (subList[j].subSubCategories!.length == 0)
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => SubCategeryProducts(
                                        id: subList[j].id.toString(),
                                        name: subList[j].name.toString())));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 10, right: 10, bottom: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromARGB(239, 196, 194, 194),
                                      spreadRadius: 3,
                                      blurRadius: 3)
                                ],
                                borderRadius: BorderRadius.circular(19),
                                color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  (subList[j].image != null)
                                      ? Image.memory(
                                          base64Decode(
                                            subList[j].image!,
                                          ),
                                          height: 110,
                                          width: 100,
                                        )
                                      : Container(
                                          height: 110,
                                          width: 70,child: Image.asset(
                  "assets/images/no_img.png",
                  gaplessPlayback: true,
                ),
                                        ),
                                  Container(
                                    color: Color.fromARGB(255, 224, 221, 221),
                                    height: 49,
                                    width: double.infinity,
                                    child: Center(
                                      child: Text(
                                        subList[j].name!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
              }),
        ));
  }

  Future getSubList() async {
    final scatData =
        await SubCategoryAPI().getSubCatApi(id: widget.id.toString());
    if (scatData != null) {
      SCategory scat = SCategory.fromJson(scatData);

      subList.addAll(scat.subCategories!);
      isLoading = false;
      if (mounted) setState(() {});
    } else {
      isLoading = true;
      print("Something went wrong!!");
    }
  }
}
