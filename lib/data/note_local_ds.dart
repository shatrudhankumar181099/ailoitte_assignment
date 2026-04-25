import 'package:hive/hive.dart';

import '../model/note_model.dart';

class NoteLocalDS {
  final Box box;

  NoteLocalDS(this.box);

  List<Note> getNotes() {
    final data = box.values.toList();
    return data.map((e) => Note.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<void> deleteNote(String id) async {
    await box.delete(id);
  }

  Future<void> saveNote(Note note) async {
    await box.put(note.id, note.toJson());
  }
}