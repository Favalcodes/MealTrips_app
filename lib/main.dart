import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mealtrips/fooddel/screens/Mapping/mapping.dart';
import 'package:mealtrips/fooddel/screens/delivery/notification.dart';
import 'package:mealtrips/fooddel/screens/my_orders/my_orders.dart';
import 'package:mealtrips/fooddel/screens/notification_screen/notification_screen.dart';
import 'package:mealtrips/fooddel/screens/personal_information/personal_information.dart';
import 'package:mealtrips/fooddel/screens/vendor/notifcation.dart';
import 'package:mealtrips/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

const HomeRoute = "/";
const MyOrderRoute = "/myOrder";
const TermsRoute = "/terms";
const ProfileRoute = "/profile";
const CustomerNotificationRoute = "/customer";
const VendorNotificationRoute = "/vendor";
const DeliveryNotificationRoute = "/delivery";

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
  ));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_logo',
              ),
            ));
      }
    });
  }

  void showNotification() {
    flutterLocalNotificationsPlugin.show(
        0,
        "Testing",
        "How you doin ?",
        NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id, channel.name, channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_logo')));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);

        return MaterialApp(
          title: 'MealTrips',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: lightThemeData(context),
          darkTheme: darkThemeData(context),
          initialRoute: HomeRoute,
          routes: {
            HomeRoute: (context) => MappingScreen(),
            MyOrderRoute: (context) => MyOrders(),
            ProfileRoute: (context) => PersonalInformation(),
            TermsRoute: (context) => PersonalInformation(),
            CustomerNotificationRoute: (context) => NotificationScreen(),
            "/vendor": (context) => VendorNotification(),
            DeliveryNotificationRoute: (context) => DeliveryNotification(),
          },
        );
      },
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print("Handling a background message: ${message.notification.title}");
}
