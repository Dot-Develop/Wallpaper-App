import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:share/share.dart';

class WallpaperViewScreen extends StatefulWidget {
  DocumentSnapshot data;
  WallpaperViewScreen({this.data});
  @override
  _WallpaperViewScreenState createState() => _WallpaperViewScreenState();
}

class _WallpaperViewScreenState extends State<WallpaperViewScreen> {
  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

//
//
//  Widget build (BuildContext context){
//
//  }
//

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Container(
                child: Hero(
                  tag: widget.data['url'],
                  child: CachedNetworkImage(
                    imageUrl: widget.data['url'],
                    placeholder: (context, url) =>
                        Image(image: AssetImage('assets/placeholder.jpg')),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                child: Wrap(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(55),
                      child: RaisedButton.icon(
                        onPressed: () {
                          //_launchUrl();
                        },
                        icon: Icon(Icons.file_download),
                        label: Text('Get wallpaper'),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(55),
                      child: RaisedButton.icon(
                        onPressed: () {
                          _createDynamicLink();
                        },
                        icon: Icon(Icons.share),
                        label: Text('Share'),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(55),
                      child: RaisedButton.icon(
                        onPressed: () {
                          _addToFavorites();
                        },
                        icon: Icon(Icons.favorite_border),
                        label: Text('Favorite'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
//
//  void _launchUrl() async {
//    try {
//      await launch(widget.data['url'],
//          option: CustomTabsOption(
//            toolbarColor: Colors.blue,
//          ));
//    } catch (e) {
//      print(e.message);
//    }
//  }

  void _addToFavorites() async {
    FirebaseUser user = await _auth.currentUser();

    String uid = user.uid;
    _db
        .collection('users')
        .document(uid)
        .collection('favorites')
        .document(widget.data.documentID)
        .setData(widget.data.data);
  }

  void _createDynamicLink() async {
    DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
      uriPrefix: 'https://mohammed.page.link',
      link: Uri.parse(widget.data.documentID),
      androidParameters: AndroidParameters(
        packageName: 'com.mohammed.wallyapp',
        minimumVersion: 0,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.mohammed.wallyapp',
        minimumVersion: '0',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'WallyApp',
        description: 'Wanna see gorgeous wallpapers!',
        imageUrl: Uri.parse(widget.data['url']),
      ),
    );

    Uri uri = await dynamicLinkParameters.buildUrl();
    String url = uri.toString();
    //print(url);
    Share.share(url);
  }
}
