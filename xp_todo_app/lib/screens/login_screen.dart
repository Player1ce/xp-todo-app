import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:xp_todo_app/const/route_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isRegisterMode = false;
  bool _isSubmitting = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  String? _authError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = (value ?? '').trim();
    if (email.isEmpty) {
      return 'Email is required';
    }
    if (!email.contains('@') || email.startsWith('@') || email.endsWith('@')) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) {
      return 'Password is required';
    }
    if (_isRegisterMode && password.length < 8) {
      return 'Use at least 8 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (!_isRegisterMode) {
      return null;
    }
    if ((value ?? '').isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || _isSubmitting) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {
      _isSubmitting = true;
      _authError = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      if (_isRegisterMode) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      TextInput.finishAutofillContext(shouldSave: true);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _authError = _mapAuthError(e.code);
      });
    } catch (_) {
      setState(() {
        _authError = 'Authentication failed. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  String _mapAuthError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return 'Choose a stronger password.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _authError = 'Enter your email first to reset password.';
      });
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent.')),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _authError = _mapAuthError(e.code);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [theme.scaffoldBackgroundColor, colorScheme.surface],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('QuestLog', style: theme.textTheme.displayLarge),
                    const SizedBox(height: 4),
                    Text(
                      _isRegisterMode
                          ? 'Create your account to start tracking quests.'
                          : 'Sign in to continue your progression.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 6, 24, 12),
                  child: AutofillGroup(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            _isRegisterMode
                                ? 'Create account'
                                : 'Use email + password to enter your quest log.',
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [
                              AutofillHints.username,
                              AutofillHints.email,
                            ],
                            autocorrect: false,
                            enableSuggestions: false,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                            validator: _validateEmail,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _passwordController,
                            textInputAction: _isRegisterMode
                                ? TextInputAction.next
                                : TextInputAction.done,
                            autofillHints: _isRegisterMode
                                ? const [AutofillHints.newPassword]
                                : const [AutofillHints.password],
                            autocorrect: false,
                            enableSuggestions: false,
                            obscureText: !_showPassword,
                            onFieldSubmitted: (_) {
                              if (!_isRegisterMode) {
                                _submit();
                              }
                            },
                            decoration: InputDecoration(
                              labelText: _isRegisterMode
                                  ? 'Create password'
                                  : 'Password',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                },
                                icon: Icon(
                                  _showPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                            ),
                            validator: _validatePassword,
                          ),
                          if (_isRegisterMode) ...[
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _confirmPasswordController,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.newPassword],
                              autocorrect: false,
                              enableSuggestions: false,
                              obscureText: !_showConfirmPassword,
                              onFieldSubmitted: (_) => _submit(),
                              decoration: InputDecoration(
                                labelText: 'Confirm password',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _showConfirmPassword =
                                          !_showConfirmPassword;
                                    });
                                  },
                                  icon: Icon(
                                    _showConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                ),
                              ),
                              validator: _validateConfirmPassword,
                            ),
                          ],
                          if (!_isRegisterMode)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: _isSubmitting
                                    ? null
                                    : _resetPassword,
                                child: const Text('Forgot password?'),
                              ),
                            ),
                          const SizedBox(height: 4),
                          FilledButton(
                            onPressed: _isSubmitting ? null : _submit,
                            child: _isSubmitting
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    _isRegisterMode
                                        ? 'Create Account'
                                        : 'Sign In',
                                  ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _isSubmitting
                                ? null
                                : () {
                                    setState(() {
                                      _isRegisterMode = !_isRegisterMode;
                                      _authError = null;
                                    });
                                  },
                            child: Text(
                              _isRegisterMode
                                  ? 'Already have an account? Sign in'
                                  : 'Need an account? Create one',
                            ),
                          ),
                          if (_authError != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              _authError!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
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
