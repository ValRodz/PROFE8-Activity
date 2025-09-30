import 'package:flutter/material.dart';
import 'multi_fab_widget.dart';

class StackLayoutWidget extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final void Function(String) onFabAction;

  const StackLayoutWidget({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.onFabAction,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content
        child,

        // Multi-action FAB
        MultiFabWidget(
          currentIndex: currentIndex,
          onActionSelected: onFabAction,
        ),
      ],
    );
  }
}
