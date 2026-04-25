import 'package:ailoitte/sync_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'api_services.dart';
import '../utils/exports.dart';
import '../hive_boxes.dart';
import '../data/note_local_ds.dart';
import '../data/note_remote_ds.dart';
import 'note_repository.dart';
import 'notes_notifier.dart';


final apiServiceProvider = Provider<ApiService>((ref) => ApiService());
final titleNameControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final contentNameControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return NoteRepository(NoteLocalDS(HiveBoxes.notes), SyncService(HiveBoxes.queue, NoteRemoteDS()));
});

final notesProvider = StateNotifierProvider<NotesNotifier, NotesState>((ref) {
  final repo = ref.read(noteRepositoryProvider);
  return NotesNotifier(repo);
});