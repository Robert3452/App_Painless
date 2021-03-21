import 'package:flutter/material.dart';
import 'package:painless_app/constants.dart';
import 'package:painless_app/utils/app_utils.dart';
import 'package:painless_app/size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
          ),
          child: Stack(
            children: [
              ListViewFiles(),
              SearchText(),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchText extends StatelessWidget {
  const SearchText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryLightColor,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: "Buscar",
            prefixIcon: Icon(
              Icons.search,
              color: Color.fromARGB(80, 255, 255, 255),
            ),
          ),
        ),
      ],
    );
  }
}

class ListViewFiles extends StatefulWidget {
  @override
  _ListViewFilesState createState() => _ListViewFilesState();
}

class _ListViewFilesState extends State<ListViewFiles> {
  List<Map<String, dynamic>> files;

  @override
  void initState() {
    super.initState();
    setState(() {});
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
                        return fileItem(
                            date: snapshot.data[index]["date"],
                            hour: snapshot.data[index]["time"],
                            nameFile: snapshot.data[index]["name"],
                            press: null,
                            id: index);
                      },
                    )
                  : Center(
                      child: Text(
                        'Aún no hay grabaciones',
                        style: TextStyle(
                            color: kPrimaryLightColor,
                            fontSize: getProportionateScreenWidth(20)),
                      ),
                    );
          }
        },
      ),
    );
  }

  ListTile fileItem(
      {String nameFile, String hour, String date, Function press, int id}) {
    return ListTile(
      title: Text(
        nameFile,
        style: TextStyle(color: kPrimaryLightColor),
      ),
      subtitle: Row(
        children: [
          //Hour text
          SizedBox(
            width: getProportionateScreenWidth(60),
            child: Text(
              hour,
              style: TextStyle(color: kPrimaryLightColor),
            ),
          ),
          //Date Text
          Expanded(
            child: Text(
              date,
              style: TextStyle(color: kPrimaryLightColor),
            ),
          ),
        ],
      ),
      leading: FloatingActionButton(
        heroTag: id,
        onPressed: press,
        backgroundColor: Color.fromARGB(50, 255, 255, 255),
        mini: true,
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
