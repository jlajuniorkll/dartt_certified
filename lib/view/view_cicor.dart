import 'package:dartt_certified/view/common/create_pdf.dart';
import 'package:dartt_certified/view/common/pdfview.dart';
import 'package:flutter/material.dart';

class ViewCicor extends StatefulWidget {
  const ViewCicor({super.key});

  @override
  State<ViewCicor> createState() => _ViewCicorState();
}

class _ViewCicorState extends State<ViewCicor> {
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
                image: AssetImage('assets/images/cicor/bg-home.jpg'),
                fit: BoxFit.fill)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/cicor/logo.png'),
                      fit: BoxFit.contain)),
            ),
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
                                  final filePDF = await createPDF(
                                      nome: nome.text, org: 'cicor');
                                  Navigator.push(
                                      // ignore: use_build_context_synchronously
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PDFView(file: filePDF)));
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
}
