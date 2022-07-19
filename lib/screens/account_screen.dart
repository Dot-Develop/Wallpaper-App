import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallyapp/screens/add_wallpaper_screen.dart';
import 'package:wallyapp/screens/wallpaper_view_screen.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;
  Firestore _db = Firestore.instance;

  @override
  void initState() {
    fetchUserData();
    super.initState();
  }

  void fetchUserData() async {
    FirebaseUser u = await _auth.currentUser();
    setState(() {
      _user = u;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: _user != null
            ? Column(
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(200.0),
                    child: FadeInImage(
                      width: 200,
                      height: 200,
                      image: NetworkImage('${_user.photoUrl}'),
                      placeholder: AssetImage('assets/placeholder.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    '${_user.displayName}',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                      color: Colors.red,
                      child: Text('Logout'),
                      onPressed: () {
                        _auth.signOut();
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('My Wallpapers'),
                        IconButton(
                          icon: Icon(
                            Icons.add,
                            size: 25,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddWallpaperScreen(),
                                fullscreenDialog: true,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder(
                      stream: _db
                          .collection('wallpapers')
                          .where('uploaded_by', isEqualTo: _user.uid)
                          .orderBy('date', descending: true)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return StaggeredGridView.countBuilder(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            staggeredTileBuilder: (index) {
                              return StaggeredTile.fit(1);
                            },
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WallpaperViewScreen(
                                        data: snapshot.data.documents[index],
                                      ),
                                    ),
                                  );
                                },
                                child: Stack(
                                  children: <Widget>[
                                    Hero(
                                      tag: snapshot
                                          .data.documents[index].data['url'],
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot.data
                                              .documents[index].data['url'],
                                          placeholder: (context, url) => Image(
                                              image: AssetImage(
                                                  'assets/placeholder.jpg')),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (ctx) {
                                                return AlertDialog(
                                                  title: Text('Confirmation'),
                                                  content: Text(
                                                      'Are you sure, you want to delete this photo?'),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      onPressed: () {
                                                        Navigator.of(ctx).pop();
                                                      },
                                                      child: Text('Cancel'),
                                                    ),
                                                    FlatButton(
                                                      onPressed: () {
                                                        _db
                                                            .collection(
                                                                'wallpapers')
                                                            .document(snapshot
                                                                .data
                                                                .documents[
                                                                    index]
                                                                .documentID)
                                                            .delete();
                                                        Navigator.of(ctx).pop();
                                                      },
                                                      child: Text('Ok'),
                                                    ),
                                                  ],
                                                );
                                              });
                                        }),
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          return SpinKitChasingDots(
                            color: Colors.grey,
                            size: 50.0,
                          );
                        }
                      }),
                ],
              )
            : LinearProgressIndicator(),
      ),
    );
  }
}
