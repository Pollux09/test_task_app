import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_task_app/bloc/app_bloc.dart';
import 'package:test_task_app/firebase/firebase_util.dart';
import 'package:test_task_app/hiveStorage/basket.dart';
import 'package:test_task_app/hiveStorage/user_device.dart';
import 'package:test_task_app/screens/basket_screen.dart';
import 'package:test_task_app/screens/catalog_screen.dart';
import 'package:test_task_app/screens/category_screen.dart';
import 'package:test_task_app/screens/delivery_screen.dart';
import 'package:test_task_app/screens/dont_supported_city_screen.dart';
import 'package:test_task_app/screens/product_card_screen.dart';
import 'package:test_task_app/screens/second_start_screen.dart';
import 'package:test_task_app/screens/self_pickup_screen.dart';
import 'package:test_task_app/screens/start_screen.dart';
import 'package:test_task_app/screens/success_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserDeviceAdapter());
  Hive.registerAdapter(BasketAdapter());

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyC1p45EX3LQgkSidBTS8ifjGRhAHu5j3zs',
      appId: '1:916648406132:android:4a04aee89cca4875e53521',
      messagingSenderId: '916648406132',
      projectId: 'testapp-21e77',
    ),
  );

  await Hive.openBox("user");
  await Hive.openBox<Basket>("basket");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool wasIntrodution = AppBloc().checkWasIntrodution();
    return MaterialApp(
      theme: ThemeData(
        // fontFamily: "Manrope",
      ),
      initialRoute: wasIntrodution ? "/catalogScreen" : "/intoductionScreen",
      routes: {
        "/intoductionScreen": (context) => StartScreen(),
        "/secondIntoductionScreen": (context) => SecondStartScreen(),
        "/catalogScreen": (context) => CatalogScreen(),
        "/productScreen": (context) => ProductCardScreen(),
        "/basketScreen": (context) => BasketScreen(),
        "/categoryScreen": (context) => CategoryScreen(),
        "/deliveryScreen": (context) => DeliveryScreen(),
        '/selfPickUpScreen': (context) => SelfPickupScreen(),
        '/successScreen': (context) => SuccessScreen(),
        '/dontSupportedCity': (context) => DontSupportedCityScreen(),
      },
    );
  }
}
