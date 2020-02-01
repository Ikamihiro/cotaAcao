import 'package:flutter/material.dart';

class ResultsFound extends StatefulWidget {
  final String name, day, mesNome, year;
  final double variacao, abertura, alta, baixa, fechamento;

  const ResultsFound(
      {Key key,
      this.name,
      this.variacao,
      this.abertura,
      this.alta,
      this.baixa,
      this.fechamento,
      this.day,
      this.mesNome,
      this.year})
      : super(key: key);

  @override
  _ResultsFoundState createState() => _ResultsFoundState();
}

class _ResultsFoundState extends State<ResultsFound> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.name,
          style: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          widget.variacao.toStringAsPrecision(3) + '%',
          style: TextStyle(
            fontSize: 70,
            fontWeight: FontWeight.bold,
            color: widget.variacao > 0 ? Colors.green : Colors.red,
          ),
        ),
        Text(
          "Abertura: R\$ " + widget.abertura.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          "Alta: R\$ " + widget.alta.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          "Baixa: R\$ " + widget.baixa.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          "Fechamento: R\$ " + widget.fechamento.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          'Data: ' +
              widget.day +
              ' de ' +
              widget.mesNome +
              ' de ' +
              widget.year,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }
}
