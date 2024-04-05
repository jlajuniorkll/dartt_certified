import 'dart:typed_data';
import 'package:dartt_certified/pdfview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Certificados',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nome = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double larg = MediaQuery.of(context).size.width * 0.3;
    if (MediaQuery.of(context).size.width < 800) {
      larg = MediaQuery.of(context).size.width * 0.8;
    }
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bg-home.jpg'),
                fit: BoxFit.fill)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: larg,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    child: Column(
                      children: [
                        const Text(
                          "Certificados",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: nome,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Nome completo',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'O nome é obrigatório!';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 44.0,
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: Colors.red),
                              onPressed: () async {
                                if (nome.text.isNotEmpty) {
                                  /*String nomefinal =
                                      validaNome(nome: nome.text);
                                  final Uri url = Uri.parse(
                                      'https://simposiojbrugada.com.br/certificados/$nomefinal.png');
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                } else {*/
                                  final filePDF =
                                      await createPDF(nome: nome.text);
                                  Navigator.push(
                                      // ignore: use_build_context_synchronously
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              OcurrencyView(file: filePDF)));
                                }
                              },
                              child: const Text("Gerar",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600))),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Uint8List> createPDF({required String nome}) async {
    final pdf = pw.Document();
    final img = await rootBundle.load('assets/images/background.jpg');
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
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.SizedBox(height: pageHeight * 0.42),
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
