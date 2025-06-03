import 'package:flutter/material.dart';

class PDFViewerScreen extends StatelessWidget {
  final String pdfPath;
  const PDFViewerScreen({super.key, required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PDF Görüntüleyici")),
      body: Center(child: Text('PDF görüntüleyici bu platformda desteklenmiyor.')),
    );
  }
} 