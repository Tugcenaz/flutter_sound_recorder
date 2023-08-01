import 'package:hive/hive.dart';

openHive()async{
  await Hive.openBox('soundBox');
}