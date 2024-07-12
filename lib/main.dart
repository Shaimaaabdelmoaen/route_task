import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:route_task/providers/product_provider.dart';
import 'package:route_task/views/product_list_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor:Colors.indigo,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo
        ),
        useMaterial3: true,

      ),
      home:  ProductListScreen()
    );
  }
}