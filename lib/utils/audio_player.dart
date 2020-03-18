import 'package:audioplayers/audio_cache.dart';

class AudioPlayer {
  AudioCache _plyr = AudioCache();

  void playSuccessSound() {
    _plyr.play('success.mp3');
  }

  void playSkipSound() {
    _plyr.play('swoosh.mp3');
  }

  void playRemoveSound() {
    _plyr.play('uhOhBaby.mp3');
  }

  void playErrorSound() {
    _plyr.play('error.mp3');
  }
}
