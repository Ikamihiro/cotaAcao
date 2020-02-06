import 'package:flutter/material.dart';

class InvalidDate extends StatefulWidget {
  final String dateSearch;

  InvalidDate({Key key, this.dateSearch}) : super(key: key);

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
          "Data " + widget.dateSearch + " inválida, tente novamente...",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red),
        ),
      ],
    );
  }
}
