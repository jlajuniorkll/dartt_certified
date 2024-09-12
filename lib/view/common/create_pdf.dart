import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> createPDF({required String nome, required String org}) async {
  final pdf = pw.Document();
  final img = await rootBundle.load('assets/images/$org/background.jpg');
  final imageBytes = img.buffer.asUint8List();

  pdf.addPage(
    pw.Page(
      margin: pw.EdgeInsets.zero,
      pageFormat: PdfPageFormat.a4.landscape,
      build: (pw.Context context) {
        // Obtenha a largura e altura da página A4
        final pageWidth = PdfPageFormat.a4.height;
        final pageHeight = PdfPageFormat.a4.width;

        // Carregue a imagem
        final image = pw.MemoryImage(imageBytes);

        // Calcule a proporção da imagem
        final imageAspectRatio = image.width! / image.height!;

        // Calcule as dimensões da imagem para cobrir toda a página
        double imageWidth, imageHeight;
        if (imageAspectRatio >= 1) {
          imageWidth = pageWidth;
          imageHeight = pageWidth / imageAspectRatio;
        } else {
          imageHeight = pageHeight;
          imageWidth = pageHeight * imageAspectRatio;
        }

        // Posicione a imagem no centro da página
        /*final offsetX = (pageWidth - imageWidth) / 2;
          final offsetY = (pageHeight - imageHeight) / 2;*/

        // Adicione a imagem à página
        return pw.Stack(
          fit: pw.StackFit.expand,
          children: [
            pw.Container(
              width: pageWidth,
              height: pageHeight,
              child: pw.Center(
                child: pw.Image(image,
                    width: imageWidth,
                    height: imageHeight,
                    fit: pw.BoxFit.fill),
              ),
            ),
            pw.Column(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
              pw.SizedBox(height: pageHeight * 0.40),
              pw.Text(
                nome,
                style: const pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: 24,
                ),
              ),
            ])
          ],
        );
      },
    ),
  );

  final bytes = await pdf.save();
  return bytes;
}

String validaNome({required String nome}) {
  // Remover espaços e deixar tudo em maiúsculo
  String textoSemEspacos = nome.replaceAll(' ', '').toLowerCase();
  // Remover acentos e caracteres especiais
  String textoSemAcentos = removerAcentos(textoSemEspacos);
  return textoSemAcentos;
}

String removerAcentos(String texto) {
  // Mapear caracteres especiais para sua forma normal
  Map<String, String> mapaCaracteresEspeciais = {
    'á': 'a',
    'à': 'a',
    'â': 'a',
    'ã': 'a',
    'ä': 'a',
    'Á': 'A',
    'À': 'A',
    'Â': 'A',
    'Ã': 'A',
    'Ä': 'A',
    'é': 'e',
    'è': 'e',
    'ê': 'e',
    'ë': 'e',
    'É': 'E',
    'È': 'E',
    'Ê': 'E',
    'Ë': 'E',
    'í': 'i',
    'ì': 'i',
    'î': 'i',
    'ï': 'i',
    'Í': 'I',
    'Ì': 'I',
    'Î': 'I',
    'Ï': 'I',
    'ó': 'o',
    'ò': 'o',
    'ô': 'o',
    'õ': 'o',
    'ö': 'o',
    'Ó': 'O',
    'Ò': 'O',
    'Ô': 'O',
    'Õ': 'O',
    'Ö': 'O',
    'ú': 'u',
    'ù': 'u',
    'û': 'u',
    'ü': 'u',
    'Ú': 'U',
    'Ù': 'U',
    'Û': 'U',
    'Ü': 'U',
    'ñ': 'n',
    'Ñ': 'N',
    'ç': 'c',
    'Ç': 'C',
  };

  // Iterar sobre o mapa de caracteres especiais e substituir no texto
  mapaCaracteresEspeciais.forEach((chave, valor) {
    texto = texto.replaceAll(chave, valor);
  });

  return texto;
}
