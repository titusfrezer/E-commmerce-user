import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:vendor/variables/vars.dart';

class CategoriesList extends StatefulWidget {
  CategoriesList();

  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  DatabaseReference productRef =
      FirebaseDatabase.instance.reference().child("catagory");
  Color background_2 = Color(0XFF738989);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: productRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
            //map.forEach((dynamic,category)=>print(category["type"]));
            //print("the map is ${map.values.toList()}");
            return StaggeredGridView.countBuilder(
                crossAxisCount: 3,
                mainAxisSpacing: 25,
                crossAxisSpacing: 25,
                scrollDirection: Axis.vertical,
                itemCount: map.values.toList().length,
                padding: EdgeInsets.all(5),
                staggeredTileBuilder: (int index) => StaggeredTile.count(1, 1),
                itemBuilder: (BuildContext context, int index) {
                  return SingleCategory(
                      map.values.toList()[index]["type"].toString(),
                      map.values.toList()[index]["image"],
                      index);
                });
          }
          return SpinKitWave(
            size: 50,
            color: background_2,
            // controller: AnimationController(duration: Duration(seconds: 30), vs),
          );
        });
  }
}

class SingleCategory extends StatefulWidget {
  final String category;
  final image;
  final index;

  SingleCategory(this.category, this.image, this.index);

  @override
  _SingleCategoryState createState() => _SingleCategoryState();
}

class _SingleCategoryState extends State<SingleCategory> {
  List<String> selectedCategory = List();
  List<int> _selectedIndexList = List();
  bool _selectionMode = false;

  void _changeSelection({bool enable, int index}) {
    _selectionMode = enable;
    _selectedIndexList.add(index);
    if (index == -1) {
      _selectedIndexList.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.white24,
        child: (_selectionMode)
            ? GridTile(
                footer: GridTileBar(
                  leading: Icon(
                    _selectedIndexList.contains(widget.index)
                        ? Icons.check_circle_outline
                        : Icons.radio_button_unchecked,
                    color: _selectedIndexList.contains(widget.index)
                        ? background_2
                        : Colors.black,
                  ),
                ),
                child: GestureDetector(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        child: Image.asset(
                          widget.image,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      Container(
                        child: Text(
                          widget.category,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      if (_selectedIndexList.contains(widget.index)) {
                        _selectedIndexList.remove(widget.index);
                      } else {
                        _selectedIndexList.add(widget.index);
                      }
                      _changeSelection(enable: false, index: -1);
                      print("unclicked");
                      selectedCategory.removeAt(widget.index);

                    });
                  },
                ))
            : GridTile(
                child: GestureDetector(
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        padding: EdgeInsets.all(10),
                        // child:InkResponse(child: Image.asset('assets/images/men1.jpeg',fit: BoxFit.cover,))
                        child: FadeInImage(
                          image: NetworkImage(widget.image),
                          placeholder: AssetImage('assets/images/cart.jpg'),
                        ),
                      ),
                      Container(
                        child: Text(
                          widget.category,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _changeSelection(enable: true, index: widget.index);
                      print("clicked");
                      selectedCategory.add(widget.category.toString());
                      print(selectedCategory.toList());
                    });
                  },
                ),
              ));
  }
}
