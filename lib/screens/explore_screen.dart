import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallyapp/screens/wallpaper_view_screen.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final Firestore _db = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 18.0),
              child: Text(
                'Explore more',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            StreamBuilder(
                stream: _db
                    .collection('wallpapers')
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                          child: Hero(
                            tag: snapshot.data.documents[index].data['url'],
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: CachedNetworkImage(
                                imageUrl:
                                    snapshot.data.documents[index].data['url'],
                                placeholder: (context, url) => Image(
                                    image:
                                        AssetImage('assets/placeholder.jpg')),
                              ),
                            ),
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
        ),
      ),
    );
  }
}
