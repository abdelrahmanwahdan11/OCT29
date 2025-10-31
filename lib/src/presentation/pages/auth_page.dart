import 'package:flutter/material.dart';

import '../../application/controllers/app_controllers.dart';
import '../../core/localization/app_localizations.dart';
import '../components/eink_scaffold.dart';
import '../components/primary_button.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, required this.controllers});

  final AppControllerRegistry controllers;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.controllers.authController.login(_emailController.text);
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return EInkScaffold(
      appBar: AppBar(
        title: Text(localization.translate('auth_login')),
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(text: localization.translate('auth_login')),
            Tab(text: localization.translate('auth_signup')),
            Tab(text: localization.translate('forgot_password')),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                _buildLogin(localization),
                _buildSignup(localization),
                _buildForgot(localization),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: localization.translate('auth_guest'),
            icon: Icons.person,
            onPressed: () {
              widget.controllers.authController.continueAsGuest();
              Navigator.of(context).pushReplacementNamed('/home');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogin(AppLocalizations localization) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: localization.translate('email')),
            validator: (value) => value != null && value.contains('@') ? null : 'Invalid',
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: localization.translate('password'),
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            obscureText: _obscure,
            validator: (value) => value != null && value.length >= 8 ? null : 'Short',
          ),
          const SizedBox(height: 24),
          PrimaryButton(label: localization.translate('auth_login'), onPressed: _submit),
        ],
      ),
    );
  }

  Widget _buildSignup(AppLocalizations localization) {
    return Center(child: Text(localization.translate('auth_signup')));
  }

  Widget _buildForgot(AppLocalizations localization) {
    return Center(child: Text(localization.translate('forgot_password')));
  }
}
