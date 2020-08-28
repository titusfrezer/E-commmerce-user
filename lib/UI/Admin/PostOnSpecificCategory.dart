import 'package:flutter/material.dart';
import 'package:vendor/variables/SpecificCategoryList.dart';
import 'package:vendor/variables/vars.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class PostOnSpecificCategory extends StatefulWidget {
  final String categoryTitle;

  PostOnSpecificCategory(this.categoryTitle);

  @override
  _PostOnSpecificCategoryState createState() => _PostOnSpecificCategoryState();
}

class _PostOnSpecificCategoryState extends State<PostOnSpecificCategory> {
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';

  double imageContainerHeight = 0;

  double changeImageContainerHeight(double value) {
    setState(() {
      imageContainerHeight = value;
    });
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisSpacing: 10,
      crossAxisCount: 4,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 4,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#4E5050",
          actionBarTitle: "Shopping App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      print(resultList);
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    double textFieldWidth = MediaQuery.of(context).size.width * 0.5;
    double textWidth = MediaQuery.of(context).size.width * 0.3;
    return SafeArea(
        child: Scaffold(
            backgroundColor: background_2,
            appBar: AppBar(
              backgroundColor: Colors.white24,
              title: Text(
                widget.categoryTitle,
                style: TextStyle(
                    color: fontWhite,
                    fontSize: fontHeader,
                    fontWeight: FontWeight.w600),
              ),
              actions: <Widget>[
                Container(
                  child:   IconButton(
                    icon: Icon(Icons.list),
                    onPressed: () {},
                    color: fontWhite,
                  )
                )
              ],
            ),
            body: ListView(
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    "Product Name",
                                    style: TextStyle(
                                        color: fontWhite,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  width: textWidth,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white30,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    shape: BoxShape.rectangle,

                                    // borderRadius: BorderRadius.all(Radius.circular(50))
                                  ),
                                  width: textFieldWidth,
                                  height: 40,
                                  child: TextField(
                                    cursorColor: fontWhite,
                                    controller: null,
                                    style: TextStyle(color: fontWhite),
                                    decoration: InputDecoration(
                                        focusColor: fontWhite,
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent)),
                                        hoverColor: Colors.white10,
                                        fillColor: Colors.white,
                                        hintText: "Product Name",
                                        hintStyle: TextStyle(color: fontWhite)),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  child: Text("Product Detail",
                                      style: TextStyle(
                                          color: fontWhite,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600)),
                                  width: textWidth,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white30,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    shape: BoxShape.rectangle,

                                    // borderRadius: BorderRadius.all(Radius.circular(50))
                                  ),
                                  width: textFieldWidth,
                                  height: 40,
                                  child: TextField(
                                    cursorColor: fontWhite,
                                    controller: null,
                                    style: TextStyle(color: fontWhite),
                                    decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent)),
                                        hoverColor: Colors.white10,
                                        fillColor: Colors.white,
                                        hintText: "Product Detail",
                                        hintStyle: TextStyle(color: fontWhite)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 20),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Container(
                                      child: Text('Select Product Image',
                                          style: TextStyle(
                                              color: fontWhite,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600))),
                                  RaisedButton(
                                    child: Text("Pick images"),
                                    onPressed: loadAssets,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: imageContainerHeight,
                              child: images == null
                                  ? changeImageContainerHeight(0)
                                  : Container(
                                      height: changeImageContainerHeight(73),
                                      padding: EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                      ),
                                      child: buildGridView()),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, right: 15),
                        decoration: BoxDecoration(
                            color: fontWhite,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, bottom: 15),
                              decoration: BoxDecoration(
                                color: background_2,
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(25),
                                    bottomLeft: Radius.circular(25)),
                              ),
                              child: Text("Select additional Categories",
                                  style: TextStyle(
                                      color: fontWhite,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500)),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 50),
                              height: 250,
                              child: SpecificCategoryList(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: 25, bottom: 15, right: 140, left: 140),
                        child: FlatButton(
                          padding: EdgeInsets.only(
                            top: 5,
                            bottom: 5,
                          ),
                          color: Colors.white24,
                          onPressed: () {
                            print("Category Created");
                          },
                          shape:  RoundedRectangleBorder(
                              borderRadius:  BorderRadius.circular(30.0)),
                          child: Text("Post",
                              style: TextStyle(
                                color: fontWhite,
                                fontSize: 20,
                              )),
                        ),
                      )
                    ],
                  ),
                ),

            );
  }
}
