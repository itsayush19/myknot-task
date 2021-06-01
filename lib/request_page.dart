import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myknot_task/auth.dart';
import 'package:permission_handler/permission_handler.dart';

import 'details.dart';

class RequestPage extends StatelessWidget {

  RequestPage({Key key,@required this.auth}) : super(key: key);

  final AuthBase auth;
  File _image;
  String _imageURL;

  Future<void> _signOut()async{
    try {
      await auth.signOut();
      Fluttertoast.showToast(
        msg: 'Signed Out',
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
  Future<void> uploadImage()async{
    final _firebaseStorage=FirebaseStorage.instance;
    final _imagePicker=ImagePicker();
    PickedFile image;
    await Permission.camera.request();
    var permissionStatus = await Permission.camera.status;
    if(permissionStatus.isGranted){
      image=await _imagePicker.getImage(source: ImageSource.camera);
      var file=File(image.path);
      if(image!=null){
        var snapshot=await _firebaseStorage.ref().child('images/${DateTime.now()}').putFile(file);
        var downloadUrl=await snapshot.ref.getDownloadURL();
        _imageURL=downloadUrl;
        Fluttertoast.showToast(
          msg: 'Image Uploaded',
          textColor: Colors.white,
          backgroundColor: Colors.indigo,
        );
        print(_imageURL);
      }
      else{
        print('no image path recieved');
      }
    }
    else{
      print('No permission granted');
    }
  }

  /*
  Future<void> chooseFile() async{
    PickedFile pickedFile= await ImagePicker().getImage(source: ImageSource.camera);
    if(pickedFile!=null){
      _image=File(pickedFile.path);
    }
  }

  Future<void> uploadFile() async{
    FirebaseStorage storage=FirebaseStorage.instance;
    Reference ref=storage.ref().child('images/');
    print(ref);
    UploadTask uploadTask=ref.putFile(_image);
    ref.getDownloadURL().then((value) => _imageURL=value);
    print(_imageURL);

  }

   */


  /*
  Future<void> _signOut(BuildContext context)async{
    try{
      await auth.signOut();
      Navigator.push(context, MaterialPageRoute(builder: (context)=>SignIn()));
    }catch(e){
      print(e.toString());
    }
  }
   */




  Future<void> post(BuildContext context) async {
    await uploadImage();
    Map<String, String> data = {
      "imageURL":
       _imageURL,
    };
    final response = await http.post(
        Uri.parse(
            'https://backend-test-zypher.herokuapp.com/uploadImageforMeasurement'),
        body: data);
    print(response.statusCode);
    Map<String, dynamic> d =
        new Map<String, dynamic>.from(json.decode(response.body));
    Map<String, dynamic> details = d['d'];

    List<Map<String, dynamic>> detailList = [];
    details.forEach((key, value) {
      if (key != 'measurementId') {
        Map<String, dynamic> m = {
          key: value,
        };
        detailList.add(m);
      }
    });
    print(detailList.toString());

    if (response.statusCode == 200) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Details(
                    res: detailList,
                  )));
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text('Error'),
              content: Text('Error Code :' + response.statusCode.toString()),
              actions: [
                RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Ok'),
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Make a request'),
        elevation: 50.0,
        backgroundColor: Colors.indigo,
        actions: [
          FlatButton(
              onPressed:_signOut,
              child: Text(
                'SignOut',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
              )
          )
        ],
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Center(
      child: RaisedButton(
        onPressed: () => post(context),
        child: Text(
          'Upload image',
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.indigo,
      ),
    );
  }
}
