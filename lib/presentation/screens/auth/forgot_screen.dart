import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../application/controllers/auth_controller.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key, required this.authController});

  final AuthController authController;

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset password')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: widget.authController.forgotFormKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email or phone',
                    prefixIcon: Icon(IconlyBold.message),
                  ),
                  onSaved: (value) => widget.authController.forgotEmailOrPhone = value ?? '',
                  validator: widget.authController.validateEmailOrPhone,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _sending
                      ? null
                      : () async {
                          final form = widget.authController.forgotFormKey.currentState;
                          if (form != null && form.validate()) {
                            form.save();
                            setState(() => _sending = true);
                            await widget.authController.sendForgotPassword();
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('We sent a reset link to your inbox.')),
                            );
                            Navigator.of(context).pop();
                          }
                          setState(() => _sending = false);
                        },
                  child: _sending
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Send reset link'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
