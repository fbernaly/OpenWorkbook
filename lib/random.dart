import 'dart:math';

class RandomGenerator {
  static int generate({int seed, int min, int max}) {
    return min + Random(seed).nextInt(max - min);
  }
}
