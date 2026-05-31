import 'package:flutter/material.dart';

import '../../core/theme/theme.dart';

/// A recoverable error state with a retry action.
///
/// The async screens render this when a `FutureProvider` fails. Previously each
/// error branch showed a static `Text('Failed to load …')` with no way to
/// recover, so any transient failure (timeout, dropped connection, a 5xx from
/// the backend) left the user stuck until the app was restarted. [onRetry]
/// typically re-runs the provider via `ref.invalidate(...)`.
class ErrorRetryView extends StatelessWidget {
  const ErrorRetryView({
    super.key,
    required this.message,
    required this.onRetry,
    this.title = 'Something went wrong',
    this.icon = Icons.cloud_off_rounded,
  });

  final String title;
  final String message;
  final IconData icon;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.critical.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.critical, size: 30),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.tonal(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.aiPurple.withValues(alpha: 0.18),
                foregroundColor: AppColors.aiPurple,
              ),
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
