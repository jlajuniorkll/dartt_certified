import 'package:csv/csv.dart';
import 'package:dartt_certified/view/common/create_pdf.dart';
import 'package:dartt_certified/view/common/pdfview.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ViewHipertensaoPortal extends StatefulWidget {
  const ViewHipertensaoPortal({super.key});

  @override
  State<ViewHipertensaoPortal> createState() => _ViewHipertensaoPortalState();
}

class _ViewHipertensaoPortalState extends State<ViewHipertensaoPortal> {
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
                image:
                    AssetImage('assets/images/hipertensaoportal/bg-home.jpg'),
                fit: BoxFit.fill)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/images/hipertensaoportal/logo.png'),
                      fit: BoxFit.contain)),
            ),
            Center(
              child: Container(
                width: larg,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
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
                            hintText: 'Nome completo ou email',
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
                                  final nameCSV = await getName(nome.text);
                                  if (nameCSV == "N") {
                                    showDialog<String>(
                                      // ignore: use_build_context_synchronously
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('Erro'),
                                        content: const Text(
                                            'Nome ou email não econtrado, verifique se não possui erro de digitação e tente novamente!'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    final filePDF = await createPDF(
                                        nome: await getName(nome.text),
                                        org: 'hipertensaoportal');
                                    Navigator.push(
                                        // ignore: use_build_context_synchronously
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PDFView(file: filePDF)));
                                  }
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

  Future<String> getName(String name) async {
    String nameCsv = "N";
    String nameText = formataNome(name);
    // Carrega o arquivo CSV da pasta de assets
    final String rawData = await rootBundle
        .loadString('assets/images/hipertensaoportal/presentes.csv');
    // Converte o conteúdo do CSV em uma lista de listas
    List<List<dynamic>> csvTable = const CsvToListConverter().convert(rawData);
    // Exibe o conteúdo do CSV
    for (var row in csvTable) {
      String nameRow = formataNome(row[1]);
      if (nameRow == nameText || (row[2] == name)) {
        nameCsv = row[1];
      }
    }
    return nameCsv;
  }

  String formataNome(String name) {
    String nameSemAcentos = removeDiacritics(name);
    String nameText = nameSemAcentos.replaceAll(' ', '').toUpperCase();
    return nameText;
  }
}
