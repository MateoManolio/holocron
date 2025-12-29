import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/auth/auth_event.dart';
import '../../../bloc/auth/auth_state.dart';
import '../../auth/login_page.dart';
import '../../../../config/theme/app_theme.dart';

class ProfileButton extends StatefulWidget {
  const ProfileButton({super.key});

  @override
  State<ProfileButton> createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  static const double _initialScale = 1.0;
  static const double _hoverScale = 1.1;
  static const int _animDurationMs = 150;
  static const double _buttonSize = 45.0;
  static const double _menuWidth = 200.0;
  static const double _menuOffsetTop = 70.0;
  static const double _menuOffsetRight = 20.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: _animDurationMs),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: _initialScale,
      end: _hoverScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showProfileMenu(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final user = authBloc.state.user;

    if (user?.isGuest == true) {
      authBloc.add(const AuthNavigateToLoginRequested());
      return;
    }

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        MediaQuery.of(context).size.width - _menuWidth,
        _menuOffsetTop,
        _menuOffsetRight,
        0,
      ),
      color: AppTheme.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppTheme.holoBlue.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      items: [
        PopupMenuItem<String>(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'User',
                style: TextStyle(
                  color: AppTheme.holoBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (user?.email != null)
                Text(
                  user!.email!,
                  style: const TextStyle(
                    color: AppTheme.lightGray,
                    fontSize: 12,
                  ),
                ),
              const Divider(color: AppTheme.holoBlue),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, color: AppTheme.imperialYellow, size: 20),
              SizedBox(width: 8),
              Text('Logout', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (context.mounted && value == 'logout') {
        authBloc.add(const AuthLogoutRequested());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.navigationTarget == AuthNavigationTarget.login) {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const LoginPage()));
        }
      },
      builder: (context, state) {
        final user = state.user;
        return GestureDetector(
          onTapDown: (_) => _controller.forward(),
          onTapUp: (_) => _controller.reverse(),
          onTapCancel: () => _controller.reverse(),
          onTap: () => _showProfileMenu(context),
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: _buttonSize,
              height: _buttonSize,
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                shape: BoxShape.circle,
                border: Border.all(
                  color: user?.isGuest == true
                      ? AppTheme.imperialYellow.withValues(alpha: 0.5)
                      : AppTheme.holoBlue.withValues(alpha: 0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        (user?.isGuest == true
                                ? AppTheme.imperialYellow
                                : AppTheme.holoBlue)
                            .withValues(alpha: 0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                user?.isGuest == true ? Icons.login : Icons.person_outline,
                color: user?.isGuest == true
                    ? AppTheme.imperialYellow
                    : AppTheme.holoBlue,
                size: 24,
              ),
            ),
          ),
        );
      },
    );
  }
}
