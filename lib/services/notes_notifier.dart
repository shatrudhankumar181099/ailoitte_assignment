import 'package:flutter_riverpod/legacy.dart';

import '../model/note_model.dart';
import 'note_repository.dart';

class NotesNotifier extends StateNotifier<NotesState> {
  final NoteRepository repository;

  NotesNotifier(this.repository) : super(NotesState.initial()) {
    loadNotes();
  }

  Future<void> loadNotes() async {
    state = state.copyWith(isLoading: true);
    try {
      final notes = repository.getNotes();
      state = state.copyWith(notes: notes, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load notes: ${e.toString()}',
      );
    }
  }

  Future<void> addNote(String title, String content) async {
    state = state.copyWith(isLoading: true);
    try {
      await repository.addNote(title: title, content: content);
      final notes = repository.getNotes();
      state = state.copyWith(notes: notes, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to add note: ${e.toString()}',
      );
    }
  }

  Future<void> toggleLike(String id) async {
    try {
      await repository.toggleLike(id);
      await loadNotes();
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update note: ${e.toString()}',
      );
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await repository.deleteNote(id);
      await loadNotes();
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to delete note: ${e.toString()}',
      );
    }
  }
  void clearError() {
    state = state.copyWith(error: null);
  }
}


class NotesState {
  final List<Note> notes;
  final bool isLoading;
  final String? error;

  NotesState({
    required this.notes,
    required this.isLoading,
    this.error,
  });

  factory NotesState.initial() => NotesState(notes: [], isLoading: false, );

  NotesState copyWith({
    List<Note>? notes,
    bool? isLoading,
    String? error,
  }) {
    return NotesState(
      notes: notes ?? this.notes,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

