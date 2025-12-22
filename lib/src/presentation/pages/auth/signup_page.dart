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

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignUpPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthSignUpRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
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
                              'PILOT REGISTRATION',
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
                              'Register your credentials to join the fleet.',
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
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
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
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            // Confirm Password field
                            CustomTextField(
                              controller: _confirmPasswordController,
                              label: 'CONFIRM SECURITY CODE',
                              icon: Icons.lock_outline,
                              obscureText: _obscureConfirmPassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.grey.shade500,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),
                            // Sign up button
                            BlocConsumer<AuthBloc, AuthState>(
                              listener: (context, state) {
                                if (state.status == AuthStatus.authenticated) {
                                  // Navigation handled by AuthWrapper
                                  Navigator.of(context).pop();
                                }
                              },
                              builder: (context, state) {
                                return HyperdriveButton(
                                  onPressed: _onSignUpPressed,
                                  text: 'REGISTER PILOT',
                                  isLoading: state.isLoading,
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                            // Back to login link
                            Center(
                              child: TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 12,
                                    ),
                                    children: const [
                                      TextSpan(text: 'Already registered? '),
                                      TextSpan(
                                        text: 'Sign In',
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

