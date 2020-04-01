import 'dart:math';

class RandomGenerator {
  static int generate({int seed, int min, int max, int initial}) {
    int l = max - min;
    if (l < 0)
      return null;
    else if (l == 0)
      return min;
    else if (l == 1) {
      if (seed == null) seed = DateTime.now().millisecondsSinceEpoch;
      return min + (seed % 2);
    } else {
      var a = initial;
      if (seed == null) seed = DateTime.now().millisecondsSinceEpoch;
      do {
        seed = seed + 1;
        a = min + Random(seed).nextInt(l + 1);
      } while (a == initial);
      return a;
    }
  }

  static String getRandomItem(List<String> items) {
    var i = RandomGenerator.generate(
        seed: DateTime.now().millisecondsSinceEpoch, min: 0, max: items.length - 1);
    return items[i];
  }

  static String getRandomGreetingMessage() {
    List<String> messages = [
      'Hello, how are you?',
      'Ready to practice?',
      'What are we going to practice?',
      'I am here to help you!',
      'Select what to practice'
    ];
    return getRandomItem(messages);
  }

  static String getRandomOkMessage() {
    List<String> messages = [
      'Good job!',
      'You rock!',
      'Correct!',
      'Great!',
      'You nailed it!',
      'Amazing!'
    ];
    return getRandomItem(messages);
  }

  static String getRandomReviewMessage() {
    List<String> messages = ['Are you sure?', 'Review your answer'];
    return getRandomItem(messages);
  }

  static String getRandomErrorMessage() {
    List<String> messages = [
      'Try again',
      'Uh oh',
      "Incorrect",
      "That's not the answer"
    ];
    return getRandomItem(messages);
  }

  static String getRandomSkipMessage() {
    List<String> messages = [
      'Try this one',
      "Let's try a new one",
      "Let's skip that one"
    ];
    return getRandomItem(messages);
  }
}
