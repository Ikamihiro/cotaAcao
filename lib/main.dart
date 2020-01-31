import 'package:flutter/material.dart';
import './home.dart';

void main() => runApp(new Aplicativo());

class Aplicativo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cota Ação',
      home: new PaginaInicial(),
      theme: ThemeData(hintColor: Colors.white),
    );
  }
}
