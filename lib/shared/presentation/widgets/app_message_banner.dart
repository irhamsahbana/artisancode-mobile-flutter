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

    final isError = errorMessage != null;
    final backgroundColor = isError ? const Color(0xFFFEE2E2) : const Color(0xFFDCFCE7);
    final foregroundColor = isError ? const Color(0xFF991B1B) : const Color(0xFF166534);

    return Material(
      color: backgroundColor,
      child: InkWell(
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
                  style: TextStyle(color: foregroundColor),
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
    );
  }
}
