import 'package:flutter/material.dart';

class InvalidDate extends StatefulWidget {
  @override
  _InvalidDateState createState() => _InvalidDateState();
}

class _InvalidDateState extends State<InvalidDate> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Data inválida, tente novamente...",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red),
        ),
      ],
    );
  }
}
