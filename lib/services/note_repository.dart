import 'package:ailoitte/sync_action.dart';
import 'package:ailoitte/sync_service.dart';
import 'package:ailoitte/utils/exports.dart';
import 'package:uuid/uuid.dart';

import '../hive_boxes.dart';
import '../model/note_model.dart';
import '../data/note_local_ds.dart';

class NoteRepository {
  final NoteLocalDS local;
  final SyncService syncService;
  final uuid = const Uuid();

  NoteRepository(this.local, this.syncService);

  List<Note> getNotes() => local.getNotes();

  Future<void> addNote({
    required String title,
    required String content,
  }) async {
    final id = uuid.v4();

    final note = Note(
      id: id,
      title: title,
      content: content,
      isLiked: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await local.saveNote(note);
    final action = SyncAction(
      id: id,
      type: SyncType.add,
      payload: note.toJson(),
    );

    await HiveBoxes.queue.put(id, action.toJson());

    print("[SYNC] Action Added → ADD_NOTE (id: $id)");
    print("[SYNC] Queue Size: ${HiveBoxes.queue.length}");
    _trySyncSilently();
  }

  Future<void> _trySyncSilently() async {
    try {
      await syncService.processQueue();
    } catch (e) {
      debugPrint('Sync failed (offline): $e');
    }
  }

  Future<void> deleteNote(String id) async {
    await local.deleteNote(id);

    final action = SyncAction(
      id: id,
      type: SyncType.delete,
      payload: {"id": id},
    );
    await HiveBoxes.queue.put(id, action.toJson());

    _trySyncSilently();
  }

  Future<void> toggleLike(String id) async {
    final notes = local.getNotes();
    final note = notes.firstWhere((n) => n.id == id);

    final updated = Note(
      id: note.id,
      title: note.title,
      content: note.content,
      isLiked: !note.isLiked,
      createdAt: note.createdAt,
      updatedAt: DateTime.now(),
    );

    await local.saveNote(updated);

    final action = SyncAction(
      id: id,
      type: SyncType.update,
      payload: updated.toJson(),
    );

    await HiveBoxes.queue.put(id, action.toJson());
    _trySyncSilently();

  }
}