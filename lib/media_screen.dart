import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MediaScreen extends StatefulWidget {
  @override
  _MediaScreenState createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Media")),
    /*  body: Column(
        children: [
          _image == null ? Text('No image selected') : Image.network('https://picsum.photos/250?image=9'),
          ElevatedButton(
            onPressed: getImage,
            child: Text("Pick Image"),
          ),
        ],
      ),*/
      body: Center(
        child: Column(
          children: <Widget>[

            _image == null ? Text('No image selected') : Image.network('https://picsum.photos/250?image=9'),
            ElevatedButton(
              onPressed: getImage,
              child: Text("Pick Image From network"),
            ),

            _image == null ? Text('No image selected') :  Image.asset('assets/my_icon.jpg',
              height: 200,
              width: 200,
            ),
            ElevatedButton(
              onPressed: getImage,
              child: Text("Pick Image From Assets"),
            ),// Image.asset,

          ], //<Widget>[]
        ), //Column
      ),


    );
  }
}