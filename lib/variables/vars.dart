import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
Color background = Color(0XFFF7516C);
Color background_2 = Color(0XFF2A2629);

Color myGrey = Color(0XFFB1ABB5);
//Color background_2=Colors.brown;
Color fontWhite = Colors.white;
double appbarHeight = 230;
double appbarHeightSmaller = 75;
double carouselHeight = 275;
double fontHeader = 20;
List<String> selectedCategoryList = List();
String userName;
TextEditingController productName = TextEditingController();
TextEditingController productDetail = TextEditingController();
TextEditingController productPrice = TextEditingController();
TextEditingController productCategory = TextEditingController();
TextEditingController controller = TextEditingController();
String categoryHint = "Product Name";
String detailHint = "Product Detail";
String priceHint = "Product Price";

List<String> listurl = List();
var counter=0;
bool loading=false;
String postStatus;
String identity;
String currentText;


//DatabaseReference productRef;
