import 'package:flutter/material.dart';

import 'package:artisan_hr/l10n/generated/app_localizations.dart';

enum AppMessageKey {
  unableToSignIn,
  signedInSuccessfully,
  signedOut,
  checkInSuccess,
  checkOutSuccess,
}

class AppMessage {
  const AppMessage.raw(this.raw) : key = null;
  const AppMessage.key(this.key) : raw = null;

  final String? raw;
  final AppMessageKey? key;
}

extension AppLocalizationsBuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

extension AppLocalizationsMessageX on AppLocalizations {
  String resolveMessage(AppMessage? message) {
    if (message == null) return '';
    if (message.raw != null) return message.raw!;

    switch (message.key!) {
      case AppMessageKey.unableToSignIn:
        return unableToSignIn;
      case AppMessageKey.signedInSuccessfully:
        return signedInSuccessfully;
      case AppMessageKey.signedOut:
        return signedOut;
      case AppMessageKey.checkInSuccess:
        return checkInSuccess;
      case AppMessageKey.checkOutSuccess:
        return checkOutSuccess;
    }
  }
}
