import 'package:flutter/material.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:webfeed/domain/rss_item.dart';
import 'network.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Descarga de http/https",
      //theme
      home: NoticiasPage(tittle: "Últimas Noticias"),
    );
  }
}

class NoticiasPage extends StatefulWidget {
  const NoticiasPage({Key? key, required this.tittle})
      : super(key: key); //Agrego paremtro titulo
  final String tittle;
  @override
  State<NoticiasPage> createState() => _NoticiasPageState();
}

class _NoticiasPageState extends State<NoticiasPage> {
  Future<RssFeed>? future;

  @override
  void initState() {
    super.initState();
    future = getNews();
    getNews().then((rss) {
      print(rss.title);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Appbar
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        elevation: 0.0,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            widget.tittle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25.0,
            ),
          ),
        ),
        //icono de compartir
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 32.0),
            child: Icon(
              Icons.share,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: _body(), //widget de body que estara creado mas abajo
    );
  }

  Widget _body() {
    return FutureBuilder(
        future: future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            //los diferentes estados
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState
                .done: // se ejecuta de manera correcta la conexion
              if (snapshot.hasError) {
                return Text(
                    'Error: ${snapshot.error}'); //si tiene error va a renotar el error
              }
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: ListView.builder(
                itemCount: snapshot.data.items.length +
                    2, // se cuentan los elementos que vienen
                itemBuilder: (BuildContext context, int index) {
                  //se empieza a construir
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.only(top: 25.0, bottom: 16.0),
                      child: Text(snapshot.data.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                    );
                  }
                  if (index == 1) {
                    return _bigItem();
                  }

                  return _item(snapshot.data.items[index - 2]);
                }),
          );
        });
  }

  Widget _bigItem() {
    var screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        //Imagen sin play
        Container(
          width: double.infinity,
          height: (screenWidth - 64.0) * 3.0 / 5.0,
          decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage("images/prueba.jpg"),
              ),
              borderRadius: BorderRadius.circular(30.0)),
        ),
        Container(
          width: 64.0,
          height: 64.0,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: const Icon(
            Icons.play_arrow,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  Widget _item(RssItem item) {
    String? categoria = item.categories!.first.value;
    String? titulo = item.title!;
    String? creador = item.dc!.creator!;
    String? imagen = item.enclosure!.url!;
    //puede colocar de una lado la info y del otro la imagen, colocando una fila y dentro una columna. EMpieza con padding para que los elementos no estan juntos
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 9.0),
      color: Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 3,
      // child: IntrinsicHeight(
      //padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    categoria,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(titulo),
                  Text(creador),
                ],
              )),
              Container(
                //imagen
                width: 110.0,
                height: 110.0,
                child: Image(
                  image: NetworkImage(imagen),
                  fit: BoxFit.cover,
                ),
              )
            ],
          )),
    );
  }
}
