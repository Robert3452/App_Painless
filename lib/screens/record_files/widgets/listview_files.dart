import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:painless_app/screens/record_files/widgets/tile_item.dart';
import 'package:painless_app/utils/app_utils.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ListViewFiles extends StatefulWidget {
  @override
  _ListViewFilesState createState() => _ListViewFilesState();
}

class _ListViewFilesState extends State<ListViewFiles> {
  List<Map<String, dynamic>> files;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: getProportionateScreenHeight(60)),
      child: FutureBuilder(
        future: AppUtil.getFiles("Recorder"),
        // ignore: missing_return
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text("Lo sentimos, algo ocurrió");
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              return snapshot.data.length > 0
                  ? ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return TileItem(
                          date: snapshot.data[index]["date"],
                          hour: snapshot.data[index]["time"],
                          nameFile: snapshot.data[index]["name"],
                          path: snapshot.data[index]["path"],
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'Aún no hay grabaciones',
                        style: TextStyle(
                          color: kPrimaryLightColor,
                          fontSize: getProportionateScreenWidth(20),
                        ),
                      ),
                    );
          }
        },
      ),
    );
  }
}
