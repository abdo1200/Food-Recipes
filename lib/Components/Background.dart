import 'package:flutter/material.dart';

class backGround extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.blueGrey,
                const Color(0xFF253236),
              ]
          )
      ),
    );
  }
}
