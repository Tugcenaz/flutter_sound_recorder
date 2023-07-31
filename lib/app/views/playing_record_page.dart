import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound_recorder/app/controller/flutter_sound_player_controller.dart';
import 'package:flutter_sound_recorder/app/controller/sound_controller.dart';
import 'package:get/get.dart';

import '../../core/styles/text_styles.dart';
import '../components/record_button.dart';

class PlayingRecordPage extends StatelessWidget {
  final String recordFilePath;
  final Duration recordFileDuration;

  PlayingRecordPage(
      {super.key,
      required this.recordFilePath,
      required this.recordFileDuration});

  final SoundController soundController = Get.find();
  final FlutterSoundPlayerController flutterSoundPlayerController = Get.find();

  Widget _buildBody() {
    return Obx(
      () => Column(
        children: [
          Text('Record Name', style: TextStyles.generalBlackTextStyle1()),
          Text('Record Duration', style: TextStyles.generalBlackTextStyle1()),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: ProgressBar(
                progressBarColor: Colors.black,
                baseBarColor: Colors.black45,
                thumbColor: Colors.black,barHeight: 3,thumbRadius: 5,
                progress: flutterSoundPlayerController.currentDuration.value,
                buffered: recordFileDuration,
                total: recordFileDuration,
                onSeek: (duration) {
                  flutterSoundPlayerController.player.seek(duration);
                  debugPrint('User selected a new time: $duration');
                },
              ),
            ),
          ),
          RecordButton(
            function: () {
              flutterSoundPlayerController.pauseResumePlayer();
            },
            icon: flutterSoundPlayerController.player.playerState.playing
                ? Icons.pause
                : Icons.play_arrow,
            size: 45.sp,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Bounceable(
            onTap: () {
              Get.back();
              flutterSoundPlayerController.stopPlayer();
            },
            child: const Icon(Icons.arrow_back_ios_new)),
      ),
      body: _buildBody(),
    );
  }
}
