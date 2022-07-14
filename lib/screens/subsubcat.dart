import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pmc_app/API/constats/styles.dart';
import 'package:pmc_app/models/category_sub.dart';
import 'package:pmc_app/screens/category/sub_categer_products.dart';

class SubSubCategory extends StatefulWidget {
 
  String name;
 
  List<SubSubCategories>? list;
  // final List list;
  SubSubCategory(
      {Key? key,
     
      required this.name,
     
      required this.list})
      : super(key: key);

  @override
  State<SubSubCategory> createState() => _SubSubCategoryState();
}

class _SubSubCategoryState extends State<SubSubCategory> {
  // List<SubSubCategories> list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.name)),
        body: Container(
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250, childAspectRatio: 3 / 3),
                itemCount: widget.list!.length,
                itemBuilder: (context, j) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, left: 10, right: 10, bottom: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => SubCategeryProducts(
                                    id: widget.list![j].id.toString(),
                                    name: widget.list![j].name!.toString())));
                      },
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              (widget.list![j].image != null)
                                  ? Image.memory(
                                      base64Decode(
                                        widget.list![j].image!,
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
                                    widget.list![j].name!,
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
                })));
  }
}
