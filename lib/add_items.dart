//import 'dart:async';
//
//import 'package:flutter/material.dart';
//import 'dart:io';
//import 'package:firebase_storage/firebase_storage.dart';
////import 'package:file_picker/file_picker.dart';
//
//import 'package:flutter/services.dart';
//import 'package:http/http.dart' as http;
//import 'package:firebase_database/firebase_database.dart';
//import 'main.dart';
//import 'products.dart';
//bool check=false;
//
//
//class UploadMultipleImageDemo extends StatefulWidget {
//  UploadMultipleImageDemo() : super();
//
//  final String title = 'Firebase Storage';
//
//  @override
//  UploadMultipleImageDemoState createState() => UploadMultipleImageDemoState();
//}
//
//class Item {
//  const Item(this.cat);
//  final String cat;
//}
//
//class UploadMultipleImageDemoState extends State<UploadMultipleImageDemo> {
//  //
//  String _path;
//  Map<String, String> _paths;
//  String _extension;
//  FileType _pickType;
//  bool _multiPick = false;
//  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
//  List<StorageUploadTask> _tasks = <StorageUploadTask>[];
//  DatabaseReference productRef;
//
//  var Data;
//  var keys;
//  var selectedCat;
//
//  List<Item> catData = List<Item>();
//  var catkey = catkeys;
//  var catval = catValue;
////  get catD => catData;
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
////print(catValue[1][1]);
//    productRef = FirebaseDatabase.instance.reference().child("product");
//
//    int i = 0;
////    if(catkey != null) {
////    for (var individual in catkeys) {
////      catData.add(catValue[individual]['type']);
////
////      print(catData);
////      i++;
////    }
//    // }
////    catData[i-1]="add catagory";
//
////    print(catData);
//  }
//
//  bool _loadingPath;
//  String _fileName;
//  void openFileExplorer() async {
//    print("catdata: $catData");
//    _multiPick = true;
//    _pickType = FileType.IMAGE;
//    try {
//      _path = null;
//      if (_multiPick) {
//        _paths = await FilePicker.getMultiFilePath(
//            type: _pickType, fileExtension: _extension);
//      } else {
//        _path = await FilePicker.getFilePath(
//            type: _pickType, fileExtension: _extension);
//      }
////      uploadToFirebase();
//    } on PlatformException catch (e) {
//      print("Unsupported operation" + e.toString());
//    }
//    if (!mounted) return;
//
//    setState(() {
//      _loadingPath = false;
//      _fileName = _path != null
//          ? _path.split('/').last
//          : _paths != null ? _paths.keys.toString() : '...';
//    });
//  }
//
//  Future<void> uploadToFirebase() {
//    if (_multiPick) {
//      _paths.forEach((fileName, filePath) => {upload(fileName, filePath)});
//    } else {
//      String fileName = _path.split('/').last;
//      String filePath = _path;
//      upload(fileName, filePath);
//    }
//  }
//
//  String _imageName = DateTime.now().toString();
//
//  upload(fileName, filePath) {
//    _multiPick = true;
//    _extension = fileName.toString().split('.').last;
//    StorageReference storageRef =
//        FirebaseStorage.instance.ref().child("Image$_imageName");
//
//    final StorageUploadTask uploadTask = storageRef.putFile(
//      File(filePath),
//      StorageMetadata(
//        contentType: '$_pickType/$_extension',
//      ),
//    );
//
////   {
////      'itemName' : itemName.text.toString(),
////      'itemPrice' : int.parse(itemprice.text),
////      'catagory'  : catValue
////      'imagename' : "Image$_imageName"
////    };
////    productRef.push(
////       'productRef'=> itemName.text,
////    );
//
//    print(catValue);
//    if(check==false) {
//      productRef.push().set(<dynamic, dynamic>{
//
//        'itemName': itemName.text.toString(),
//        'itemPrice': itemprice.text,
//        'catagory': 'car',
//        'imagename': "Image$_imageName"
//      });
//      check=true;
//    }
//
//    setState(() {
//      _tasks.add(uploadTask);
//    });
//
//  }
//
//  String _bytesTransferred(StorageTaskSnapshot snapshot) {
//    return '${snapshot.bytesTransferred}/${snapshot.totalByteCount}';
//  }
//
//  @override
//  Widget build(BuildContext context) {
////    final List<Widget> children = <Widget>[];
////    _tasks.forEach((StorageUploadTask task) {
////      final Widget tile = UploadTaskListTile(
////        task: task,
////        onDismissed: () => setState(() => _tasks.remove(task)),
////        onDownload: () => downloadFile(task.lastSnapshot.ref),
////      );
////      children.add(tile);
////    });
//
//    return MaterialApp(
//      home: Scaffold(
//        key: _scaffoldKey,
//        appBar: AppBar(
//          title: Text(widget.title),
//        ),
//        body: Column(
//          children: <Widget>[
//            Column(
//              children: <Widget>[
////                new Builder(
////                    builder: (BuildContext context) => _loadingPath
////                        ? Padding(
////                            padding: const EdgeInsets.only(bottom: 10.0),
////                            child: const CircularProgressIndicator())
////                        : _path != null || _paths != null
////                            ? new Container(
////                                padding: const EdgeInsets.only(bottom: 30.0),
////                                height:
////                                    MediaQuery.of(context).size.height * 0.50,
////                                child: new Scrollbar(
////                                    child: new ListView.separated(
////                                  itemCount: _paths != null && _paths.isNotEmpty
////                                      ? _paths.length
////                                      : 1,
////                                  itemBuilder:
////                                      (BuildContext context, int index) {
////                                    final bool isMultiPath =
////                                        _paths != null && _paths.isNotEmpty;
////                                    final String name = 'File $index: ' +
////                                        (isMultiPath
////                                            ? _paths.keys.toList()[index]
////                                            : _fileName ?? '...');
////                                    final path = isMultiPath
////                                        ? _paths.values
////                                            .toList()[index]
////                                            .toString()
////                                        : _path;
////
////                                    return new ListTile(
////                                      title: new Text(
////                                        name,
////                                      ),
////                                      subtitle: new Text(path),
////                                    );
////                                  },
////                                  separatorBuilder:
////                                      (BuildContext context, int index) =>
////                                          new Divider(),
////                                )),
////                              )
////                            : new Container(
////                                padding: const EdgeInsets.only(bottom: 30.0),
////                                height:
////                                    MediaQuery.of(context).size.height * 0.50,
////                                child: new Scrollbar(
////                                  child: ListView(
////                                    children: <Widget>[],
////                                  ),
////                                ))),
//                OutlineButton(
//                  onPressed: () => openFileExplorer(),
//                  child: Text("Open file picker"),
//                ),
//                SizedBox(
//                  height: 20.0,
//                ),
//              ],
//            ),
////            ListView(
////              children: <Widget>[
//
////            DropdownButton<Item>(
////              hint: Text("Select Catagory"),
////              value: selectedCat,
////              onChanged: (Item Value) {
////                setState(() {
////                  selectedCat = Value;
////                });
////              },
////              items: catData.map((Item user) {
////                return DropdownMenuItem<Item>(
////                  value: user,
////                  child: Row(
////                    children: <Widget>[
////                      SizedBox(
////                        width: 10,
////                      ),
////                      Text(
////                        user.cat,
////                        style: TextStyle(color: Colors.black),
////                      ),
////                    ],
////                  ),
////                );
////              }).toList(),
////            ),
//
////                  DropdownButton(
////                    items: catData,
////                    onChanged: (value){
////
////
////                      if(catValue=='add catagory'){
////                        // add catagory
////                      } else{
////                        catValue = value;
////                      }
////                    },
////
////                  ),
//            TextField(
//                controller: itemName,
//                decoration: InputDecoration(
//                  labelText: "Item Name",
//                )),
//            TextField(
//              controller: itemprice,
//              decoration:
//                  InputDecoration(labelText: "Item price", hintText: "in brr"),
//            ),
//            IconButton(
//              icon: Icon(Icons.save),
//              onPressed: () async {
////                  if(_paths != null ){
//                await uploadToFirebase();
////               fetchProduct();
//                await Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ShowProduct()));
//
////                  }
//              },
//            ),
////            Flexible(
////              child: ListView(
////                children: children,
////              ),
////            )
////              ],
////            )
//          ],
//        ),
//      ),
//    );
//  }
//
//  Future<void> downloadFile(StorageReference ref) async {
//    final String url = await ref.getDownloadURL();
//    final http.Response downloadData = await http.get(url);
//    final Directory systemTempDir = Directory.systemTemp;
//    final File tempFile = File('${systemTempDir.path}/tmp.jpg');
//    if (tempFile.existsSync()) {
//      await tempFile.delete();
//    }
//    await tempFile.create();
//    final StorageFileDownloadTask task = ref.writeToFile(tempFile);
//    final int byteCount = (await task.future).totalByteCount;
//    var bodyBytes = downloadData.bodyBytes;
//    final String name = await ref.getName();
//    final String path = await ref.getPath();
//    print(
//      'Success!\nDownloaded $name \nUrl: $url'
//      '\npath: $path \nBytes Count :: $byteCount',
//    );
//    _scaffoldKey.currentState.showSnackBar(
//      SnackBar(
//        backgroundColor: Colors.white,
//        content: Image.memory(
//          bodyBytes,
//          fit: BoxFit.fill,
//        ),
//      ),
//    );
//  }
//
////  void fetchProduct() async{
////
////    await productRef.once().then((DataSnapshot snap) {
////      proKey= snap.value.keys;
////      proValue = snap.value;
////    });
////
////  }
//}
//
//TextEditingController itemName = TextEditingController();
//TextEditingController itemprice = TextEditingController();
//String itempicname;
//
////class UploadTaskListTile extends StatelessWidget {
////  UploadTaskListTile({Key key, this.task, this.onDismissed, this.onDownload})
////      : super(key: key);
////
////  final StorageUploadTask task;
////  final VoidCallback onDismissed;
////  final VoidCallback onDownload;
////
////  String get status {
////    String result;
////    if (task.isComplete) {
////      if (task.isSuccessful) {
////        result = 'Complete';
////      } else if (task.isCanceled) {
////        result = 'Canceled';
////      } else {
////        result = 'Failed ERROR: ${task.lastSnapshot.error}';
////      }
////    } else if (task.isInProgress) {
////      result = 'Uploading';
////    } else if (task.isPaused) {
////      result = 'Paused';
////    }
////    return result;
////  }
////
////  String _bytesTransferred(StorageTaskSnapshot snapshot) {
////    return '${snapshot.bytesTransferred}/${snapshot.totalByteCount}';
////  }
////
////  @override
////  Widget build(BuildContext context) {
////    return StreamBuilder<StorageTaskEvent>(
////      stream: task.events,
////      builder: (BuildContext context,
////          AsyncSnapshot<StorageTaskEvent> asyncSnapshot) {
////        Widget subtitle;
////        if (asyncSnapshot.hasData) {
////          final StorageTaskEvent event = asyncSnapshot.data;
////          final StorageTaskSnapshot snapshot = event.snapshot;
////          subtitle = Text('$status: ${_bytesTransferred(snapshot)} bytes sent');
////        } else {
////          subtitle = const Text('Starting...');
////        }
////        return Dismissible(
////          key: Key(task.hashCode.toString()),
////          onDismissed: (_) => onDismissed(),
////          child: ListTile(
////            title: Text('Upload Task #${task.hashCode}'),
////            subtitle: subtitle,
////            trailing: Row(
////              mainAxisSize: MainAxisSize.min,
////              children: <Widget>[
////                Offstage(
////                  offstage: !task.isInProgress,
////                  child: IconButton(
////                    icon: const Icon(Icons.pause),
////                    onPressed: () => task.pause(),
////                  ),
////                ),
////                Offstage(
////                  offstage: !task.isPaused,
////                  child: IconButton(
////                    icon: const Icon(Icons.file_upload),
////                    onPressed: () => task.resume(),
////                  ),
////                ),
////                Offstage(
////                  offstage: task.isComplete,
////                  child: IconButton(
////                    icon: const Icon(Icons.cancel),
////                    onPressed: () => task.cancel(),
////                  ),
////                ),
////                Offstage(
////                  offstage: !(task.isComplete && task.isSuccessful),
////                  child: IconButton(
////                    icon: const Icon(Icons.file_download),
////                    onPressed: onDownload,
////                  ),
////                ),
////              ],
////            ),
////          ),
////        );
////      },
////    );
////  }
////}
