import 'package:equatable/equatable.dart';

import '../../domain/entities/inventory.dart';
import '../../domain/entities/medicine.dart';

enum MedicineLookupStatus { initial, loading, success, empty, failure }

class MedicineLookupState extends Equatable {
  const MedicineLookupState({
    this.status = MedicineLookupStatus.initial,
    this.medicine,
    this.inventory,
    this.message,
  });

  final MedicineLookupStatus status;
  final Medicine? medicine;
  final Inventory? inventory;
  final String? message;

  MedicineLookupState copyWith({
    MedicineLookupStatus? status,
    Medicine? medicine,
    Inventory? inventory,
    String? message,
    bool clearData = false,
  }) => MedicineLookupState(
    status: status ?? this.status,
    medicine: clearData ? null : medicine ?? this.medicine,
    inventory: clearData ? null : inventory ?? this.inventory,
    message: message,
  );

  @override
  List<Object?> get props => [status, medicine, inventory, message];
}
