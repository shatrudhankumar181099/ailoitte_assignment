import 'package:ailoitte/sync_action.dart';
import 'package:hive/hive.dart';

import 'hive_boxes.dart';
import 'data/note_remote_ds.dart';

class SyncService {
  final NoteRemoteDS remote;
  final Box queueBox;

  SyncService(this.queueBox, this.remote);

  Future<void> processQueue() async {

    final queue = HiveBoxes.queue;
    print("[SYNC] Processing Queue...");
    print("[SYNC] Queue Size: ${queue.length}");

    for (var key in queue.keys) {

      final json = Map<String, dynamic>.from(queue.get(key));
      final action = SyncAction.fromJson(json);

      try {
        await remote.upsertNote(action.payload);
        switch (action.type) {
          case SyncType.add:
          case SyncType.update:
            await remote.upsertNote(action.payload);
            break;

          case SyncType.delete:
            await remote.deleteNote(action.id);
            break;
        }
        print("[SYNC] Processing: ${action.type} (id: ${action.id})");

        await queue.delete(key);
      } catch (e) {
        print("❌ Sync failed: ${action.id}");

        if (action.retryCount < 1) {
          await Future.delayed(const Duration(seconds: 2));
          print("[SYNC] Retrying... (attempt ${action.retryCount})");

          queue.put(
            key,
            action.copyWith(retryCount: action.retryCount + 1).toJson(),
          );
        } else {
          print("⚠️ Dropped after retry: ${action.id}");
        }
      }
    }
  }
}
