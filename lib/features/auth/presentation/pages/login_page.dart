import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocListener<AuthBloc, AuthState>(
          listenWhen: (previous, current) =>
              previous.status != current.status ||
              previous.message != current.message,
          listener: (context, state) {
            if (state.status == AuthStatus.failure && state.message != null) {
              context.showMessage(state.message!);
              return;
            }

            if (state.status == AuthStatus.authenticated) {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(AppRouter.home, (route) => false);
            }
          },
          child: Stack(
            children: [
              Positioned(
                top: -130,
                left: -120,
                child: _Bubble(size: 320, color: const Color(0xFFDCEFEF)),
              ),
              Positioned(
                bottom: -150,
                right: -80,
                child: _Bubble(size: 350, color: const Color(0xFFEAE3ED)),
              ),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          final isLoading = state.status == AuthStatus.loading;

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                child: SizedBox(
                                  width: 408,
                                  height: 198,
                                  child: Image.asset(
                                    AppImaages.logo,
                                    fit: BoxFit.cover,
                                  ),
                                  // child: CustomPaint(
                                  //   painter: _BrandMarkPainter(),
                                  // ),
                                ),
                              ),
                              // const Center(
                              //   child: Text(
                              //     'Medixa',
                              //     style: TextStyle(
                              //       fontSize: 40,
                              //       fontWeight: FontWeight.w800,
                              //       color: AppColors.text,
                              //     ),
                              //   ),
                              // ),
                              // const SizedBox(height: 22),
                              // const Text(
                              //   'أهلاً بك مجدداً',
                              //   textAlign: TextAlign.center,
                              //   style: AppTextStyles.title,
                              // ),
                              // const SizedBox(height: 8),
                              // const Text(
                              //   'تسجيل الدخول',
                              //   textAlign: TextAlign.center,
                              //   style: AppTextStyles.subtitle,
                              // ),
                              // const SizedBox(height: 12),
                              // const Text(
                              //   'أدخل بياناتك للوصول إلى حسابك',
                              //   textAlign: TextAlign.center,
                              //   style: AppTextStyles.body,
                              // ),
                              const SizedBox(height: 28),
                              LoginForm(
                                loading: isLoading,
                                onSubmit: (email, password) {
                                  context.read<AuthBloc>().add(
                                    LoginSubmitted(
                                      email: email,
                                      password: password,
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
