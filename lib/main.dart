import 'package:dartt_certified/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Certificados',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      initialRoute: PageRoutes.home,
      getPages: AppPages.pages,
    );
  }
}
