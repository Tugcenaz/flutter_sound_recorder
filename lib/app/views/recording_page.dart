import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound_recorder/app/components/record_button.dart';
import 'package:flutter_sound_recorder/app/controller/sound_controller.dart';
import 'package:flutter_sound_recorder/app/views/home_page.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui show Gradient;
import '../../core/styles/text_styles.dart';

class RecordingPage extends StatelessWidget {
  RecordingPage({super.key});

  final SoundController soundController = Get.find();

  Widget _buildBody(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 200.0.h),
            child: AudioWaveforms(padding: EdgeInsets.symmetric(horizontal: 60.sp),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.grey.withOpacity(0.1),
                      Colors.grey.withOpacity(0.1)
                    ]),
              ),
              size: Size(double.infinity, 200.h),
              recorderController: soundController.recorderController,
              waveStyle: WaveStyle(
                showMiddleLine: false,
                extendWaveform: true,
                waveThickness: 4,
                gradient: ui.Gradient.linear(
                  const Offset(70, 50),
                  Offset(MediaQuery.of(context).size.width / 2, 0),
                  [Colors.red, Colors.green],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50.sp,
          ),
          Text(
            soundController.audioTime,
            style: TextStyles.generalBlackTextStyle1(fontSize: 38.sp),
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

  AppBar _buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      leading: Bounceable(
          onTap: () {
            soundController.cancelRecord();
            Get.back();
          },
          child: const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Icon(
              Icons.close,
              color: Colors.black,
            ),
          )),
      // backgroundColor: Colors.white,
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.0.w),
          child: Bounceable(
              onTap: () {
                soundController.stopAndSaveRecord();
                Get.back();

              },
              child: const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Icon(
                  Icons.check,
                  color: Colors.black,
                ),
              )),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }
}
