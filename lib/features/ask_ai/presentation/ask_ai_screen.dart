import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/theme.dart';
import '../../../widgets/app_top_bar.dart';
import '../data/ask_ai_repository.dart';

class AskAiScreen extends ConsumerWidget {
  const AskAiScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(askAiDashboardProvider);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 72,
        titleSpacing: AppSpacing.md,
        title: const AppTopBar(title: 'Ask AI', showSearch: false),
      ),
      body: dashboardAsync.when(
        data: (dashboard) => Padding(
          padding: EdgeInsets.fromLTRB(4, AppSpacing.md, 4, 12 + bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _AskAiHero(),
              const SizedBox(height: AppSpacing.xxl),
              const _SectionHeader(title: 'Suggested questions'),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 214,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: dashboard.suggestions.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: AppSpacing.md),
                  itemBuilder: (context, index) => SizedBox(
                    width: 210,
                    child: _PromptCard(
                      data: dashboard.suggestions[index],
                      onTap: () => _openChatReply(
                        context,
                        ref,
                        dashboard.suggestions[index].title,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const _SectionHeader(
                title: 'Recent conversations',
                actionLabel: 'Live',
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: 88,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: dashboard.history.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: AppSpacing.md),
                  itemBuilder: (context, index) => SizedBox(
                    width: 170,
                    child: _RecentConversationCard(
                      data: dashboard.history[index],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              const SizedBox(height: AppSpacing.md),
              _AskAiComposer(onSubmit: () => _openPromptDialog(context, ref)),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Failed to load Ask AI: $error')),
      ),
    );
  }

  Future<void> _openPromptDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final prompt = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        title: const Text('Ask TaoPulse AI'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Ask about subnets, validators, stake movement...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Send'),
          ),
        ],
      ),
    );

    if (prompt == null || prompt.isEmpty || !context.mounted) {
      return;
    }
    await _openChatReply(context, ref, prompt);
  }

  Future<void> _openChatReply(
    BuildContext context,
    WidgetRef ref,
    String message,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      const SnackBar(content: Text('Sending message to TaoPulse AI...')),
    );

    final reply = await ref.read(askAiRepositoryProvider).sendMessage(message);
    if (!context.mounted) {
      return;
    }
    messenger.hideCurrentSnackBar();

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceCard,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontSize: 18),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              reply.content,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
            if (reply.sources.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Sources: ${reply.sources.join(', ')}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AskAiHero extends StatelessWidget {
  const _AskAiHero();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: theme.textTheme.displaySmall?.copyWith(
                fontSize: 22,
                height: 1.15,
              ),
              children: const [
                TextSpan(text: 'How can I help you\n'),
                TextSpan(
                  text: 'understand ',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                TextSpan(
                  text: 'Bittensor',
                  style: TextStyle(color: AppColors.aiPurple),
                ),
                TextSpan(text: ' today?'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Text(
              'Ask anything about subnets, validators, stake, emissions, or ecosystem activity.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 15,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.actionLabel});

  final String title;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.auto_awesome,
          size: 18,
          color: AppColors.aiPurple.withValues(alpha: 0.95),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontSize: 18),
          ),
        ),
        if (actionLabel != null)
          Text(
            actionLabel!,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: AppColors.aiPurple),
          ),
      ],
    );
  }
}

class _PromptCard extends StatelessWidget {
  const _PromptCard({required this.data, required this.onTap});

  final AskAiPrompt data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = _accentColor(data.topic);
    final icon = _iconForTopic(data.topic);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard.withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(AppRadius.smallCard),
                    ),
                    child: Icon(icon, color: accent, size: 21),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward,
                    color: AppColors.textSecondary,
                    size: 22,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                data.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 15,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                data.subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _accentColor(String topic) {
    switch (topic) {
      case 'daily_briefing':
        return const Color(0xFF18E7C5);
      case 'validator_analysis':
        return const Color(0xFFFFA055);
      default:
        return AppColors.aiPurple;
    }
  }

  IconData _iconForTopic(String topic) {
    switch (topic) {
      case 'daily_briefing':
        return Icons.article_outlined;
      case 'validator_analysis':
        return Icons.groups_outlined;
      case 'stake_analysis':
        return Icons.account_balance_wallet_outlined;
      default:
        return Icons.trending_up;
    }
  }
}

class _AskAiComposer extends StatelessWidget {
  const _AskAiComposer({required this.onSubmit});

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(1.2),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0x667B5CFF), Color(0x55A855F7), Color(0x334F8CFF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Container(
        height: 62,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(27),
        ),
        child: Row(
          children: [
            _ComposerCircleButton(
              icon: Icons.add,
              backgroundColor: Colors.white.withValues(alpha: 0.04),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'Ask anything about Bittensor...',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Icon(Icons.mic_none, color: AppColors.textPrimary, size: 24),
            const SizedBox(width: AppSpacing.md),
            GestureDetector(
              onTap: onSubmit,
              child: const _ComposerCircleButton(
                icon: Icons.arrow_upward,
                backgroundColor: AppColors.aiPurple,
                iconColor: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentConversationCard extends StatelessWidget {
  const _RecentConversationCard({required this.data});

  final ChatHistoryItem data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(AppRadius.smallCard),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.aiPurple.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              color: AppColors.aiPurple,
              size: 18,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  data.timeAgo,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
            size: 18,
          ),
        ],
      ),
    );
  }
}

class _ComposerCircleButton extends StatelessWidget {
  const _ComposerCircleButton({
    required this.icon,
    required this.backgroundColor,
    this.iconColor = AppColors.textSecondary,
  });

  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor, size: 22),
    );
  }
}
