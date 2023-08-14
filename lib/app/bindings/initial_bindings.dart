import 'package:flutter_sound_recorder/app/controller/flutter_sound_player_controller.dart';
import 'package:flutter_sound_recorder/app/controller/sound_controller.dart';
import 'package:flutter_sound_recorder/app/controller/download_controller.dart';
import 'package:get/get.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SoundController(), fenix: true);
    Get.lazyPut(() => FlutterSoundPlayerController(), fenix: true);
    Get.lazyPut(() => DownloadController(), fenix: true);
  }
}
