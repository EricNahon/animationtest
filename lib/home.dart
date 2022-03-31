import 'dart:async';
import 'dart:math';
import 'package:animationtest/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:soundpool/soundpool.dart';

import 'helper.dart';
import 'streamed_coin.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final List<Widget> _coinList = [];
  late TickerProvider ticker;
  Stream<StreamedCoin>? streamcoins;

  late Map<String, int> _soundIds;
  bool mute = false;
  final _sounds = [Constants.coinSound];
  late Soundpool _pool;

  @override
  void initState() {
    super.initState();
    ticker = this;
    initsound();
  }

  fallingCoins({int nbCoin = 5}) async {
    streamcoins = (() async* {
      for (var i = 0; i < nbCoin; i++) {
        var coinValue = Helper.randominteger(min: 1, max: 20);
        var duration = Helper.randominteger(max: 500) + 1200;
        var delay = i < nbCoin - 1 ? Helper.randominteger(min: 200, max: 600) : duration + Helper.randominteger(min: 100, max: 400);
        var dx = Random().nextDouble();
        var controller = AnimationController(vsync: ticker, duration: Duration(milliseconds: duration));
        await Future<void>.delayed(Duration(milliseconds: delay));
        yield StreamedCoin(value: coinValue, controller: controller, begin: Offset(dx, -6.0), end: Offset(dx, 1.0));
      }
    })();
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
            fallingCoins(nbCoin: Helper.randominteger(min: 1, max: 12));
          });
        },
        tooltip: 'make coins fall from the sky',
        child: Image.asset(
                Constants.assetsImagePath + Constants.coinImage,
                fit: BoxFit.contain,
              ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: StreamBuilder(
          stream: streamcoins,
          initialData: null,
          builder: (context, AsyncSnapshot<StreamedCoin?> snapshot) {
            if (snapshot.hasError) return Container();
            if (snapshot.hasData && snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data != null) {
                var coin = snapshot.data!;
                _coinList.add(coin.widget);
                coin.controller.reset();
                coin.controller.forward();
                playSound(Constants.coinSound);
                return Stack(children: _coinList);
              } else {
                return Container();
              }
            }
            return Container();
          },
        ),
      ),
    );
  }

  void initsound() {
    _pool = Soundpool.fromOptions(options: const SoundpoolOptions());
    _soundIds = {};
    for (var value in _sounds) {
      scheduleMicrotask(() async {
        final data = await rootBundle.load('${Constants.assetsSoundPath}$value');
        _soundIds[value] = await _pool.load(data);
      });
    }
  }

  void playSound(String name) {
    final soundId = _soundIds[name];
    if (soundId != null && !mute) {
      _pool.play(soundId);
    }
  }
}
