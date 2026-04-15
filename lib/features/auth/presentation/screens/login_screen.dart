import 'package:flutter/material.dart';

import '../../../../app/app_controller.dart';
import '../../../../shared/config/app_config.dart';

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
            widget.controller.errorMessage ?? 'Unable to sign in.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = widget.controller.strings;

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
                            strings.employeeAttendanceTitle,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            strings.loginDescription,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.black54,
                                ),
                          ),
                          const SizedBox(height: 24),
                          DropdownButtonFormField<String>(
                            initialValue: widget.controller.languageCode,
                            decoration: InputDecoration(
                              labelText: strings.languageLabel,
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'id',
                                child: Text(strings.indonesianLabel),
                              ),
                              DropdownMenuItem(
                                value: 'en',
                                child: Text(strings.englishLabel),
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
                              labelText: strings.apiBaseUrl,
                              hintText: 'http://127.0.0.1:3939',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return strings.apiBaseUrlRequired;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: strings.emailLabel,
                              hintText: 'employee@company.com',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return strings.emailRequired;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: strings.passwordLabel,
                              suffixIcon: IconButton(
                                tooltip: _isPasswordVisible
                                    ? strings.hidePassword
                                    : strings.showPassword,
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
                                return strings.passwordRequired;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _tenantCodeController,
                            textCapitalization: TextCapitalization.characters,
                            decoration: InputDecoration(
                              labelText: strings.tenantCodeLabel,
                              hintText: 'ABCDE',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return strings.tenantCodeRequired;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: widget.controller.isBusy ? null : _submit,
                              child: Text(strings.signIn),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            strings.apiUrlHint,
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
