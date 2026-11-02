import 'package:equatable/equatable.dart';

sealed class MedicineLookupEvent extends Equatable {
  const MedicineLookupEvent();

  @override
  List<Object> get props => [];
}

final class MedicineBarcodeScanned extends MedicineLookupEvent {
  const MedicineBarcodeScanned(this.barcode);

  final String barcode;

  @override
  List<Object> get props => [barcode];
}
