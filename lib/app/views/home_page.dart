import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound_recorder/app/components/record_button.dart';
import 'package:flutter_sound_recorder/app/components/recorded_voice_widget.dart';
import 'package:flutter_sound_recorder/app/views/recording_page.dart';
import 'package:flutter_sound_recorder/app/controller/flutter_sound_player_controller.dart';
import 'package:get/get.dart';
import '../../core/styles/text_styles.dart';
import '../controller/sound_controller.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  SoundController soundController = Get.find();

  //FlutterSoundPlayerController flutterSoundPlayerController = Get.find();

  Widget _buildBody() {
    return Stack(alignment: AlignmentDirectional.bottomStart, children: [
      Obx(
        () => Column(
          children: [
            soundController.recordList.isEmpty
                ? Center(
                    child: Text(
                      'Henüz hiç kayıt yapmadınız',
                      style: TextStyles.generalBlackTextStyle2(),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: soundController.recordList.length,
                      itemBuilder: (context, int index) {
                        return RecordedVoiceWidget(
                          index: index,
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      Container(
        height: 200.h,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(22.sp),
                topLeft: Radius.circular(22.sp))),
        child: RecordButton(
          icon: Icons.circle,
          function: () {
            soundController.startRecord();
            Get.off(() => RecordingPage());
          },
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        toolbarHeight: 100.h,
        title: Text(
          'Tüm kayıtlar',
          style: TextStyles.generalBlackTextStyle1(),
        ),
      ),
      backgroundColor: const Color(0xffEAEAEA),
      body: _buildBody(),
    );
  }
}

/*
*
*
*
*
*   Obx(
          () => Text(soundController.audioTime,
              style: const TextStyle(
                fontSize: 24,
              )),
        ),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (soundController.voiceState != VoiceState.none)
                MediaIcon(
                    icon: soundController.voiceState == VoiceState.recording
                        ? Icons.pause
                        : Icons.play_arrow_rounded,
                    onPressed: soundController.pauseResumeRecord),
              if (soundController.voiceState == VoiceState.none)
                MediaIcon(
                  icon: Icons.mic,
                  onPressed: soundController.startRecord,
                ),
              if (soundController.voiceState != VoiceState.none)
                MediaIcon(
                    icon: Icons.stop, onPressed: soundController.stopRecord),
            ],
          ),
        ),
        ElevatedButton(
            onPressed: () {
              flutterSoundPlayerController
                  .startPlayer(soundController.recordList[0]);
            },
            child: const Text('play')),
            *
            *
            *
            *
            *
            *
            *
            *
            *
            *
            *
            *
            *
            * */

class MediaIcon extends StatelessWidget {
  const MediaIcon({super.key, required this.icon, required this.onPressed});

  final IconData? icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: Colors.pink.withOpacity(0.2)),
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        iconSize: 26,
      ),
    );
  }
}
