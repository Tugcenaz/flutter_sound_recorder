import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class SoundController extends GetxController {
  final Rx<Duration> _recordDuration = Duration.zero.obs;
  final RxList<String> recordList = <String>[].obs;
  final Rx<VoiceState> _voiceState = VoiceState.none.obs;
  RxList<Duration> currentDurationList = <Duration>[].obs;
  var box = Hive.box("soundBox");

  Timer? timer;

//  final record = Record();
  RecorderController recorderController = RecorderController();

  Duration get recordDuration => _recordDuration.value;

  set recordDuration(Duration value) {
    _recordDuration.value = value;
  }

  VoiceState get voiceState => _voiceState.value;

  set voiceState(VoiceState value) {
    _voiceState.value = value;
  }

  String get audioTime {
    return recordDuration.toString().split('.').first.padLeft(8, '0');
  }

  @override
  void onInit() {
    super.onInit();
    getSoundList();
  }

  void startRecord() async {
    try {
      if (await recorderController.checkPermission()) {
        debugPrint("start ");
        await recorderController.record(
            bitRate: 48000, androidOutputFormat: AndroidOutputFormat.ogg);
        startTimer();
        changeVoiceState(VoiceState.recording);
      } else {
        debugPrint('İzin verilmedi');
      }
    } catch (e) {
      stopTimer();
      changeVoiceState(VoiceState.none);
      debugPrint(e.toString());
    }
  }

  void stopAndSaveRecord() async {
    try {
      String? recordPath = await recorderController.stop();
      debugPrint(
        "recordPath $recordPath",
      );
      /*currentDurationList.add(Duration(
          milliseconds: recorderController.recordedDuration.inMilliseconds));*/
      stopTimer();
      changeVoiceState(VoiceState.none);
      if (recordPath != null) {
        recordList.add(recordPath);
        debugPrint('recordList:$recordList');
        var fileBytes = await File(recordPath).readAsBytes();
        await box.add(fileBytes);
      }
    } catch (e) {
      stopTimer();
      changeVoiceState(VoiceState.none);
      debugPrint(e.toString());
    }
  }

  Future<List<String>> getSoundList() async {
    List<String> soundList = [];
    for (int i = 0; i < box.length; i++) {
      Uint8List? readData = box.getAt(i);
      if (readData != null) {
        final tempDir = await getTemporaryDirectory();
        File file = await File(
                '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}')
            .create();
        await file.writeAsBytes(readData);
        soundList.add(file.path);
      }
    }

    recordList.value = soundList;
    return soundList;
  }

  void pauseResumeRecord() {
    var recorderState =
        recorderController.onRecorderStateChanged.listen((event) {
      debugPrint(event.toString());
    });
    recorderState.isPaused ? startRecord() : pauseRecord();
  }

  void pauseRecord() async {
    try {
      await recorderController.pause();
      changeVoiceState(VoiceState.paused);
      stopTimer(resetTime: false);
    } catch (e) {
      stopTimer();
      changeVoiceState(VoiceState.none);
      debugPrint(e.toString());
    }
  }

  cancelRecord() async {
    try {
      await recorderController.stop();
      stopTimer();
      changeVoiceState(VoiceState.none);
    } catch (e) {
      stopTimer();
      changeVoiceState(VoiceState.none);
      debugPrint(e.toString());
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      recordDuration = recordDuration += const Duration(seconds: 1);
    });
  }

  void stopTimer({bool resetTime = true}) {
    timer?.cancel();
    timer = null;
    if (resetTime) recordDuration = Duration.zero;
  }

  void changeVoiceState(VoiceState state) {
    voiceState = state;
  }
}

enum VoiceState { paused, recording, none }
