import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Surabaya Place"),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Text(
          'Selamat Datang di Surabaya Place!',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
