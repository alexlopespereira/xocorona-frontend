import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xocorona/themes/theme.dart' as thema;

class FeedTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  FeedTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return cardRegistro(snapshot, context);
  }


  Widget cardRegistro(DocumentSnapshot snapshot, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                (snapshot.data["fileurl"] != null && snapshot.data["fileurl"].length > 0)
                    ? carregaFotoCapa(snapshot.data["fileurl"])
                    : Container(),
                Container(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: new BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: thema.Cores.corBarraSuperior, width: 1, style: BorderStyle.solid),
                      right: BorderSide(color: thema.Cores.corBarraSuperior, width: 1, style: BorderStyle.solid),
                      left: BorderSide(color: thema.Cores.corBarraSuperior, width: 1, style: BorderStyle.solid),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                        child: Text(snapshot.data["title"], style: thema.TextStyles.textoDestaquePequeno,),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 2, 5, 10),
                        child: Text(snapshot.data["description"].toString().replaceAll("#nl", "\n"), style: thema.TextStyles.textoNoticiaFeed, textAlign: TextAlign.justify,),
                      ),
                      /*
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 2, 5, 10),
                        child: Text(snapshot.data["datecreate"], style: thema.TextStyles.textoNoticiaFeed,),
                      ),
                      */
                    ],
                  )
                ),
                // actionRow(post),
              ],
            ),

        );
  }

  Widget carregaFotoCapa(String urlFoto) => Material(
    child: new AspectRatio(
      aspectRatio: 100 / 50,
      child: new Container(
        decoration: new BoxDecoration(
          border: Border(
            top: BorderSide(color: thema.Cores.corBarraSuperior, width: 1, style: BorderStyle.solid),
            bottom: BorderSide(color: thema.Cores.corBarraSuperior, width: 1, style: BorderStyle.solid),
              right: BorderSide(color: thema.Cores.corBarraSuperior, width: 1, style: BorderStyle.solid),
              left: BorderSide(color: thema.Cores.corBarraSuperior, width: 1, style: BorderStyle.solid),
          ),
            image: new DecorationImage(
              image: new NetworkImage(urlFoto),
            )),
      ),
    ),
  );
}
