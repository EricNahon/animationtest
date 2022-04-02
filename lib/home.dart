import 'dart:async';
import 'package:flutter/material.dart';

import 'fallingcoins/coin_streamer.dart';
import 'fallingcoins/coin_animation.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TickerProvider ticker;
  Stream<CoinAnimation>? streamcoins;
  late CoinStreamer coinstreamer;

  @override
  void initState() {
    super.initState();
    coinstreamer = CoinStreamer(ticker: this);
    ticker = this;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('stream widget test'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            coinstreamer.startfallingcoins(nbCoin: CoinStreamer.randominteger(min: 1, max: 12), screenHeight: MediaQuery.of(context).size.height);
          });
        },
        tooltip: 'make coins fall from the sky',
        child: coinstreamer.coinImage(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: coinstreamer.coinstreambuilder(context),
      ),
    );
  }

}
