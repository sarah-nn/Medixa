import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          Navigator.of(context).pushReplacementNamed(AppRouter.home);
          return;
        }

        if (state.status == AuthStatus.unauthenticated ||
            state.status == AuthStatus.failure) {
          Navigator.of(context).pushReplacementNamed(AppRouter.login);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: -120,
              left: -120,
              child: _Bubble(size: 300, color: const Color(0xFFDDECE9)),
            ),
            Positioned(
              bottom: -160,
              right: -160,
              child: _Bubble(size: 360, color: const Color(0xFFE5E1EB)),
            ),
            Center(
              child: Container(
                width: 326,
                height: 326,
                decoration: const BoxDecoration(
                  color: Color(0xFFF7F7F7),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x1F6A6A6A),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 408,
                      height: 198,
                      child: Image.asset(AppImaages.logo, fit: BoxFit.cover),
                    ),
                    // const SizedBox(height: 18),
                    // const Text(
                    //   'Medixa',
                    //   textDirection: TextDirection.rtl,
                    //   style: TextStyle(
                    //     fontSize: 54,
                    //     fontWeight: FontWeight.w700,
                    //     color: AppColors.text,
                    //     letterSpacing: -1.8,
                    //   ),
                    // ),
                    // const SizedBox(height: 18),
                    const Text(
                      'كل ما تحتاجه في مساحة واحدة',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => Container(
                          width: 10,
                          height: 10,
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: index == 1
                                ? AppColors.primary
                                : AppColors.softPurple,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Positioned(
            //   bottom: 32,
            //   left: 0,
            //   right: 0,
            //   child: Center(
            //     child: Text(
            //       'تجربة استكشاف',
            //       textDirection: TextDirection.rtl,
            //       style: TextStyle(
            //         fontSize: 16,
            //         color: AppColors.muted.withValues(alpha: 0.9),
            //         fontWeight: FontWeight.w500,
            //       ),
            //     ),
            //   ),
            // ),
          ],
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

// class _BrandMarkPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final teal = const Color(0xFF2B9AA6);
//     final purple = const Color(0xFF5B3A70);
//     final darkPurple = const Color(0xFF3B2C4F);

//     final left = size.width * 0.28;
//     final right = size.width * 0.72;
//     final top = size.height * 0.18;
//     final bottom = size.height * 0.75;

//     final paintA = Paint()
//       ..color = teal
//       ..style = PaintingStyle.fill;
//     final paintB = Paint()
//       ..color = purple
//       ..style = PaintingStyle.fill;
//     final paintC = Paint()
//       ..color = darkPurple
//       ..style = PaintingStyle.fill;

//     final pathA = Path()
//       ..moveTo(left, top)
//       ..lineTo(right, top)
//       ..quadraticBezierTo(right + 18, top + 26, right, top + 48)
//       ..lineTo(right, bottom)
//       ..quadraticBezierTo(left + 14, bottom - 10, left, bottom)
//       ..lineTo(left, top)
//       ..close();

//     final pathB = Path()
//       ..moveTo(left + 10, top + 8)
//       ..lineTo(right - 4, top + 8)
//       ..quadraticBezierTo(right - 2, top + 20, right - 8, top + 40)
//       ..lineTo(right - 16, bottom - 14)
//       ..quadraticBezierTo(left + 20, bottom - 24, left + 6, bottom - 10)
//       ..lineTo(left + 10, top + 8)
//       ..close();

//     final pathC = Path()
//       ..moveTo(left + 22, top + 20)
//       ..lineTo(left + 74, top + 20)
//       ..lineTo(left + 74, bottom - 28)
//       ..quadraticBezierTo(left + 58, bottom - 10, left + 36, bottom - 32)
//       ..lineTo(left + 22, top + 20)
//       ..close();

//     canvas.drawPath(pathA, paintA);
//     canvas.drawPath(pathB, paintB);
//     canvas.drawPath(pathC, paintC);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
