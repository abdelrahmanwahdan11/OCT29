import 'package:flutter/material.dart';

import '../../shared/controllers/app_scope.dart';
import '../../shared/controllers/auth_controller.dart';
import '../../shared/ui_kit/glass_card.dart';
import '../../shared/ui_kit/pill_button.dart';

class AuthFlow extends StatefulWidget {
  const AuthFlow({super.key, required this.onAuthenticated});

  final void Function(BuildContext context) onAuthenticated;

  @override
  State<AuthFlow> createState() => _AuthFlowState();
}

class _AuthFlowState extends State<AuthFlow> {
  AuthController? authController;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool isLogin = true;
  bool rememberMe = false;
  bool showPassword = false;
  String? error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authController ??= InheritedAppScope.of(context).authController
      ..addListener(_handleAuthChanged);
    rememberMe = authController!.rememberMe;
  }

  void _handleAuthChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    authController?.removeListener(_handleAuthChanged);
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final auth = authController!;
    try {
      if (isLogin) {
        await auth.login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          rememberMe: rememberMe,
        );
      } else {
        await auth.signup(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      }
      widget.onAuthenticated(context);
    } on AuthException catch (ex) {
      setState(() => error = ex.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = authController;
    if (auth == null) {
      return const SizedBox.shrink();
    }
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isLogin ? 'تسجيل الدخول' : 'إنشاء حساب',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isLogin) ...[
                          TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(labelText: 'الاسم الكامل'),
                          ),
                          const SizedBox(height: 16),
                        ],
                        TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'كلمة المرور',
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => showPassword = !showPassword),
                              icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility),
                            ),
                          ),
                          obscureText: !showPassword,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              onChanged: (value) {
                                setState(() => rememberMe = value ?? false);
                                auth.setRememberMe(value ?? false);
                              },
                            ),
                            const Text('تذكرني'),
                          ],
                        ),
                        if (error != null) ...[
                          const SizedBox(height: 8),
                          Text(error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                        ],
                        const SizedBox(height: 16),
                        PillButton(label: isLogin ? 'دخول' : 'تسجيل', onPressed: _submit),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => setState(() => isLogin = !isLogin),
                          child: Text(isLogin ? 'لا تملك حساب؟ أنشئ واحداً' : 'لديك حساب؟ سجل دخول'),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {},
                          child: const Text('نسيت كلمة المرور؟'),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'أو تابع كضيف',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        PillButton(
                          label: 'تصفح كضيف',
                          onPressed: () => auth.continueAsGuest().then((_) => widget.onAuthenticated(context)),
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
    );
  }
}
