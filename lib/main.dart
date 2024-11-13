// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_chart_graph_map_project/views/show_map_ui.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp( 
    MyDiaryfood()
  );
}

class MyDiaryfood extends StatefulWidget {
  const MyDiaryfood({super.key});

  @override
  State<MyDiaryfood> createState() => _MyDiaryfoodState();
}

class _MyDiaryfoodState extends State<MyDiaryfood> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  ShowMapUI(),
      theme: ThemeData(
      textTheme: GoogleFonts.kanitTextTheme(
        Theme.of(context).textTheme
      )
        ),
      );
  }
}