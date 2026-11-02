import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/note_repository.dart';
import 'note_state.dart';

class NoteBloc extends Cubit<NoteState> {
  NoteBloc(this._repository, this._auth) : super(const NoteState());

  final NoteRepository _repository;
  final FirebaseAuth _auth;

  Future<void> load() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null || userId.isEmpty) {
      emit(
        state.copyWith(
          status: NoteStatus.failure,
          message: 'يجب تسجيل الدخول أولاً لعرض الملاحظات.',
        ),
      );
      return;
    }

    emit(state.copyWith(status: NoteStatus.loading, clearMessage: true));
    try {
      final notes = await _repository.getForUser(userId);
      emit(
        state.copyWith(
          status: NoteStatus.success,
          notes: notes,
          isSaving: false,
        ),
      );
    } on FirebaseException catch (error, stackTrace) {
      _log(error, stackTrace);
      emit(
        state.copyWith(
          status: NoteStatus.failure,
          message: _firebaseMessage(error),
        ),
      );
    } catch (error, stackTrace) {
      _log(error, stackTrace);
      emit(
        state.copyWith(
          status: NoteStatus.failure,
          message: 'تعذر تحميل الملاحظات. تحقق من الإنترنت وحاول مرة أخرى.',
        ),
      );
    }
  }

  Future<bool> save({
    String? id,
    required String title,
    required String content,
  }) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null || userId.isEmpty) {
      emit(state.copyWith(message: 'يجب تسجيل الدخول أولاً لحفظ الملاحظة.'));
      return false;
    }
    emit(state.copyWith(isSaving: true, clearMessage: true));
    try {
      if (id == null) {
        await _repository.create(
          userId: userId,
          title: title,
          content: content,
        );
      } else {
        await _repository.update(id: id, title: title, content: content);
      }
      await load();
      return true;
    } on FirebaseException catch (error, stackTrace) {
      _log(error, stackTrace);
      emit(
        state.copyWith(
          isSaving: false,
          status: NoteStatus.failure,
          message: _firebaseMessage(error),
        ),
      );
      return false;
    } catch (error, stackTrace) {
      _log(error, stackTrace);
      emit(
        state.copyWith(
          isSaving: false,
          status: NoteStatus.failure,
          message: 'تعذر حفظ الملاحظة. حاول مرة أخرى.',
        ),
      );
      return false;
    }
  }

  Future<bool> remove(String id) async {
    try {
      await _repository.delete(id);
      emit(
        state.copyWith(
          notes: state.notes.where((note) => note.id != id).toList(),
          clearMessage: true,
        ),
      );
      return true;
    } on FirebaseException catch (error, stackTrace) {
      _log(error, stackTrace);
      emit(state.copyWith(message: _firebaseMessage(error)));
      return false;
    } catch (error, stackTrace) {
      _log(error, stackTrace);
      emit(state.copyWith(message: 'تعذر حذف الملاحظة. حاول مرة أخرى.'));
      return false;
    }
  }

  static void _log(Object error, StackTrace stackTrace) {
    debugPrint('[Notes] $error');
    debugPrintStack(stackTrace: stackTrace);
  }

  String _firebaseMessage(FirebaseException error) {
    if (error.code == 'permission-denied') {
      return 'لا تملك صلاحية الوصول إلى هذه الملاحظات.';
    }
    if (error.code == 'failed-precondition') {
      return 'إعدادات قاعدة البيانات لا تسمح بجلب الملاحظات حالياً.';
    }
    if (error.code == 'unavailable' || error.code == 'network-request-failed') {
      return 'تعذر الاتصال. تحقق من الإنترنت وحاول مرة أخرى.';
    }
    return 'حدث خطأ أثناء تنفيذ العملية. حاول مرة أخرى.';
  }
}
