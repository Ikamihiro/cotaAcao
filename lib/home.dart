import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import './components/waiting_container.dart';
import './components/not_found.dart';
import './components/invalid_date.dart';
import './components/results_found.dart';

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
    String _mesNome = new DateFormat.MMMM().format(_currentdate);
    String _year = new DateFormat.y().format(_currentdate);
    String _month = new DateFormat.M().format(_currentdate);
    if (_month.length < 2) {
      _month = '0$_month';
    }
    String _day = new DateFormat.d().format(_currentdate);
    String _dateSearch = '$_year-$_month-$_day';
    var _opcoes = [''];
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
          children: <Widget>[],
        ),
      ),
      body: new Stack(
        children: <Widget>[
          Image.asset(
            'images/market.jpg',
            fit: BoxFit.cover,
            height: 1000.0,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
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
              Expanded(
                child: FutureBuilder(
                  future: _getStockPrice(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return WaitingContainer();
                      default:
                        if (snapshot.data["Error Message"] != null ||
                            !snapshot.hasData) {
                          return NotFound(
                            pesquisa: _pesquisa,
                          );
                        }

                        if (snapshot.data["Time Series (Daily)"]
                                ['$_dateSearch'] ==
                            null) {
                          return InvalidDate();
                        }

                        _name = snapshot.data["Meta Data"]["2. Symbol"];
                        _abertura = double.parse(
                            snapshot.data["Time Series (Daily)"]['$_dateSearch']
                                ["1. open"]);
                        _alta = double.parse(
                            snapshot.data["Time Series (Daily)"]['$_dateSearch']
                                ["2. high"]);
                        _baixa = double.parse(
                            snapshot.data["Time Series (Daily)"]['$_dateSearch']
                                ["3. low"]);
                        _fechamento = double.parse(
                            snapshot.data["Time Series (Daily)"]['$_dateSearch']
                                ["4. close"]);
                        _variacao = _getVariacao(_abertura, _fechamento);

                        return ResultsFound(
                          abertura: _abertura,
                          alta: _alta,
                          baixa: _baixa,
                          day: _day,
                          fechamento: _fechamento,
                          mesNome: _mesNome,
                          name: _name,
                          variacao: _variacao,
                          year: _year,
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
