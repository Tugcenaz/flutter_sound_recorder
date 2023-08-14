import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound_recorder/app/controller/flutter_sound_player_controller.dart';
import 'package:flutter_sound_recorder/app/controller/sound_controller.dart';
import 'package:get/get.dart';

import '../../core/styles/text_styles.dart';
import '../components/record_button.dart';

class PlayingRecordPage extends StatefulWidget {
  final String recordFilePath;

  const PlayingRecordPage({super.key, required this.recordFilePath});

  @override
  State<PlayingRecordPage> createState() => _PlayingRecordPageState();
}

class _PlayingRecordPageState extends State<PlayingRecordPage> {
  final SoundController soundController = Get.find();

  final FlutterSoundPlayerController flutterSoundPlayerController = Get.find();

  @override
  void dispose() {
    flutterSoundPlayerController.stopPlayer();
    super.dispose();
  }

  Widget _buildBody() {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Text(
                flutterSoundPlayerController.currentDuration
                    .toString()
                    .split('.')
                    .first
                    .padLeft(8, '0'),
                style: TextStyles.generalBlackTextStyle1()),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0.sp),
            child: ProgressBar(
              timeLabelPadding: 12.sp,
              progressBarColor: Colors.black,
              baseBarColor: Colors.black45,
              thumbColor: Colors.black,
              barHeight: 4,
              thumbRadius: 5,
              progress: flutterSoundPlayerController.currentDuration.value,
              buffered: flutterSoundPlayerController.recordedDuration,
              total: flutterSoundPlayerController.recordedDuration,
              onSeek: (duration) async {
                await flutterSoundPlayerController.player.seek(duration);
                debugPrint('User selected a new time: $duration');
              },
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
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }
}
