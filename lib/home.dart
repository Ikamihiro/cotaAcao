import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import './components/waiting_container.dart';
import './components/not_found.dart';
import './components/invalid_date.dart';
import './components/results_found.dart';

const TIMES_DAY = "TIME_SERIES_DAILY";
const TIMES_INTRADAY = "TIME_SERIES_INTRADAY";
const TIMES_WEEK = "TIME_SERIES_WEEKLY";
const TIMES_MOMTH = "TIME_SERIES_MONTHLY";

class PaginaInicial extends StatefulWidget {
  @override
  _PaginaInicialState createState() => new _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  String _data_key = "Time Series (Daily)";
  bool realTime = false, diario = true, semanal = false, mensal = false;
  int _index = 1;
  String _pesquisa, _name;
  double _variacao, _abertura, _fechamento, _alta, _baixa;

  DateTime _currentdate = new DateTime.now();

  String gerarUrl(String _pesquisa) {
    if (diario == true) {
      return "https://www.alphavantage.co/query?function=$TIMES_DAY&symbol=$_pesquisa&apikey=0H4TALABSPUCEGZN";
    }
    if (realTime == true) {
      return "https://www.alphavantage.co/query?function=$TIMES_INTRADAY&symbol=$_pesquisa&interval=5min&apikey=0H4TALABSPUCEGZN";
    }
    if (semanal == true) {
      return "https://www.alphavantage.co/query?function=$TIMES_WEEK&symbol=$_pesquisa&apikey=0H4TALABSPUCEGZN";
    }
    if (mensal == true) {
      return "https://www.alphavantage.co/query?function=$TIMES_MOMTH&symbol=$_pesquisa&apikey=0H4TALABSPUCEGZN";
    }
  }

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
    String url;
    http.Response response;

    if (_pesquisa == null || _pesquisa.isEmpty) {
      _pesquisa = "^BVSP";
      url = gerarUrl(_pesquisa);
      if (realTime == true) {
        response = await http.get(url);
        Timer.periodic(Duration(minutes: 5), (Timer timer) {
          setState(() {
            realTime = true;
          });
        });
      } else {
        response = await http.get(url);
      }
      if (response.statusCode == 200)
        return json.decode(response.body);
      else
        throw Exception;
    } else {
      if (_pesquisa.length <= 5) _pesquisa = '$_pesquisa.SAO';
      url = gerarUrl(_pesquisa);
      if (realTime == true) {
        response = await http.get(url);
        Timer.periodic(Duration(minutes: 5), (Timer timer) {
          setState(() {
            realTime = true;
          });
        });
      } else {
        response = await http.get(url);
      }
      if (response.statusCode == 200)
        return json.decode(response.body);
      else
        throw Exception;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void onTabTapped(int index) {
    setState(() {
      _index = index;
      if (_index == 0) {
        diario = false;
        realTime = true;
        semanal = false;
        mensal = false;
        _data_key = "Time Series (5min)";
      } else if (_index == 1) {
        diario = true;
        realTime = false;
        semanal = false;
        mensal = false;
        _data_key = "Time Series (Daily)";
      } else if (_index == 2) {
        diario = false;
        realTime = false;
        semanal = true;
        mensal = false;
        _data_key = "Weekly Time Series";
      } else if (_index == 3) {
        diario = false;
        realTime = false;
        semanal = false;
        mensal = true;
        _data_key = "Monthly Time Series";
      }
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
    if (_day.length < 2) {
      _day = '0$_day';
    }
    String _dateSearch = '$_year-$_month-$_day';

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
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _index,
        backgroundColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.watch,
              color: Colors.black,
            ),
            title: Text(
              "Real Time",
              style: TextStyle(color: Colors.black),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.today,
              color: Colors.black,
            ),
            title: Text(
              "Diário",
              style: TextStyle(color: Colors.black),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.view_agenda,
              color: Colors.black,
            ),
            title: Text(
              "Semanal",
              style: TextStyle(color: Colors.black),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_today,
              color: Colors.black,
            ),
            title: Text(
              "Mensal",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
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
                            pesquisa: _pesquisa.substring(0, 5),
                          );
                        }

                        if (_data_key == "Time Series (5min)") {
                          _dateSearch = snapshot.data[_data_key].keys.first;
                        }

                        if (snapshot.data[_data_key][_dateSearch] == null) {
                          return InvalidDate(
                            dateSearch: _dateSearch,
                          );
                        }
                        _name = snapshot.data['Meta Data']['2. Symbol'];
                        if (_name.length > 5) {
                          _name = _name.substring(0, 5);
                        }
                        _abertura = double.parse(
                            snapshot.data[_data_key][_dateSearch]["1. open"]);
                        _alta = double.parse(
                            snapshot.data[_data_key][_dateSearch]["2. high"]);
                        _baixa = double.parse(
                            snapshot.data[_data_key][_dateSearch]["3. low"]);
                        _fechamento = double.parse(
                            snapshot.data[_data_key][_dateSearch]["4. close"]);
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
