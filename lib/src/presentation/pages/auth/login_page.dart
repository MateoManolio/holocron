import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import 'widgets/auth_background.dart';
import 'widgets/auth_footer.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/hyperdrive_button.dart';
import 'widgets/hyperdrive_logo.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  void _onGuestPressed() {
    context.read<AuthBloc>().add(AuthGuestLoginRequested());
  }

  void _navigateToSignUp() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SignUpPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: Stack(
            children: [
              // Main content
              Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Logo
                            const Center(child: HyperdriveLogo()),
                            const SizedBox(height: 32),
                            // Title
                            const Text(
                              'HOLOCRON',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Subtitle
                            Text(
                              'SYSTEM ACCESS',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade500,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Instruction text
                            Text(
                              'Initialize Hyperspace Coordinates to proceed.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            const SizedBox(height: 40),
                            // Email field
                            CustomTextField(
                              controller: _emailController,
                              label: 'IDENTIFICATION (EMAIL)',
                              icon: Icons.email_outlined,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            // Password field
                            CustomTextField(
                              controller: _passwordController,
                              label: 'SECURITY CODE',
                              icon: Icons.lock_outline,
                              obscureText: _obscurePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.grey.shade500,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),
                            // Engage button
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                return HyperdriveButton(
                                  onPressed: _onLoginPressed,
                                  text: 'ENGAGE HYPERDRIVE',
                                  isLoading: state.isLoading,
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                            // Bottom links
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: TextButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Password reset coming soon',
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Reset Coordinates',
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 12,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: TextButton(
                                    onPressed: _onGuestPressed,
                                    child: const Text(
                                      'Guest Mode',
                                      style: TextStyle(
                                        color: Color(0xFF6B4FFF),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Sign up link
                            Center(
                              child: TextButton(
                                onPressed: _navigateToSignUp,
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 12,
                                    ),
                                    children: const [
                                      TextSpan(text: 'New pilot? '),
                                      TextSpan(
                                        text: 'Create Account',
                                        style: TextStyle(
                                          color: Color(0xFF6B4FFF),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Footer
              const AuthFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
