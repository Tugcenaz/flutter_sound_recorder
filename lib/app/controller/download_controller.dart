import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound_recorder/app/controller/flutter_sound_player_controller.dart';
import 'package:flutter_sound_recorder/app/views/playing_record_page.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class DownloadController extends GetxController {
  RxBool active = false.obs;
  RxInt downloadBytes = 0.obs;
  RxInt fileTotalBytes = 0.obs;
  var audioPath ="https://firebasestorage.googleapis.com/v0/b/flutter-sound-recorder.appspot.com/o/soft-rain-ambient-111154.mp3?alt=media&token=a0fc04a8-efa3-47af-b280-65d581aa2a58";
  //var audioPath =
     // "https://firebasestorage.googleapis.com/v0/b/flutter-sound-recorder.appspot.com/o/Yagmur-sesi-zil-sesi-indir-4.mp3?alt=media&token=a7a5ddfe-7b0f-46ae-ad81-50c16f7366be";

  startDownload() async {
    FlutterSoundPlayerController flutterSoundPlayerController = Get.find();
    String filePath = await downloadFile(audioPath);
    //indirilen dosyadaki file'ın byteları alınır ve simülasyona gönderilir
    File soundFile =
        await byteDownloadSimulator(File(filePath).readAsBytesSync());

    await flutterSoundPlayerController.startPlayer(recordFile: soundFile.path);
    Get.to(() => PlayingRecordPage(recordFilePath: soundFile.path));
  }

  Future<File> byteDownloadSimulator(Uint8List bytes) async {
    active.value = true;
    fileTotalBytes.value = bytes.length;
    List<int> newBytes = [];
    for (int i = 0; i < bytes.length; i++) {
      if (active.value == false) {
        i = bytes.length;
      } else {
        downloadBytes.value = i;
        await Future.delayed(const Duration(microseconds: 50));

        newBytes.add(bytes[i]);
      }
    }
    final tempDir = await getTemporaryDirectory();
    File file = await File(
            '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.ogg')
        .create();
    await file.writeAsBytes(newBytes);
    downloadBytes.value = 0;
    fileTotalBytes.value = 0;
    active.value = false;
    return file;
  }

  Future<String> downloadFile(String url) async {
    HttpClient httpClient = HttpClient();
    File file;
    String filePath = '';
    String myUrl = '';
    Directory tempDir = await getTemporaryDirectory();
    String fileName = '${DateTime.now().millisecondsSinceEpoch}.mp3';
    try {
      myUrl = '$url/$fileName';
      var request = await httpClient.getUrl(Uri.parse(myUrl));
      var response = await request.close();
      if (response.statusCode == 200) {
        Uint8List bytes = await consolidateHttpClientResponseBytes(response);
        filePath = '${tempDir.path}/$fileName';
        file = File(filePath);
        debugPrint("bytest = ${bytes.length}");
        await file.writeAsBytes(bytes);
      } else {
        filePath = 'Error code: ${response.statusCode}';
      }
    } catch (ex) {
      filePath = 'Can not fetch url';
    }

    return filePath;
  }
}
