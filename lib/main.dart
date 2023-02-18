import 'package:flutter/material.dart';

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
              color: Colors.black,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: ListView(
        children: <Widget>[
          _bigItem(), //Widget_bigitem detallado debajo
          /*_item('Urbano','images/urbano.jpg'),
      _item('Urbano','images/urbano.jpg'),
      _item('Urbano','images/urbano.jpg'),
      _item('Urbano','images/urbano.jpg'),
      _item('Urbano','images/urbano.jpg'),*/
        ],
      ),
    );
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
}
