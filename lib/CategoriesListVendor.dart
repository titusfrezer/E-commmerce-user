//import 'package:flutter/material.dart';
//
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//import 'package:vendor/variables/vars.dart';
//
//class CategoriesListVendor extends StatefulWidget {
//  @override
//  _CategoriesListVendorState createState() => _CategoriesListVendorState();
//}
//
//class _CategoriesListVendorState extends State<CategoriesListVendor> {
//  Color background_2 = Color(0XFF738989);
////  var categories = [
////    {"Categories": "Fashion", "Image": "lib/Images/UI.png"},
////    {"Categories": "Book", "Image": "lib/Images/UI_2.png"},
////    {"Categories": "Food", "Image": "lib/Images/UI.png"},
////    {"Categories": "Drinks", "Image": "lib/Images/UI_2.png"},
////    {"Categories": "Household", "Image": "lib/Images/UI.png"},
////    {"Categories": "Electronics", "Image": "lib/Images/UI_2.png"},
////    {"Categories": "Women", "Image": "lib/Images/UI.png"},
////    {"Categories": "Mother and Children", "Image": "lib/Images/UI_2.png"},
////    {"Categories": "Traditional Cloth", "Image": "lib/Images/UI.png"},
////    {"Categories": "Car", "Image": "lib/Images/UI_2.png"},
////    {"Categories": "Utilities", "Image": "lib/Images/UI.png"},
////    {"Categories": "Machinary", "Image": "lib/Images/UI_2.png"},
////    {"Categories": "Stationary", "Image": "lib/Images/UI.png"},
////    {"Categories": "Building Materials", "Image": "lib/Images/UI_2.png"},
////  ];
//  final controller = DragSelectGridViewController();
//
//  @override
//  Widget build(BuildContext context) {
//    return StaggeredGridView.countBuilder(
//      crossAxisCount: 3,
//      mainAxisSpacing: 25,
//      crossAxisSpacing: 25,
//
//
//      padding: EdgeInsets.all(5),
//     primary: false,
//
//      itemCount: categories.length,
//      itemBuilder: (BuildContext context, int index) {
//        return SingleCategory(
//            categories[index]['Categories'], categories[index]['Image'], index);
//      },
//      scrollDirection: Axis.vertical,
//      staggeredTileBuilder: (int index) => StaggeredTile.count(1, 1),
//
//
//    );
//  }
//}
//
//class SingleCategory extends StatefulWidget {
//  final category;
//  final image;
//  final index;
//
//  SingleCategory(this.category, this.image, this.index);
//
//  @override
//  _SingleCategoryState createState() => _SingleCategoryState();
//}
//
//class _SingleCategoryState extends State<SingleCategory> {
//
//  List<int> _selectedIndexList = List();
//  bool _selectionMode = false;
//
//  void _changeSelection({bool enable, int index}) {
//    _selectionMode = enable;
//    _selectedIndexList.add(index);
//    if (index == -1) {
//      _selectedIndexList.clear();
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Card(
//        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//        color: Colors.white24,
//        child: (_selectionMode)
//            ? GridTile(
//                header: GridTileBar(
//                  leading: Icon(
//                    _selectedIndexList.contains(widget.index)
//                        ? Icons.check_circle_outline
//                        : Icons.radio_button_unchecked,
//                    color: _selectedIndexList.contains(widget.index)
//                        ? background_2
//                        : Colors.black,
//                  ),
//                ),
//                child: GestureDetector(
//                  child: Column(
//                    children: <Widget>[
//                      Container(
//
//                        padding: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
//                        child: Image.asset(widget.image,fit: BoxFit.fitHeight,),
//                      ),
//                      Container(
//                        child: Text(
//                          widget.category,
//                          textAlign: TextAlign.center,
//                          overflow: TextOverflow.ellipsis,
//                          style: TextStyle(
//                            color: Colors.black,
//                            fontSize: 16,
//                          ),
//                        ),
//                      )
//                    ],
//                  ),
//                  onLongPress: () {
//                    setState(() {
//
//                    });
//                  },
//                  onTap: () {
//                    setState(() {
//                      if (_selectedIndexList.contains(widget.index)) {
//                        _selectedIndexList.remove(widget.index);
//                      } else {
//                        _selectedIndexList.add(widget.index);
//                      }
//                      _changeSelection(enable: false, index: -1);
//                      print('Category: ${widget.category}');
//                      print('Image: ${widget.image}');
//                      print('Index: ${widget.index}');
//
//                    });
//                  },
//                ))
//            : GridTile(
//                child: InkResponse(
//                  child: Column(
//                    children: <Widget>[
//                      Container(
//                        decoration: BoxDecoration(
//                            borderRadius:
//                            BorderRadius.all(Radius.circular(20))),
//                        padding: EdgeInsets.all(10),
//                        child: Image.asset(widget.image, fit: BoxFit.contain),
//                      ),
//                      Container(
//                        child: Text(
//                          widget.category,
//                          textAlign: TextAlign.center,
//                          overflow: TextOverflow.ellipsis,
//                          style: TextStyle(
//                            color: Colors.black,
//                            fontSize: 16,
//                          ),
//                        ),
//                      )
//                    ],
//                  ),
//                  onTap: () {
//                    setState(() {
//                      _changeSelection(enable: true, index: widget.index);
//                      print('Category: ${widget.category}');
//                      print('Image: ${widget.image}');
//                      print('Index: ${widget.index}');
//                    });
//                  },
//                ),
//              ));
//  }
//}
//
////class CategoriesListVendor extends StatefulWidget {
////  @override
////  _CategoriesListVendorState createState() => _CategoriesListVendorState();
////}
////
////class _CategoriesListVendorState extends State<CategoriesListVendor> {
////
////
////
////  List<String> _imageList = List();
////  List<int> _selectedIndexList = List();
////  bool _selectionMode = false;
////
////  @override
////  Widget build(BuildContext context) {
////    List<Widget> _buttons = List();
////    if (_selectionMode) {
////      _buttons.add(IconButton(
////          icon: Icon(Icons.delete),
////          onPressed: () {
////            _selectedIndexList.sort();
////            print('Delete ${_selectedIndexList.length} items! Index: ${_selectedIndexList.toString()}');
////          }));
////    }
////
////    return Scaffold(
////      body: _createBody(),
////    );
////  }
////
////  @override
////  void initState() {
////    super.initState();
////
////  }
////
////  void _changeSelection({bool enable, int index}) {
////    _selectionMode = enable;
////    _selectedIndexList.add(index);
////    if (index == -1) {
////      _selectedIndexList.clear();
////    }
////  }
////
////  Widget _createBody() {
////    return StaggeredGridView.countBuilder(
////      crossAxisCount: 2,
////      mainAxisSpacing: 4.0,
////      crossAxisSpacing: 4.0,
////      primary: false,
////      itemCount: _imageList.length,
////      itemBuilder: (BuildContext context, int index) {
////        return getGridTile(index);
////      },
////      staggeredTileBuilder: (int index) => StaggeredTile.count(1, 1),
////      padding: const EdgeInsets.all(4.0),
////    );
////  }
////
////  GridTile getGridTile(int index) {
////    if (_selectionMode) {
////      return GridTile(
////          header: GridTileBar(
////            leading: Icon(
////              _selectedIndexList.contains(index) ? Icons.check_circle_outline : Icons.radio_button_unchecked,
////              color: _selectedIndexList.contains(index) ? Colors.green : Colors.black,
////            ),
////          ),
////          child: GestureDetector(
////            child: Column(
////              children: <Widget>[
////                Container(
////
////                  decoration: BoxDecoration(
////                      borderRadius: BorderRadius.all(Radius.circular(20))),
////                  padding: EdgeInsets.all(10),
////                  child: Image.asset(categories[index]['Image'], fit: BoxFit.contain),
////                ),
////                Container(
////                  child: Text(
////                    categories[index]['Categories'],
////                    textAlign: TextAlign.center,
////                    overflow: TextOverflow.ellipsis,
////                    style: TextStyle(
////                      color: Colors.black,
////                      fontSize: 16,
////                    ),
////                  ),
////                )
////              ],
////            ),
////            onLongPress: () {
////              setState(() {
////                _changeSelection(enable: false, index: -1);
////              });
////            },
////            onTap: () {
////              setState(() {
////                if (_selectedIndexList.contains(index)) {
////                  _selectedIndexList.remove(index);
////                } else {
////                  _selectedIndexList.add(index);
////                }
////              });
////            },
////          ));
////    } else {
////      return GridTile(
////        child: InkResponse(
////          child: Image.asset(
////            _imageList[index],
////            fit: BoxFit.cover,
////          ),
////          onLongPress: () {
////            setState(() {
////              _changeSelection(enable: true, index: index);
////            });
////          },
////        ),
////      );
////    }
////  }
////}
////
////
////
////
