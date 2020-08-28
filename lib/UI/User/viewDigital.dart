import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:path_provider/path_provider.dart';
var files;
class ViewDigital extends StatefulWidget {
  @override
  _ViewDigitalState createState() => _ViewDigitalState();
}

class _ViewDigitalState extends State<ViewDigital> {

  getFile() async{
    var dir = await getExternalStorageDirectory();
    var testdir = await Directory('${dir.path}/Afroel');
    var fm = FileManager(root: Directory(testdir.path));
    files = await fm.filesTree(
        extensions: ["pdf"] //optional, to filter files, list only pdf files

    );
    print(files.length);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

   getFile();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:Text("Downloaded Pdf Files"),
            backgroundColor: Colors.redAccent
        ),
        body:files == null? Text("Searching Files"):
        ListView.builder(  //if file/folder list is grabbed, then show here
          itemCount: files?.length ?? 0,
          itemBuilder: (context, index) {
            return Card(
                child:ListTile(
                  title: Text(files[index].path.split('/').last),
                  leading: Icon(Icons.picture_as_pdf),
                  trailing: Icon(Icons.arrow_forward, color: Colors.redAccent,),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return ViewPDF(pathPDF:files[index].path.toString());
                      //open viewPDF page on click
                    }));
                  },
                )
            );
          },
        )
    );
  }
}
class ViewPDF extends StatelessWidget {
  String pathPDF = "";
  ViewPDF({this.pathPDF});

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold( //view PDF
        appBar: AppBar(
          title: Text("Document"),
          backgroundColor: Colors.deepOrangeAccent,
        ),
        path: pathPDF
    );
  }
}