import 'package:flutter/material.dart';
import 'package:kutuphane_app/custom_app_bar.dart';
import 'package:kutuphane_app/drawer.dart';

class BasePage extends StatelessWidget {
  final String title;
  final Widget content;

  const BasePage({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: title,
        centerTitle: true,
      ),
      drawer: const DrawerMenu(),
      body: content,
    );
  }
} 