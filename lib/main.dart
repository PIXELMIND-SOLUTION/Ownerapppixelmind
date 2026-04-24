import 'package:flutter/material.dart';
import 'package:ownerapp_pixelmind/provider/navbar/navbar_provider.dart';
import 'package:provider/provider.dart';
import 'package:ownerapp_pixelmind/views/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BottomNavbarProvider()),
      ],
      child: MaterialApp(
        title: 'OWNERAPP PIXELMIND',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
