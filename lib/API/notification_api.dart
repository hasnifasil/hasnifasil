// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:pmc_app/screens/settings.dart';
// import 'package:rxdart/subjects.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';


// class NotificationApi{

// static final _notification=FlutterLocalNotificationsPlugin();
// static final onNotifications=BehaviorSubject<String?>();
// static Future _notificationDetails()async{
// return NotificationDetails(android: AndroidNotificationDetails('channelId', 'channelName',importance: Importance.max),
// iOS: IOSNotificationDetails());
// }
// static Future init({bool initSheduled=false})async{
// final ios=IOSInitializationSettings();
// final android=AndroidInitializationSettings('@mipmap/ic_launcher');
// final settings=InitializationSettings(android:android,iOS: ios );
//   await _notification.initialize(settings,onSelectNotification: (payload)async {
//     onNotifications.add(payload);
//   },);
//   if(initSheduled){
//   tz.initializeTimeZones();
//   final locationName=await FlutterNativeTimezone.getLocalTimezone();
//   tz.setLocalLocation(tz.getLocation(locationName));
// }
// }

//  static Future showNotification({
//   int id=0,String? title,
//   String? body,String? payload,
//  })async=>_notification.show(id, title, body,await _notificationDetails(),payload: payload);

// static Future showSheduledNotification({
//   int id=0,String? title,
//   String? body,String? payload,required DateTime shedduledDate,
//  })async=>_notification.zonedSchedule(id, title, body,_sheduleDaily(Time(6,30)),
//  await _notificationDetails(),payload: payload,androidAllowWhileIdle: true,uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//  matchDateTimeComponents: DateTimeComponents.time);

//  static tz.TZDateTime _sheduleDaily(Time time){
//    final now=tz.TZDateTime.now(tz.local);
//   final sheduleDate=tz.TZDateTime(tz.local,now.year,now.month,now.day,time.hour,time.minute,time.second);

//   return  sheduleDate.isBefore(now)?
//   sheduleDate.add(Duration(days: 1)):sheduleDate;

//  }
// }
