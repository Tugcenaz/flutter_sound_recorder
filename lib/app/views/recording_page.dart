import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound_recorder/app/components/record_button.dart';
import 'package:flutter_sound_recorder/app/controller/sound_controller.dart';
import 'package:flutter_sound_recorder/app/views/home_page.dart';
import 'package:get/get.dart';

import '../../core/styles/text_styles.dart';

class RecordingPage extends StatelessWidget {
  RecordingPage({super.key});

  final SoundController soundController = Get.find();

  Widget _buildBody() {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 100.0.h),
            child: AudioWaveforms(
              enableGesture: true,
              size: Size(double.infinity, 80.h),
              recorderController: soundController.recorderController,
              waveStyle: const WaveStyle(),
            ),
          ),
          Text(
            soundController.audioTime,
            style: TextStyles.generalBlackTextStyle1(),
          ),
          soundController.voiceState == VoiceState.recording
              ? RecordButton(
                  function: () {
                    soundController.pauseRecord();
                  },
                  icon: Icons.pause,
                  size: 45.sp,
                )
              : RecordButton(
                  function: () {
                    soundController.startRecord();
                  },
                  icon: Icons.play_arrow,
                  size: 45.sp)
        ],
      ),
    );
  }

  /*
  *
  *  if (soundController.voiceState == VoiceState.none) {
                soundController.startRecord();
              } else if (soundController.voiceState == VoiceState.recording) {
                soundController.pauseRecord();
              } else {
                soundController.startRecord();
              }
              *
              * */
  /*soundController.voiceState == VoiceState.recording
                      ? Icon(
                          Icons.pause,
                          size: 22.sp,
                          color: Colors.white,
                        )
                      : soundController.voiceState == VoiceState.paused
                          ? Icon(
                              Icons.play_arrow,
                              size: 22.sp,
                              color: Colors.white,
                            )
                          : const SizedBox(),*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: Bounceable(
            onTap: () {
              soundController.cancelRecord();
              Get.to(() => MyHomePage());
            },
            child: const Icon(
              Icons.close,
              color: Colors.black,
            )),
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0.w),
            child: Bounceable(
                onTap: () {
                  soundController.stopAndSaveRecord();
                  Get.to(() => MyHomePage());
                },
                child: const Icon(
                  Icons.check,
                  color: Colors.black,
                )),
          )
        ],
      ),
      body: _buildBody(),
    );
  }
}
