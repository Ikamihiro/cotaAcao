import 'package:flutter/material.dart';

class WaitingContainer extends StatefulWidget {
  @override
  _WaitingContainerState createState() => new _WaitingContainerState();
}

class _WaitingContainerState extends State<WaitingContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      height: 200.0,
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        strokeWidth: 5.0,
      ),
    );
  }
}
