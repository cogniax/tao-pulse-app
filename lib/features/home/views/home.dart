import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../feed/views/feed_page.dart';
import '../../subnets/views/subnets_page.dart';

class HomeRootPage extends StatefulWidget {
  const HomeRootPage({super.key});

  @override
  State<HomeRootPage> createState() => _HomeRootPageState();
}

class _HomeRootPageState extends State<HomeRootPage> {
  int _currentIndex = 0;

  static const _tabs = <_HomeTab>[
    _HomeTab('Home', Icons.inbox_outlined),
    _HomeTab('Subnets', Icons.hub_outlined),
    _HomeTab('AI Chat', Icons.auto_awesome_outlined),
    _HomeTab('Alerts', Icons.notifications_none_rounded),
    _HomeTab('Profile', Icons.person_outline_rounded),
  ];

  static const _pages = <Widget>[
    FeedPage(),
    SubnetsPage(),
    _PlaceholderTabPage(label: 'AI Chat'),
    _PlaceholderTabPage(label: 'Alerts'),
    _PlaceholderTabPage(label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FigmaColors.pageBackground,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _BottomNavigationBar(
        tabs: _tabs,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

class _HomeTab {
  const _HomeTab(this.label, this.icon);

  final String label;
  final IconData icon;
}

class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar({
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
  });

  final List<_HomeTab> tabs;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: FigmaColors.pageBackground,
        border: Border(
          top: BorderSide(color: Color(0xFF141416)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg * 2,
            AppSpacing.md,
            AppSpacing.lg * 2,
            AppSpacing.lg,
          ),
          child: Row(
            children: List<Widget>.generate(
              tabs.length,
              (index) => Expanded(
                child: _BottomNavigationItem(
                  tab: tabs[index],
                  selected: index == currentIndex,
                  onTap: () => onTap(index),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavigationItem extends StatelessWidget {
  const _BottomNavigationItem({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final _HomeTab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? FigmaColors.brandPrimary
        : FigmaColors.iconNeutralTertiary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.button),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(tab.icon, color: color, size: 24),
          const SizedBox(height: AppSpacing.xs),
          Text(
            tab.label,
            style: FigmaTypography.caption.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderTabPage extends StatelessWidget {
  const _PlaceholderTabPage({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: FigmaTypography.h3Semibold.copyWith(
              color: FigmaColors.textNeutralPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Placeholder content',
            style: FigmaTypography.bodySmallRegular.copyWith(
              color: FigmaColors.textNeutralSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
