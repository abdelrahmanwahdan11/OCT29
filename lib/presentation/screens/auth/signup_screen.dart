import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../application/controllers/auth_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key, required this.authController});

  final AuthController authController;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: widget.authController.signupFormKey,
            child: ListView(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(IconlyBold.profile),
                  ),
                  onSaved: (value) => widget.authController.signupName = value ?? '',
                  validator: widget.authController.validateName,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(IconlyBold.message),
                  ),
                  onSaved: (value) => widget.authController.signupEmail = value ?? '',
                  validator: widget.authController.validateEmail,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    prefixIcon: Icon(IconlyBold.call),
                  ),
                  keyboardType: TextInputType.phone,
                  onSaved: (value) => widget.authController.signupPhone = value ?? '',
                  validator: widget.authController.validatePhone,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(IconlyBold.lock),
                  ),
                  obscureText: true,
                  onSaved: (value) => widget.authController.signupPassword = value ?? '',
                  validator: widget.authController.validateSignupPassword,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Confirm password',
                    prefixIcon: Icon(IconlyBold.lock),
                  ),
                  obscureText: true,
                  onSaved: (value) => widget.authController.signupConfirmPassword = value ?? '',
                  validator: widget.authController.validateConfirmPassword,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _loading
                      ? null
                      : () async {
                          final form = widget.authController.signupFormKey.currentState;
                          if (form != null && form.validate()) {
                            form.save();
                            setState(() => _loading = true);
                            await widget.authController.signup();
                            if (!mounted) return;
                            Navigator.of(context).pop();
                          }
                          setState(() => _loading = false);
                        },
                  child: _loading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Sign up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
