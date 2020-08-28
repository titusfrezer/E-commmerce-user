import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SearchService {
  searchByName(String searchField) {
    print("searchField${searchField}");
    return FirebaseDatabase.instance
        .reference()
        .child('product')
        .orderByChild('firstLetter')
        .equalTo(searchField.substring(0, 1));
  }
}
