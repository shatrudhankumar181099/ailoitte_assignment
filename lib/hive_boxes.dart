import 'package:hive/hive.dart';

class HiveBoxes {
  static Box get notes => Hive.box('notes');
  static Box get queue => Hive.box('queue');
}