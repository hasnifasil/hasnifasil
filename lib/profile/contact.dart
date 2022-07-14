import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pmc_app/API/constats/styles.dart';
import 'package:pmc_app/screens/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact extends StatefulWidget {
  const Contact({Key? key}) : super(key: key);

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
@override 
   bool languageArabic=false;
 void  initState(){
    arabicSelectedorNot();
 }


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
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Screens()));
              },
              icon: Icon(Icons.arrow_back)),
          title: Text('contact_us'.tr()),
        ),
        body: SafeArea(
          child: Center(
            child: Container(
              child: Padding(
                padding: (languageArabic)?EdgeInsets.only(right: 13.0): EdgeInsets.only(left: 13.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 13,
                    ),
                    Row(
                      children: [
                        Text(
                          'email'.tr()+" :",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(children: [
                      Icon(Icons.email),
                      TextButton(
                        onPressed: () async {
                          if (await launch('mailto:$email')) {
                          } else {
                            throw 'Could not launch $email';
                          }
                        },
                        child: Text(email,
                            style: TextStyle(
                                fontSize: 20, fontStyle: FontStyle.normal)),
                      )
                    ]),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          'phone'.tr()+" :",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.phone),
                        TextButton(
                            onPressed: () async {
                              const url = "tel:+974  44419222";
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Text(
                              phone,
                              style: TextStyle(fontSize: 20),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
