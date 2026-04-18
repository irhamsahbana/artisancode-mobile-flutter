import 'package:flutter/material.dart';

class AppMessageBanner extends StatelessWidget {
  const AppMessageBanner({
    required this.errorMessage,
    required this.successMessage,
    required this.onDismissed,
    super.key,
  });

  final String? errorMessage;
  final String? successMessage;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    final message = errorMessage ?? successMessage;
    if (message == null || message.isEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final isError = errorMessage != null;
    final backgroundColor = isError
        ? colorScheme.errorContainer
        : colorScheme.primaryContainer;
    final foregroundColor = isError
        ? colorScheme.onErrorContainer
        : colorScheme.onPrimaryContainer;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onDismissed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  isError ? Icons.error_outline : Icons.check_circle_outline,
                  color: foregroundColor,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: foregroundColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: onDismissed,
                  icon: Icon(Icons.close, color: foregroundColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
