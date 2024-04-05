import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class OcurrencyView extends StatelessWidget {
  const OcurrencyView({super.key, required this.file});
  final Uint8List file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF"),
        actions: [
          IconButton(
              onPressed: () {
                FileSaver.instance.saveFile(
                    name: '${DateTime.now()}.pdf',
                    bytes: file,
                    mimeType: MimeType.pdf);
              },
              icon: const Icon(Icons.save)),
        ],
      ),
      body: SfPdfViewer.memory(
        file,
        pageLayoutMode: PdfPageLayoutMode.single,
      ),
    );
  }
}
