import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  // FocusNodes allow programmatic focus control — important for autofill
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _isRegisterMode = false;
  bool _isSubmitting = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  String? _authError;

  // Max width matches firebase_ui_auth's centered card layout
  static const double _maxFormWidth = 400;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = (value ?? '').trim();
    if (email.isEmpty) return 'Email is required';
    if (!email.contains('@') ||
        email.startsWith('@') ||
        email.endsWith('@')) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Password is required';
    if (_isRegisterMode && password.length < 8) {
      return 'Use at least 8 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (!_isRegisterMode) return null;
    if ((value ?? '').isEmpty) return 'Please confirm your password';
    if (value != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || _isSubmitting) return;

    // Dismiss keyboard before submitting
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

      // Tell the autofill system to save these credentials
      // This is what prompts the browser/password manager to offer to save
      TextInput.finishAutofillContext(shouldSave: true);
    } on FirebaseAuthException catch (e) {
      setState(() => _authError = _mapAuthError(e.code));
    } catch (_) {
      setState(() => _authError = 'Authentication failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String _mapAuthError(String code) {
    return switch (code) {
      'invalid-email'     => 'Enter a valid email address.',
      'user-disabled'     => 'This account has been disabled.',
      'user-not-found' ||
      'wrong-password' ||
      'invalid-credential' => 'Incorrect email or password.',
      'email-already-in-use' => 'An account with this email already exists.',
      'weak-password'     => 'Choose a stronger password.',
      'too-many-requests' => 'Too many attempts. Please try again later.',
      _                   => 'Authentication failed. Please try again.',
    };
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _authError = 'Enter your email first to reset password.');
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent.')),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _authError = _mapAuthError(e.code));
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
            colors: [
              theme.scaffoldBackgroundColor,
              colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(  // ← centres everything horizontally
            child: SingleChildScrollView(
              child: ConstrainedBox(
                // ← limits width to match firebase_ui_auth card layout
                constraints: const BoxConstraints(maxWidth: _maxFormWidth),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'QuestLog',
                        style: theme.textTheme.displayLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isRegisterMode
                            ? 'Create your account to start tracking quests.'
                            : 'Sign in to continue your progression.',
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),

                      // AutofillGroup must wrap ALL fields together
                      // This tells the browser/password manager they are related
                      AutofillGroup(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [

                              // Email field
                              // autofillHints tells Bitwarden what type of
                              // data this field expects
                              TextFormField(
                                controller: _emailController,
                                focusNode: _emailFocusNode,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [
                                  AutofillHints.username,
                                  AutofillHints.email,
                                ],
                                autocorrect: false,
                                enableSuggestions: false,
                                onFieldSubmitted: (_) => FocusScope.of(context)
                                    .requestFocus(_passwordFocusNode),
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                ),
                                validator: _validateEmail,
                              ),
                              const SizedBox(height: 12),

                              // Password field
                              // newPassword vs password hint matters —
                              // password managers use newPassword to know
                              // they should generate/save a new credential
                              // rather than fill an existing one
                              TextFormField(
                                controller: _passwordController,
                                focusNode: _passwordFocusNode,
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
                                  if (_isRegisterMode) {
                                    FocusScope.of(context).requestFocus(
                                      _confirmPasswordFocusNode,
                                    );
                                  } else {
                                    _submit();
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: _isRegisterMode
                                      ? 'Create password'
                                      : 'Password',
                                  suffixIcon: IconButton(
                                    onPressed: () => setState(
                                      () => _showPassword = !_showPassword,
                                    ),
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
                                  focusNode: _confirmPasswordFocusNode,
                                  textInputAction: TextInputAction.done,
                                  // Same newPassword hint — tells the password
                                  // manager this is the confirmation field
                                  autofillHints: const [
                                    AutofillHints.newPassword,
                                  ],
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  obscureText: !_showConfirmPassword,
                                  onFieldSubmitted: (_) => _submit(),
                                  decoration: InputDecoration(
                                    labelText: 'Confirm password',
                                    suffixIcon: IconButton(
                                      onPressed: () => setState(
                                        () => _showConfirmPassword =
                                            !_showConfirmPassword,
                                      ),
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
                            ],
                          ),
                        ),
                      ),

                      if (!_isRegisterMode)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _isSubmitting ? null : _resetPassword,
                            child: const Text('Forgot password?'),
                          ),
                        ),

                      const SizedBox(height: 4),

                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
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
                      ),
                      const SizedBox(height: 8),

                      TextButton(
                        onPressed: _isSubmitting
                            ? null
                            : () => setState(() {
                                  _isRegisterMode = !_isRegisterMode;
                                  _authError = null;
                                }),
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
        ),
      ),
    );
  }
}