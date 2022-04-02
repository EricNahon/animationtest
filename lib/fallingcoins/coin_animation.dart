import 'package:flutter/material.dart';
import 'coin_constants.dart';

class CoinAnimation {
  AnimationController controller;
  late int value;
  late String imagePath;
  late Widget widget;
  late Animation<Offset> offset;
  late Offset begin;
  late Offset end;

  CoinAnimation({
    required this.controller,
    this.value = 10,
    this.imagePath = CoinConstants.assetsImagePath + CoinConstants.coinImage,
    this.begin = const Offset(0.2, -7.0),
    this.end = const Offset(0.2, 1.0),
  }) {
    offset = Tween<Offset>(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ),
    );
    widget = Align(
      alignment: Alignment.bottomCenter,
      child: SlideTransition(
        position: offset,
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: <Widget>[
              Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 43),
                child: Text(
                  value.toString(),
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
