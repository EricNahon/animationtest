import 'dart:math';

import 'package:flutter/material.dart';

class Coin {
  double top = 0;
  double left = 0;
  double width = 65, height = 65;
  String imagePath = 'assets/images/coin.png';
  Widget? widget;
  Coin({
    this.top = 0,
    this.left = 0,
    this.width = 65,
    this.height = 65,
    this.imagePath = 'assets/images/coin.png',
    this.widget,
  });

  List<Coin> getCoins({int? value, required double cointop, required List<double> coinsleft, required Size screensize}) {
    var coins = <Coin>[];
    var coinvalue = value ?? 10;
    var nbCoins = coinsleft.length;

    for (var i = 0; i < nbCoins; i++) {
      debugPrint('left=$left');
      var item = Coin();
      var coinDuration = Duration(milliseconds: Random(Random().nextInt(765)).nextInt(1200) + 700);

      Widget coinwidget = Opacity(
        opacity: cointop > 0 ? 1 : 0,
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          fit: StackFit.loose,
          children: [
            AnimatedPositioned(
              height: height,
              width: width,
              top: cointop,
              left: coinsleft[i],
              duration: cointop > 0 ? coinDuration : const Duration(milliseconds: 0),
              child: Image.asset(
                imagePath,
                width: width,
                fit: BoxFit.contain,
              ),
            ),
            AnimatedPositioned(
              height: height,
              width: width,
              top: cointop + 21,
              left: coinsleft[i],
              duration: cointop > 0 ? coinDuration : const Duration(milliseconds: 0),
              child: SizedBox(
                width: width,
                height: height,
                child: Text(
                  coinvalue.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      );
      item.widget = coinwidget;
      coins.add(item);
    }

    return coins;
  }
}
