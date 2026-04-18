import 'package:flutter/material.dart';

import 'package:artisan_hr/app/app_controller.dart';
import 'package:artisan_hr/app/presentation/app_brand.dart';
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
  bool _showAdvancedFields = false;

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
    if (form == null || !form.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    try {
      await widget.controller.login(
        email: _emailController.text,
        password: _passwordController.text,
        tenantCode: _tenantCodeController.text,
        baseUrl: _baseUrlController.text,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      final message = context.l10n.resolveMessage(
        widget.controller.errorMessage,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message.isNotEmpty ? message : context.l10n.unableToSignIn,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [AppBrandPalette.night, AppBrandPalette.nightSurface]
                : [Color(0xFFEAF7F2), Color(0xFFF8FCFA)],
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
              top: -120,
              right: -20,
              child: _GlowOrb(size: 240, color: Color(0x289FE1CB)),
            ),
            const Positioned(
              top: 180,
              left: -70,
              child: _GlowOrb(size: 180, color: Color(0x1F0F6E56)),
            ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth > 560
                      ? 460.0
                      : constraints.maxWidth - 32;

                  return Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: width.clamp(320.0, 460.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(
                                22,
                                22,
                                22,
                                20,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: isDark
                                      ? [
                                          AppBrandPalette.nightCard,
                                          AppBrandPalette.nightSurface,
                                        ]
                                      : [Color(0xFFFFFFFF), Color(0xFFF1FAF6)],
                                ),
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(
                                  color: colorScheme.outlineVariant,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PresenseLockup(
                                    markSize: 62,
                                    wordmarkStyle: textTheme.headlineSmall
                                        ?.copyWith(fontWeight: FontWeight.w300),
                                  ),
                                  const SizedBox(height: 18),
                                  Text(
                                    l10n.loginCardTitle,
                                    style: textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    l10n.loginCardDescription,
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                      height: 1.45,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: colorScheme.primary,
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: const Icon(
                                            Icons.verified_user_rounded,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                l10n.justInTimePermissionsTitle,
                                                style: textTheme.titleSmall
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: colorScheme
                                                          .onPrimaryContainer,
                                                    ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                l10n.permissionUsageSummary,
                                                style: textTheme.bodySmall
                                                    ?.copyWith(
                                                      color: colorScheme
                                                          .onPrimaryContainer,
                                                      height: 1.45,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      DropdownButtonFormField<String>(
                                        initialValue:
                                            widget.controller.languageCode,
                                        isExpanded: true,
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
                                          if (value == null) {
                                            return;
                                          }
                                          widget.controller.setLanguage(value);
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        controller: _emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        autofillHints: const [
                                          AutofillHints.username,
                                          AutofillHints.email,
                                        ],
                                        decoration: InputDecoration(
                                          labelText: l10n.emailLabel,
                                          hintText: 'employee@company.com',
                                        ),
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return l10n.emailRequired;
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      TextFormField(
                                        controller: _passwordController,
                                        obscureText: !_isPasswordVisible,
                                        autofillHints: const [
                                          AutofillHints.password,
                                        ],
                                        decoration: InputDecoration(
                                          labelText: l10n.passwordLabel,
                                          suffixIcon: IconButton(
                                            tooltip: _isPasswordVisible
                                                ? l10n.hidePassword
                                                : l10n.showPassword,
                                            onPressed: () {
                                              setState(() {
                                                _isPasswordVisible =
                                                    !_isPasswordVisible;
                                              });
                                            },
                                            icon: Icon(
                                              _isPasswordVisible
                                                  ? Icons
                                                        .visibility_off_outlined
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
                                        textCapitalization:
                                            TextCapitalization.characters,
                                        decoration: InputDecoration(
                                          labelText: l10n.tenantCodeLabel,
                                          hintText: 'ABCDE',
                                        ),
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return l10n.tenantCodeRequired;
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 12),
                                      SwitchListTile.adaptive(
                                        contentPadding: EdgeInsets.zero,
                                        value: _showAdvancedFields,
                                        title: Text(
                                          l10n.showAdvancedSettings,
                                          style: textTheme.titleSmall?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        subtitle: Text(l10n.apiUrlHint),
                                        onChanged: (value) {
                                          setState(() {
                                            _showAdvancedFields = value;
                                          });
                                        },
                                      ),
                                      if (_showAdvancedFields) ...[
                                        const SizedBox(height: 8),
                                        TextFormField(
                                          controller: _baseUrlController,
                                          decoration: InputDecoration(
                                            labelText: l10n.apiBaseUrl,
                                            hintText: 'http://127.0.0.1:3939',
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return l10n.apiBaseUrlRequired;
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                      const SizedBox(height: 24),
                                      SizedBox(
                                        width: double.infinity,
                                        child: FilledButton(
                                          onPressed: widget.controller.isBusy
                                              ? null
                                              : _submit,
                                          child: Text(l10n.signIn),
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, Colors.transparent]),
        ),
      ),
    );
  }
}
