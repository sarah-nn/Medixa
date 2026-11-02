import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/medicine_repository.dart';
import 'medicine_lookup_event.dart';
import 'medicine_lookup_state.dart';

class MedicineLookupBloc
    extends Bloc<MedicineLookupEvent, MedicineLookupState> {
  MedicineLookupBloc(this._repository, this._auth)
    : super(const MedicineLookupState()) {
    on<MedicineBarcodeScanned>(_onBarcodeScanned);
  }

  final MedicineRepository _repository;
  final FirebaseAuth _auth;

  Future<void> _onBarcodeScanned(
    MedicineBarcodeScanned event,
    Emitter<MedicineLookupState> emit,
  ) async {
    final barcode = event.barcode.trim();
    if (barcode.isEmpty) {
      emit(
        state.copyWith(
          status: MedicineLookupStatus.failure,
          message: 'تعذر قراءة الباركود. حاول مرة أخرى.',
          clearData: true,
        ),
      );
      return;
    }

    final userId = _auth.currentUser?.uid;
    if (userId == null || userId.isEmpty) {
      emit(
        state.copyWith(
          status: MedicineLookupStatus.failure,
          message: 'يجب تسجيل الدخول أولاً للبحث عن الدواء.',
          clearData: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: MedicineLookupStatus.loading,
        message: null,
        clearData: true,
      ),
    );

    try {
      final medicine = await _repository.getByBarcode(barcode);
      if (medicine == null) {
        emit(
          state.copyWith(
            status: MedicineLookupStatus.empty,
            message: 'لم يتم العثور على دواء بهذا الباركود.',
            clearData: true,
          ),
        );
        return;
      }

      final inventory = await _repository.getInventoryForMedicine(
        medicineId: medicine.id,
        userId: userId,
      );
      emit(
        state.copyWith(
          status: MedicineLookupStatus.success,
          medicine: medicine,
          inventory: inventory,
          message: inventory == null
              ? 'تم العثور على الدواء، ولا توجد بيانات مخزون لهذا الصيدلي.'
              : null,
        ),
      );
    } on FirebaseException catch (error) {
      debugPrint(
        '[MedicineLookup] FirebaseException '
        'code=${error.code}, message=${error.message}',
      );
      emit(
        state.copyWith(
          status: MedicineLookupStatus.failure,
          message: _firebaseMessage(error),
          clearData: true,
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('[MedicineLookup] Unexpected error: $error');
      debugPrintStack(stackTrace: stackTrace);
      emit(
        state.copyWith(
          status: MedicineLookupStatus.failure,
          message: 'تعذر الاتصال ببيانات الأدوية. تحقق من الإنترنت وحاول مرة أخرى.',
          clearData: true,
        ),
      );
    }
  }

  String _firebaseMessage(FirebaseException error) {
    if (error.code == 'permission-denied') {
      return 'لا تملك صلاحية الوصول إلى بيانات هذا الدواء.';
    }
    if (error.code == 'unavailable' || error.code == 'network-request-failed') {
      return 'تعذر الاتصال ببيانات الأدوية. تحقق من الإنترنت وحاول مرة أخرى.';
    }
    return 'حدث خطأ أثناء تحميل بيانات الدواء.';
  }
}
