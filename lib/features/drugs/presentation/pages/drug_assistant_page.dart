import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../app/theme/app_colors.dart';
import '../bloc/drug_assistant_bloc.dart';

class DrugAssistantPage extends StatefulWidget {
  const DrugAssistantPage({super.key});

  @override
  State<DrugAssistantPage> createState() => _DrugAssistantPageState();
}

class _DrugAssistantPageState extends State<DrugAssistantPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send(DrugAssistantBloc bloc) {
    final text = _controller.text;
    _controller.clear();
    bloc.ask(text);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (_) => GetIt.I<DrugAssistantBloc>(),
        child: Scaffold(
          backgroundColor: const Color(0xFFF3F7F9),
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.text,
            elevation: 0,
            title: const Text(
              'المساعد الدوائي',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            // actions: [
            //   IconButton(
            //     tooltip: 'محادثة جديدة',
            //     onPressed: () => context.read<DrugAssistantBloc>().clear(),
            //     icon: const Icon(Icons.refresh_rounded),
            //   ),
            // ],
          ),
          body: BlocConsumer<DrugAssistantBloc, DrugAssistantState>(
            listener: (_, state) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                  );
                }
              });
            },
            builder: (context, state) {
              final bloc = context.read<DrugAssistantBloc>();
              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      children: [
                        _intro(),
                        if (state.messages.isEmpty) _suggestions(bloc),
                        ...state.messages.map(_messageBubble),
                        if (state.isLoading)
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        if (state.error != null) _errorBubble(state.error!),
                      ],
                    ),
                  ),
                  _composer(bloc, state.isLoading),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _intro() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFEAF5F4),
      borderRadius: BorderRadius.circular(20),
    ),
    child: const Text(
      'مرحباً! أنا المساعد الدوائي في MediXa.\n\n'
      'فيني ساعدك بالاستفسار عن الأدوية المسجلة بقاعدة بيانات الصيدلية. '
      'اسألني عن دواء موجود بقاعدة البيانات.',
      style: TextStyle(color: AppColors.text, height: 1.6, fontSize: 14),
    ),
  );

  Widget _suggestions(DrugAssistantBloc bloc) => Padding(
    padding: const EdgeInsets.only(top: 14),
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          [
                'ما المادة الفعالة في Augmentin؟',
                'شو التحذيرات الخاصة بـ Brufen؟',
                'كم سعر Augmentin عندي بالصيدلية؟',
              ]
              .map(
                (text) => ActionChip(
                  label: Text(text),
                  onPressed: () => bloc.ask(text),
                  backgroundColor: Colors.white,
                ),
              )
              .toList(),
    ),
  );

  Widget _messageBubble(DrugAssistantMessage message) => Align(
    alignment: message.isUser
        ? AlignmentDirectional.centerStart
        : AlignmentDirectional.centerEnd,
    child: Container(
      constraints: const BoxConstraints(maxWidth: 340),
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: message.isUser ? const Color(0xFF5A3C62) : Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        message.text,
        style: TextStyle(
          color: message.isUser ? Colors.white : AppColors.text,
          height: 1.5,
          fontSize: 14,
        ),
      ),
    ),
  );

  Widget _errorBubble(String text) =>
      _messageBubble(DrugAssistantMessage(text: text, isUser: false));

  Widget _composer(DrugAssistantBloc bloc, bool loading) => SafeArea(
    top: false,
    child: Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: !loading,
              textDirection: TextDirection.rtl,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'اكتب سؤالك عن دواء...',
                filled: true,
                fillColor: const Color(0xFFF0F4F7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _send(bloc),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: loading ? null : () => _send(bloc),
            icon: const Icon(Icons.send_rounded),
          ),
        ],
      ),
    ),
  );
}
