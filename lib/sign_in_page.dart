import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'auth.dart';

class SignIn extends StatelessWidget {

  SignIn({Key key,@required this.auth}) : super(key: key);

  final AuthBase auth;

  String _email;
  String _pword;

  Future<void> _signIn() async{
    try {
      await auth.signInWithEmail(_email, _pword);
      Fluttertoast.showToast(
        msg: 'Signed In',
        textColor: Colors.white,
        backgroundColor: Colors.indigo,
      );
    } on PlatformException catch (e) {
      Fluttertoast.showToast(
          msg: e.message,
        textColor: Colors.white,
        backgroundColor: Colors.indigo,
      );
    }
  }

  Future<void> _signUp() async{
    try {
      await auth.createUserInWithEmail(_email, _pword);
      Fluttertoast.showToast(
        msg: 'Signed Up',
        textColor: Colors.white,
        backgroundColor: Colors.indigo,
      );
    } on PlatformException catch (e) {
      Fluttertoast.showToast(
        msg: e.message,
        textColor: Colors.white,
        backgroundColor: Colors.indigo,
      );
    }
  }

  /*
  Future<void> _signIn(BuildContext context) async{
    try {
      final authResult=await _auth.signInWithEmailAndPassword(email: _email, password: _pword);
      print(authResult.user!.uid);
      Navigator.push(
          context,
          MaterialPageRoute(builder:(context)=>RequestPage())
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _singUp(BuildContext context) async{
    try {
      final authR=await _auth.createUserWithEmailAndPassword(email: _email, password: _pword);
      print(authR.user!.uid);
      Navigator.push(
          context,
          MaterialPageRoute(builder:(context)=>RequestPage())
      );
    } catch (e) {
      print(e.toString());
    }
  }

   */


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(context),
    );
  }
  Widget _buildContent(BuildContext context){
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Sign-In',
            style: TextStyle(color: Colors.black,fontSize: 50.0),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 8.0,
          ),
          TextField(
            keyboardType: TextInputType.emailAddress,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: 'Email',
            ),
            textInputAction: TextInputAction.next,
            onChanged: (email){
              _email=email;
            },
          ),
          SizedBox(
            height: 8.0,
          ),
          TextField(
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: 'Password',
            ),
            textInputAction: TextInputAction.next,
            onChanged: (pword){
              _pword=pword;
            },
          ),
          SizedBox(
            height: 8.0,
          ),
          SizedBox(
            height: 50.0,
            child: RaisedButton(
              onPressed:_signIn,
              child: Text('SignIn',style: TextStyle(color: Colors.white,fontSize: 25.0)),
              color: Colors.indigo,
              elevation: 5,
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          SizedBox(
            height: 50.0,
            child: RaisedButton(
              onPressed:_signUp,
              child: Text('SignUp',style: TextStyle(color: Colors.white,fontSize: 25.0)),
              color: Colors.indigo,
              elevation: 5,
            ),
          ),
        ],
      ),
    );
  }
}
