import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pmc_app/API/constats/styles.dart';
import 'package:pmc_app/API/constats/styles.dart';

import 'package:pmc_app/models/cart_model.dart';
import 'package:pmc_app/models/db_helper.dart';
import 'package:pmc_app/models/wish.model.dart';
import 'package:pmc_app/provider/selling_api_provider.dart';
import 'package:pmc_app/providers.dart';

import 'package:pmc_app/screens/screen_login.dart';
import 'package:pmc_app/screens/screen_splas.dart';
import 'package:pmc_app/screens/screens.dart';

import 'package:pmc_app/translation/codegen_loader.g.dart';

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'high_importance_channel', 'High_importance_notifications',
//     importance: Importance.high, playSound: true);

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('a bg message just showed up: ${message.messageId}');
// }

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ar', 'SA'),
      ],
      path: 'assets/translation',
      fallbackLocale: Locale('en', 'US'),
      saveLocale: true,
      assetLoader: CodegenLoader(),
      child: Phoenix(child: MyApp()),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String login = '0';
  DBHelper cartDB = DBHelper();
  DBHelpers wishDB = DBHelpers();
  @override
  void initState() {
    cartDB.db;

    getList();
    wishDB.db;
    getwishhList();
    // TODO: implement initState
    getUserLoginOrNot();

    super.initState();
  }

  getwishhList() async {
    List<Cart> l = await wishDB.getCartList();

    print(l.length);
  }

  getList() async {
    List<Cart> l = await cartDB.getCartList();

    print(l.length);
  }

  getUserLoginOrNot() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? user_login_flag = pref.getString('user_login_flag');
    if (user_login_flag != null) {
      login = user_login_flag;
    }
  }

  MaterialColor buildMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  // Color primary = Color(0xFF006FB7);
  // Color(0xFF3274a2)

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: providers,
        child: MaterialApp(
          theme: ThemeData(primarySwatch: buildMaterialColor(primaryColor)),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          home: Splash(
            login: login,
          ),
        ));
  }
}
