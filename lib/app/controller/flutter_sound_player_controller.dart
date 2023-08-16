import 'package:flutter/material.dart';
import 'package:flutter_sound_recorder/app/controller/sound_controller.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../views/playing_record_page.dart';

class FlutterSoundPlayerController extends GetxController {
  final player = AudioPlayer();
  Rx<Duration> currentDuration = Duration.zero.obs;
  Rx<PlayState> playState = PlayState.resume.obs;
  SoundController soundController=Get.find();
  Duration recordedDuration = Duration.zero;

  startPlayer({required String recordFile}) async {
    try {
      currentDuration.value = Duration.zero;
      Duration? totalDuration = await player.setFilePath(recordFile);
      recordedDuration=totalDuration??Duration.zero;//kayıt süresine toplam duration atadık
      debugPrint("total duration = ${totalDuration}");
      player.play();
      player.setLoopMode(LoopMode.one);
      player.positionStream.listen((event) {
        debugPrint("aaaa $event");
        currentDuration.value = event;
      });
      Get.to(() => PlayingRecordPage(
          recordFilePath: recordFile));
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
