import 'package:flutter/material.dart';

import 'package:artisan_hr/app/app_controller.dart';
import 'package:artisan_hr/shared/config/app_config.dart';
import 'package:artisan_hr/shared/localization/l10n.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({required this.controller, super.key});

  final AppController controller;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _tenantCodeController = TextEditingController();
  late final TextEditingController _baseUrlController;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _baseUrlController = TextEditingController(
      text: widget.controller.baseUrl.isEmpty
          ? AppConfig.defaultApiBaseUrl
          : widget.controller.baseUrl,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _tenantCodeController.dispose();
    _baseUrlController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    FocusScope.of(context).unfocus();

    try {
      await widget.controller.login(
        email: _emailController.text,
        password: _passwordController.text,
        tenantCode: _tenantCodeController.text,
        baseUrl: _baseUrlController.text,
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.resolveMessage(widget.controller.errorMessage).isNotEmpty
                ? context.l10n.resolveMessage(widget.controller.errorMessage)
                : context.l10n.unableToSignIn,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE6FFFA),
              Color(0xFFF4F7F6),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'AH',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            l10n.employeeAttendanceTitle,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.loginDescription,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.black54,
                                ),
                          ),
                          const SizedBox(height: 24),
                          DropdownButtonFormField<String>(
                            initialValue: widget.controller.languageCode,
                            decoration: InputDecoration(
                              labelText: l10n.languageLabel,
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'id',
                                child: Text(l10n.indonesianLabel),
                              ),
                              DropdownMenuItem(
                                value: 'en',
                                child: Text(l10n.englishLabel),
                              ),
                            ],
                            onChanged: (value) {
                              if (value == null) return;
                              widget.controller.setLanguage(value);
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _baseUrlController,
                            decoration: InputDecoration(
                              labelText: l10n.apiBaseUrl,
                              hintText: 'http://127.0.0.1:3939',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.apiBaseUrlRequired;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: l10n.emailLabel,
                              hintText: 'employee@company.com',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.emailRequired;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: l10n.passwordLabel,
                              suffixIcon: IconButton(
                                tooltip: _isPasswordVisible
                                    ? l10n.hidePassword
                                    : l10n.showPassword,
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.passwordRequired;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _tenantCodeController,
                            textCapitalization: TextCapitalization.characters,
                            decoration: InputDecoration(
                              labelText: l10n.tenantCodeLabel,
                              hintText: 'ABCDE',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.tenantCodeRequired;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: widget.controller.isBusy ? null : _submit,
                              child: Text(l10n.signIn),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.apiUrlHint,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.black54,
                                ),
                          ),
                        ],
                      ),
                    ),
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
