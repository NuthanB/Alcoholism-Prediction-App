import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class ResultsScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  ResultsScreen({required this.result});

  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Status: ${result['status']}',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Parameters:',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              for (var entry in result['params'].entries)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      '${entry.key}:',
                      style: pw.TextStyle(fontSize: 16),
                    ),
                    pw.Text(
                      '${entry.value}',
                      style: pw.TextStyle(fontSize: 16),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );

    final List<int> pdfBytes = await pdf.save();

    // Save the PDF file and open the share dialog
    await FileSaveHelper.saveAndLaunchFile(pdfBytes, 'Analysis_Report.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analysis Results'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status: ${result['status']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Parameters:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...result['params'].entries.map(
              (entry) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${entry.key}:',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '${entry.value}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generatePdf,
              child: Text('Generate PDF'),
            ),
          ],
        ),
      ),
    );
  }
}

class FileSaveHelper {
  static Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    OpenFile.open(file.path);
  }
}
