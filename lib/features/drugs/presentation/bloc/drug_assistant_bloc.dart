import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../data/services/drug_assistant_service.dart';

class DrugAssistantMessage {
  const DrugAssistantMessage({required this.text, required this.isUser});
  final String text;
  final bool isUser;
}

class DrugAssistantState {
  const DrugAssistantState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });
  final List<DrugAssistantMessage> messages;
  final bool isLoading;
  final String? error;

  DrugAssistantState copyWith({
    List<DrugAssistantMessage>? messages,
    bool? isLoading,
    String? error,
  }) => DrugAssistantState(
    messages: messages ?? this.messages,
    isLoading: isLoading ?? this.isLoading,
    error: error,
  );
}

class DrugAssistantBloc extends Cubit<DrugAssistantState> {
  DrugAssistantBloc(this._service) : super(const DrugAssistantState());
  final DrugAssistantService _service;

  Future<void> ask(String value) async {
    final question = value.trim();
    if (question.isEmpty || state.isLoading) return;
    final messages = [
      ...state.messages,
      DrugAssistantMessage(text: question, isUser: true),
    ];
    emit(state.copyWith(messages: messages, isLoading: true, error: null));
    try {
      final answer = await _service.ask(
        question,
        messages
            .takeLast(6)
            .map(
              (item) => '${item.isUser ? 'USER' : 'ASSISTANT'}: ${item.text}',
            )
            .toList(),
      );
      emit(
        state.copyWith(
          messages: [
            ...messages,
            DrugAssistantMessage(text: answer, isUser: false),
          ],
          isLoading: false,
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('========== DRUG ASSISTANT ERROR ==========');
      debugPrint('Error: $error');
      debugPrint('StackTrace: $stackTrace');
      debugPrint('==========================================');

      emit(
        state.copyWith(
          isLoading: false,
          error: 'تعذر الاتصال بالمساعد الدوائي. حاول مرة أخرى.',
        ),
      );
    }
  }

  void clear() => emit(const DrugAssistantState());
}

extension<T> on List<T> {
  List<T> takeLast(int count) =>
      length <= count ? this : sublist(length - count);
}
