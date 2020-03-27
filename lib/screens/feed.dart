import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xocorona/screens/tile_feed.dart';
import 'package:xocorona/themes/theme.dart' as thema;

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {

  @override
  Size get preferredSize => Size.fromHeight(150);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
          slivers: <Widget>[
            /*
            SliverAppBar(
              pinned: false,
              expandedHeight: 80,
              automaticallyImplyLeading: false,
              backgroundColor: thema.Cores.corBarraSuperior,
              title: Container(
                padding: EdgeInsets.only(top: 20, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(child: Image.asset("assets/icons/icon_feed.png",), width: 45, ),
                    Container(child: Text("Você já \n acumulou", style: thema.TextStyles.textoDestaquePequeno,), ),
                    Container(child: Text("55", style: thema.TextStyles.textoDestaqueLogo,)),
                    Container(child: Text("fichas nesta \nsemana", style: thema.TextStyles.textoDestaquePequeno,)),
                  ],
                ),
              ),
            ),
            */
            SliverFillRemaining(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(15, 47, 15, 10),
                child: Column(
                  children: <Widget>[
                    FutureBuilder<QuerySnapshot>(
                        future: Firestore.instance
                            .collection("feed").orderBy('datecreate', descending: true)
                            .getDocuments(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            var dividedTiles = ListTile.divideTiles(
                                tiles: snapshot.data.documents.map((doc) {
                                  return FeedTile(doc);
                                }).toList(),
                                color: thema.Cores.corBarraSuperior)
                                .toList();
                            return Column(
                              children: dividedTiles,
                            );
                          }
                        }),
                  ],
                ),
              ),
            )
          ],

    );
  }
}
