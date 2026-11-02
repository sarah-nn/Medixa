import 'package:equatable/equatable.dart';

import '../../domain/entities/note.dart';

enum NoteStatus { initial, loading, success, failure }

class NoteState extends Equatable {
  const NoteState({
    this.status = NoteStatus.initial,
    this.notes = const [],
    this.message,
    this.isSaving = false,
  });

  final NoteStatus status;
  final List<Note> notes;
  final String? message;
  final bool isSaving;

  NoteState copyWith({
    NoteStatus? status,
    List<Note>? notes,
    String? message,
    bool clearMessage = false,
    bool? isSaving,
  }) => NoteState(
    status: status ?? this.status,
    notes: notes ?? this.notes,
    message: clearMessage ? null : message ?? this.message,
    isSaving: isSaving ?? this.isSaving,
  );

  @override
  List<Object?> get props => [status, notes, message, isSaving];
}
