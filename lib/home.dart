import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PaginaInicial extends StatefulWidget {
  @override
  _PaginaInicialState createState() => new _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  String _pesquisa, _name;
  double _variacao, _abertura, _fechamento, _alta, _baixa;

  DateTime _currentdate = new DateTime.now();

  Future<Null> _selectdate(BuildContext context) async {
    final DateTime _seldate = await showDatePicker(
        context: context,
        initialDate: _currentdate,
        firstDate: DateTime(2010),
        lastDate: DateTime(2100),
        builder: (context, child) {
          return SingleChildScrollView(
            child: child,
          );
        });

    if (_seldate != null) {
      setState(() {
        _currentdate = _seldate;
      });
    }
  }

  Future<Map> _getStockPrice() async {
    http.Response response;
    if (_pesquisa == null || _pesquisa.isEmpty) {
      response = await http.get(
          "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=^BVSP&apikey=0H4TALABSPUCEGZN");
      if (response.statusCode == 200)
        return json.decode(response.body);
      else
        throw Exception;
    } else {
      response = await http.get(
          "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=$_pesquisa.SAO&apikey=0H4TALABSPUCEGZN");
      if (response.statusCode == 200)
        return json.decode(response.body);
      else
        throw Exception;
    }
  }

  @override
  void initState() {
    super.initState();
    _getStockPrice().then((map) {
      print(map);
    });
  }

  double _getVariacao(double abertura, double fechamento) {
    return (fechamento / abertura - 1) * 100;
  }

  @override
  Widget build(BuildContext context) {
    String _formattedate = new DateFormat.yMd().format(_currentdate);
    //String _year = new DateFormat.y().format(_currentdate);
    //String _month = new DateFormat.M().format(_currentdate);
    //String _day = new DateFormat.d().format(_currentdate);
    //_formattedate = _formattedate.replaceAll('/', '-');
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.black,
        title: new Text('Cota Ação'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _selectdate(context);
            },
            icon: Icon(Icons.calendar_today),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                'Escolher Data',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
      body: new Stack(
        children: <Widget>[
          Image.asset(
            'images/market.jpg',
            fit: BoxFit.cover,
            height: 1000.0,
          ),
          Align(
            child: Text(
              'Data: $_formattedate',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            alignment: Alignment.topCenter,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.all(10),
                child: new TextField(
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                      labelText: 'Pesquise aqui',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder()),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  onSubmitted: (text) {
                    setState(() {
                      _pesquisa = text;
                    });
                  },
                ),
              ),
              new Expanded(
                child: FutureBuilder(
                  future: _getStockPrice(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Container(
                          width: 200.0,
                          height: 200.0,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 5.0,
                          ),
                        );
                      default:
                        if (snapshot.data["Error Message"] != null ||
                            !snapshot.hasData) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                _pesquisa,
                                style: TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Nada encontrado!',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              Text(
                                'Tente novamente...',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          );
                        }
                        _name = snapshot.data["Meta Data"]["2. Symbol"];
                        _abertura = double.parse(
                            snapshot.data["Time Series (Daily)"]["2019-12-06"]
                                ["1. open"]);
                        _alta = double.parse(
                            snapshot.data["Time Series (Daily)"]["2019-12-06"]
                                ["2. high"]);
                        _baixa = double.parse(
                            snapshot.data["Time Series (Daily)"]["2019-12-06"]
                                ["3. low"]);
                        _fechamento = double.parse(
                            snapshot.data["Time Series (Daily)"]["2019-12-06"]
                                ["4. close"]);
                        _variacao = _getVariacao(_abertura, _fechamento);

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _name,
                              style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            new Text(
                              _variacao.toStringAsPrecision(3) + '%',
                              style: TextStyle(
                                fontSize: 70,
                                fontWeight: FontWeight.bold,
                                color:
                                    _variacao > 0 ? Colors.green : Colors.red,
                              ),
                            ),
                            new Text(
                              "Abertura: R\$ " + _abertura.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            new Text(
                              "Alta: R\$ " + _alta.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            new Text(
                              "Baixa: R\$ " + _baixa.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            new Text(
                              "Fechamento: R\$ " + _fechamento.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
