import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myknot_task/auth.dart';
import 'package:myknot_task/request_page.dart';
import 'package:myknot_task/sign_in_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key key,@required this.auth}) : super(key: key);
  final AuthBase auth;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.active){
          MyUser user=snapshot.data;
          if(user==null){
            return SignIn(auth: auth);
          }
          if(user!=null){
            return RequestPage(auth: auth);
          }
        }
        return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            )
        );
      },
    );
  }
}
