import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:youtube_migrator/bindings/bindings.dart';
import 'package:youtube_migrator/models/creator.dart';
import 'package:youtube_migrator/ui/home/homepage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  Hive
    ..registerAdapter(CreatorAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: GlobalBindings(),
      debugShowCheckedModeBanner: false,
      title: 'Youtube Subscription Importer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
