import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../models/note_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  NoteRepositoryImpl(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _notes =>
      _firestore.collection('notes');

  @override
  Future<List<Note>> getForUser(String userId) async {
    final result = await _notes.where('userId', isEqualTo: userId).get();
    final notes = result.docs
        .map((document) => NoteModel.fromFirestore(document).toEntity())
        .toList();
    notes.sort((a, b) {
      final aDate = a.updatedAt ?? a.createdAt;
      final bDate = b.updatedAt ?? b.createdAt;
      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;
      return bDate.compareTo(aDate);
    });
    return List.unmodifiable(notes);
  }

  @override
  Future<void> create({
    required String userId,
    required String title,
    required String content,
  }) async {
    final now = FieldValue.serverTimestamp();
    await _notes.add({
      'title': title,
      'content': content,
      'userId': userId,
      'createdAt': now,
      'updatedAt': now,
    });
  }

  @override
  Future<void> update({
    required String id,
    required String title,
    required String content,
  }) {
    return _notes.doc(id).update({
      'title': title,
      'content': content,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> delete(String id) => _notes.doc(id).delete();
}
