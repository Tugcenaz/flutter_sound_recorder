import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound_recorder/app/controller/sound_controller.dart';
import 'package:get/get.dart';

class RecordButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback function;
  final double? size;
 final EdgeInsetsGeometry? padding;
  RecordButton(
      {super.key, required this.function, required this.icon, this.size,this.padding});

  final SoundController soundController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: function,
      child: Container(
        margin: EdgeInsets.all(70.sp),
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            size: size ?? 22.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
