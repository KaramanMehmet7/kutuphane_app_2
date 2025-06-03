import 'package:flutter/material.dart';
import 'dart:html' as html;

class PDFViewerScreen extends StatelessWidget {
  final String pdfPath;
  const PDFViewerScreen({super.key, required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      html.window.open(pdfPath, '_blank');
      Navigator.of(context).pop();
    });

    return Scaffold(
      appBar: AppBar(title: Text("PDF Görüntüleyici")),
      body: const Center(child: Text('PDF yeni sekmede açılıyor...')),
    );
  }
} 