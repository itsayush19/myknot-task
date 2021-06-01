import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyUser{
  MyUser(@required this.uid);
  final String uid;
}

abstract class AuthBase{
  Stream<MyUser> get onAuthStateChanged;
  Future<MyUser> signInWithEmail(String email,String password);
  Future<MyUser> createUserInWithEmail(String email,String password);
  Future<void> signOut();
  String getUid();
}

class Auth implements AuthBase{
  final _firebaseAuth=FirebaseAuth.instance;
  MyUser _userFromFirebase(User user){
    if(user==null){
      return null;
    }
    else{
      return MyUser(user.uid);
    }
  }
  Stream<MyUser> get onAuthStateChanged{
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }
  @override
  Future<MyUser> signInWithEmail(String email,String password) async{
    final authResult= await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<MyUser> createUserInWithEmail(String email,String password) async{
    final authResult= await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }

  String getUid(){
    User user=_firebaseAuth.currentUser;
    return user.uid;
  }

}