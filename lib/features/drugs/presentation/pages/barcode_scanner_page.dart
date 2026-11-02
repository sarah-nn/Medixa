import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'drug_details_page.dart';
import '../bloc/medicine_lookup_bloc.dart';
import '../bloc/medicine_lookup_event.dart';
import '../bloc/medicine_lookup_state.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  final _controller = MobileScannerController();
  final _lookupBloc = GetIt.I<MedicineLookupBloc>();
  bool _handled = false;

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    String? barcode;
    for (final item in capture.barcodes) {
      final value = item.rawValue;
      if (value != null && value.isNotEmpty) {
        barcode = value;
        break;
      }
    }
    if (barcode == null || barcode.isEmpty) return;

    _handled = true;
    _controller.stop();
    final normalizedBarcode = barcode.trim();
    debugPrint('[BarcodeScanner] Scanned barcode: $normalizedBarcode');
    _lookupBloc.add(MedicineBarcodeScanned(normalizedBarcode));
  }

  @override
  void dispose() {
    _controller.dispose();
    _lookupBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider.value(
        value: _lookupBloc,
        child: BlocListener<MedicineLookupBloc, MedicineLookupState>(
          listener: (context, state) {
          if (state.status == MedicineLookupStatus.success &&
              state.medicine != null) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => DrugDetailsPage(
                  medicine: state.medicine!,
                  inventory: state.inventory,
                ),
              ),
            );
            return;
          }

          if (state.status == MedicineLookupStatus.empty ||
              state.status == MedicineLookupStatus.failure) {
            _handled = false;
            _controller.start();
            if (state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message!)),
              );
            }
          }
          },
          child: Scaffold(
          backgroundColor: const Color(0xFF171C1F),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'مسح باركود الدواء',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          body: BlocBuilder<MedicineLookupBloc, MedicineLookupState>(
            builder: (context, state) => Stack(
              fit: StackFit.expand,
              children: [
                MobileScanner(
                  controller: _controller,
                  onDetect: _onDetect,
                  errorBuilder: (context, error) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        _scannerErrorMessage(error),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 290,
                    height: 190,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFBAECEE),
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: 40,
                  child: Column(
                    children: [
                      const Text(
                        'وجّه الكاميرا نحو باركود الدواء',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.status == MedicineLookupStatus.loading
                            ? 'جاري تحميل بيانات الدواء...'
                            : 'سيتم فتح تفاصيل الدواء تلقائياً بعد التحقق',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                if (state.status == MedicineLookupStatus.loading)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
          ),
        ),
      ),
    );
  }

  String _scannerErrorMessage(MobileScannerException error) {
    if (error.errorCode == MobileScannerErrorCode.permissionDenied) {
      return 'تم رفض إذن الكاميرا. فعّل الكاميرا من إعدادات الجهاز ثم حاول مرة أخرى.';
    }
    return 'تعذر تشغيل الكاميرا. حاول مرة أخرى.';
  }
}
