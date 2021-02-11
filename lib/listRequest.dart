import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ListRequest extends StatefulWidget {
  @override
  _ListRequestState createState() => _ListRequestState();
}

class _ListRequestState extends State<ListRequest> {
  DatabaseReference requests =
      FirebaseDatabase.instance.reference().child("NatiRequests");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lilst of Request'),
        
      ),
      body: StreamBuilder(
        stream: requests.onValue,
        builder: (context,snapshot){
          if(snapshot.hasData){
            Map map = snapshot.data.snapshot.value;
            return ListView.builder(
              itemBuilder: (BuildContext context, int index){
                return ListTile(
                  title:Text("${map.values.toList()[index]['userName'].toString()}"),
                );

              },
              itemCount: map.values.toList().length,
            );
          }
          return SpinKitWave(color: Colors.black,);
        },
      ),
    );
  }
}
