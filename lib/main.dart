import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_migrator/bindings/bindings.dart';
import 'package:youtube_migrator/ui/home/homepage.dart';

void main() async{
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
