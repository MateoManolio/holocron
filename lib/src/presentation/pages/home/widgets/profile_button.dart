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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showProfileMenu(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final user = authState.user;

    // If guest, navigate to login instead of showing menu
    if (user?.isGuest == true) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const LoginPage()));
      return;
    }

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        MediaQuery.of(context).size.width - 200,
        70,
        20,
        0,
      ),
      color: AppTheme.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppTheme.holoBlue.withOpacity(0.3), width: 1),
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
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: const [
              Icon(Icons.logout, color: AppTheme.imperialYellow, size: 20),
              SizedBox(width: 8),
              Text('Logout', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'logout') {
        context.read<AuthBloc>().add(AuthLogoutRequested());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
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
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                shape: BoxShape.circle,
                border: Border.all(
                  color: user?.isGuest == true
                      ? AppTheme.imperialYellow.withOpacity(0.5)
                      : AppTheme.holoBlue.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        (user?.isGuest == true
                                ? AppTheme.imperialYellow
                                : AppTheme.holoBlue)
                            .withOpacity(0.2),
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

