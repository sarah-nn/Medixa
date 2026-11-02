import '../entities/note.dart';

abstract interface class NoteRepository {
  Future<List<Note>> getForUser(String userId);
  Future<void> create({
    required String userId,
    required String title,
    required String content,
  });
  Future<void> update({
    required String id,
    required String title,
    required String content,
  });
  Future<void> delete(String id);
}
