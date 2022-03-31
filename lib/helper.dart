import 'dart:math';

class Helper {
  	static int randominteger({int min = 0, int max = 10}) => min + Random().nextInt(max - min);
}