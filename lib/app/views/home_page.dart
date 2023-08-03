import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound_recorder/app/components/record_button.dart';
import 'package:flutter_sound_recorder/app/components/recorded_voice_widget.dart';
import 'package:flutter_sound_recorder/app/views/recording_page.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../core/styles/text_styles.dart';
import '../controller/sound_controller.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SoundController soundController = Get.find();
  var box = Hive.box("soundBox");

  @override
  void initState() {

    super.initState();

  box.clear();}
  Widget _buildBody() {
    return Obx(
      () => Column(mainAxisAlignment: MainAxisAlignment.end,
        children: [
          soundController.recordList.isEmpty
              ? Padding(
                padding: EdgeInsets.only(bottom: 250.0.sp),
                child: Center(
                    child: Text(
                      'Henüz hiç kayıt yapmadınız',
                      style: TextStyles.generalBlackTextStyle2(),
                    ),
                  ),
              )
              : Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: soundController.recordList.length,
                    itemBuilder: (context, int index) {
                      return RecordedVoiceWidget(
                        index: index,
                      );
                    },
                  ),
                ),
          Container(
            height: 200.h,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(36.sp),
                    topLeft: Radius.circular(36.sp))),
            child: RecordButton(
              icon: Icons.circle,
              function: () {
                soundController.startRecord();
                Get.to(() => RecordingPage());
              },
            ),
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        toolbarHeight: 100.h,
        title: Padding(
          padding: EdgeInsets.only(top: 20.0.sp, left: 20.sp),
          child: Text(
            'Tüm kayıtlar',
            style: TextStyles.generalBlackTextStyle1(),
          ),
        ),
      ),
      backgroundColor: const Color(0xffEAEAEA),
      body: _buildBody(),
    );
  }
}
