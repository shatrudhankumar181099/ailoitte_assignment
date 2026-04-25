import 'package:ailoitte/sync_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'hive_boxes.dart';
import 'data/note_remote_ds.dart';

enum SyncType { add, update, delete }

class SyncAction {
  final String id;
  final SyncType type;
  final Map<String, dynamic> payload;
  final int retryCount;

  SyncAction({
    required this.id,
    required this.type,
    required this.payload,
    this.retryCount = 0,
  });

  factory SyncAction.fromJson(Map<String, dynamic> json) {
    return SyncAction(
      id: json['id'],
      type: SyncType.values.firstWhere((e) => e.name == json['type'],),
      payload: Map<String, dynamic>.from(json['payload']),
      retryCount: json['retryCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "type": type.name,
      "payload": payload,
      "retryCount": retryCount,
    };
  }

  SyncAction copyWith({int? retryCount}) {
    return SyncAction(
      id: id,
      type: type,
      payload: payload,
      retryCount: retryCount ?? this.retryCount,
    );
  }
}

final syncStatusProvider = FutureProvider<SyncStatus>((ref) async {
  return  const SyncStatus(isSyncing: false, pendingCount: 0);
});

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(HiveBoxes.queue, NoteRemoteDS());
});

class SyncStatus {
  final bool isSyncing;
  final int pendingCount;

  const SyncStatus({
    required this.isSyncing,
    required this.pendingCount,
  });
}