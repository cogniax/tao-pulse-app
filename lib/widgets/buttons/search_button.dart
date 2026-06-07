import 'package:flutter/material.dart';

import 'app_icon_button.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AppIconButton(onPressed: onPressed, icon: const Icon(Icons.search));
  }
}
