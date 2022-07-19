import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class AddWallpaperScreen extends StatefulWidget {
  @override
  _AddWallpaperScreenState createState() => _AddWallpaperScreenState();
}

class _AddWallpaperScreenState extends State<AddWallpaperScreen> {
  File _image;
  Firestore _db = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  bool _isUploading = false;
  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Wallpaper'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () async {
                  _loadImage();
                  // print('u clicked me!');
                },
                child: _image != null
                    ? Image.file(_image)
                    : Image.asset('assets/placeholder.jpg'),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Click on image to upload wallpaper'),
              SizedBox(
                height: 40,
              ),
              if (_isUploading) ...[
                Text('Uploading wallpaper...'),
              ],
              if (_isCompleted) ...[
                Text('Upload completed.'),
              ],
              SizedBox(
                height: 40,
              ),
              RaisedButton(
                onPressed: () {
                  _uploadWallpaper();
                },
                child: Text('Upload Wallpaper'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  void _uploadWallpaper() async {
    if (_image != null) {
      String fileName = path.basename(_image.path);
      print(fileName);

      FirebaseUser user = await _auth.currentUser();
      String uid = user.uid;
      StorageUploadTask uploadTask = _storage
          .ref()
          .child('wallpapers')
          .child(uid)
          .child(fileName)
          .putFile(_image);

      uploadTask.events.listen((e) {
        if (e.type == StorageTaskEventType.progress) {
          setState(() {
            _isUploading = true;
          });
        }

        if (e.type == StorageTaskEventType.success) {
          setState(() {
            _isCompleted = true;
            _isUploading = false;
          });

          e.snapshot.ref.getDownloadURL().then((url) {
            _db.collection('wallpapers').add({
              'url': url,
              'date': DateTime.now(),
              'uploaded_by': uid,
            });

            Navigator.of(context).pop();
          });
        }
      });
    } else {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: Text('Error!'),
              content: Text('Select an image to upload...'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('Ok'),
                ),
              ],
            );
          });
    }
  }
}
