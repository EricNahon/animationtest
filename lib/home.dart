import 'dart:math';

import 'package:animationtest/coin.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  final String coinImagePath = 'assets/images/coin.png';
  late double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 900);
  var coinwidth = 60.0, coinLeft = 0.0, coinRight = 10.0, coinTop = 0.0, coinBottom = 60.0;
  var coins = <Coin>[];
  late int nbCoins;
  late List<double> coinsleft;
  bool coinsVisible = true;

  List<Widget> getCoins({required Size screensize, required List<double> coinsleft}) {
    coins = Coin().getCoins(cointop: coinTop, coinsleft: coinsleft, screensize: screensize);

    var widgets = coins.map((item) {
      item.left = 0;
      item.top = coinTop;
      return item.widget!;
    }).toList();

    return widgets;
  }

  animateCoin() {
    setState(() {
      if (coinTop == screenHeight) {
        coinTop = -coinwidth-5;
      } else {
        coinTop = screenHeight;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    coinTop = -coinwidth - 5;
    nbCoins = Random(Random().nextInt(765)).nextInt(20) + 1;
    coinsleft = List<double>.generate(nbCoins, (int index) => Random(Random().nextInt(765)).nextInt(900).toDouble() + 100);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          color: Colors.blue.shade100,
          width: screenWidth,
          height: screenHeight,
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            fit: StackFit.expand,
            children: getCoins(coinsleft: coinsleft, screensize: size),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: animateCoin,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
