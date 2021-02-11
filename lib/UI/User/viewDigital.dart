import 'dart:io';

import 'package:flutter/material.dart';

import 'package:vendor/variables/vars.dart';

import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
class ViewDigital extends StatefulWidget {

  var files;

  ViewDigital(this.files);
  @override
  _ViewDigitalState createState() => _ViewDigitalState();
}

class _ViewDigitalState extends State<ViewDigital> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
            title: Text("Downloaded Pdf Files"),
            backgroundColor: background_2),
        body: widget.files == null
            ? Center(
                child: Text('No file downloaded yet'))
            : ListView.builder(
                //if file/folder list is grabbed, then show here
                itemCount: widget.files.length ,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                    title: Text(widget.files[index].path.split('/').last),
                    leading: Icon(Icons.picture_as_pdf),
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: Colors.redAccent,
                    ),
                    onTap: () async {
//                      File file  = File(widget.files[index].path.toString());
//                      PDFDocument doc = await PDFDocument.fromFile(file);
                      await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ViewPDF(widget.files[index].path.toString());
                        //open viewPDF page on click
                      }));
                    },
                  ));
                },
              ));
  }
}

class ViewPDF extends StatelessWidget {

  final doc;

  ViewPDF(this.doc);

  @override
  Widget build(BuildContext context) {

//    return PDFViewer(document: doc);
  return PdfViewer(
filePath: doc,
  );
  }
}
