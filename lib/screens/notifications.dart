import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pmc_app/API/constats/styles.dart';
import 'package:pmc_app/API/notification_api.dart';
import 'package:pmc_app/screens/screen_profile.dart';
import 'package:pmc_app/screens/screens.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool value = false;

  @override
  void initState() {
    super.initState();
    // NotificationApi.init(initSheduled: true);
    // listenNotification();
  }

  //void  listenNotification()=>
  //NotificationApi.onNotifications.stream.listen((event) { });

  void onClicknotification(String? payload) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => Screens()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Row(
          children: [
            Transform.scale(
              scale: 1.7,
              child: Switch.adaptive(
                  value: value,
                  onChanged: (value) {
                    setState(() {
                      this.value = value;
                    });
                    // if(value==true){
                    //   NotificationApi.showSheduledNotification(title:'PMC',body:'Welcome to PMC',payload:'',shedduledDate: DateTime.now().add(Duration(seconds: 5)));
                    // }
                  }),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'notification'.tr(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
