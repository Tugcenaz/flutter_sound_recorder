import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class FlutterSoundPlayerController extends GetxController {
  final player = AudioPlayer();
  Rx<Duration> currentDuration = Duration.zero.obs;
  Rx<PlayState> playState = PlayState.resume.obs;
  PlayerController playerController = PlayerController();

  void startPlayer({required String recordFile}) async {
    try {
      currentDuration.value = Duration.zero;
      Duration? totalDuration = await player.setFilePath(recordFile);
      debugPrint(totalDuration.toString());
      player.play();
      player.setLoopMode(LoopMode.one);
      player.positionStream.listen((event) {
        debugPrint("aaaa $event");
        currentDuration.value = event;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void pauseResumePlayer() async {
    if (player.playerState.playing) {
      await player.pause();
    } else {
      player.play();
    }
  }

  void changePlayState(PlayState state) {
    playState.value = state;
  }

  void stopPlayer() async {
    await player.stop();
  }
}

enum PlayState { pause, resume }
