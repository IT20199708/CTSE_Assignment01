import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrgHomeScreen extends StatelessWidget {
  const OrgHomeScreen({Key? key}) : super(key: key);
Future SignOut () async{
  await FirebaseAuth.instance.signOut();
}
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Organization User")),
        body: Container(
          child: Center(child: ElevatedButton(onPressed: ()=> SignOut(),child:Text("Organization org SignOut" )),
        ),
      ),
    )
    );
  }
}
