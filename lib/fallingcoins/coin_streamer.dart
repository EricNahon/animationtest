import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

import 'coin_animation.dart';
import 'coin_constants.dart';

class CoinStreamer {
  CoinStreamer({
    required this.ticker,
    this.coinsoundpath = CoinConstants.assetsSoundPath + CoinConstants.coinSound,
  }) {
    initsound();
  }

  late String? coinsoundpath;
  TickerProvider ticker;
  Stream<CoinAnimation>? streamcoins;
  final List<Widget> _coinList = [];

  late int coinsoundid;
  bool mute = false;
  late Soundpool soundpool;

  startfallingcoins({int nbCoin = 5, double coinHeight = 240, required double screenHeight}) async {
    debugPrint('screen height: $screenHeight');
    streamcoins = (() async* {
      for (var i = 0; i < nbCoin; i++) {
        var coinValue = randominteger(min: 1, max: 20);
        var duration = randominteger(max: 500) + 1200;
        var delay = i < nbCoin - 1 ? randominteger(min: 200, max: 600) : duration + randominteger(min: 100, max: 400);
        var dx = Random().nextDouble();
        dx = Random().nextDouble() < 0.5 ? dx : -dx; // horizontal start position = dx * coin width
        var controller = AnimationController(vsync: ticker, duration: Duration(milliseconds: duration));
        await Future<void>.delayed(Duration(milliseconds: delay));
        yield CoinAnimation(value: coinValue, controller: controller, begin: Offset(dx, -(screenHeight / coinHeight)), end: Offset(dx, 1.0));
      }
    })();
  }

  static int randominteger({int min = 0, int max = 10}) => min + Random().nextInt(max - min);

  StreamBuilder<CoinAnimation?> coinstreambuilder(BuildContext context) {
    return StreamBuilder(
      stream: streamcoins,
      initialData: null,
      builder: (context, AsyncSnapshot<CoinAnimation?> snapshot) {
        if (snapshot.hasError) return Container();
        if (snapshot.hasData && snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data != null) {
            var coin = snapshot.data!;
            _coinList.add(coin.widget);
            coin.controller.reset();
            coin.controller.forward();
            soundpool.play(coinsoundid);
            return Stack(children: _coinList);
          } else {
            return Container();
          }
        }
        return Container();
      },
    );
  }

  Widget coinImage() {
    return Image.asset(
      CoinConstants.assetsImagePath + CoinConstants.coinImage,
      fit: BoxFit.contain,
    );
  }

  void initsound() {
    soundpool = Soundpool.fromOptions(options: const SoundpoolOptions());
    if (coinsoundpath != null && coinsoundpath!.isNotEmpty) {
      scheduleMicrotask(() async {
        final data = await rootBundle.load(coinsoundpath!);
        coinsoundid = await soundpool.load(data);
      });
    }
  }
}
