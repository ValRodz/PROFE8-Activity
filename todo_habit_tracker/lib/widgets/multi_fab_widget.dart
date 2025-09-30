import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MultiFabWidget extends StatefulWidget {
  final int currentIndex;
  final void Function(String) onActionSelected;

  const MultiFabWidget({
    super.key,
    required this.currentIndex,
    required this.onActionSelected,
  });

  @override
  State<MultiFabWidget> createState() => _MultiFabWidgetState();
}

class _MultiFabWidgetState extends State<MultiFabWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  List<FabAction> _getActionsForCurrentView() {
    switch (widget.currentIndex) {
      case 0: // Home
        return [
          FabAction(
            icon: Icons.add_task,
            label: 'Add Task',
            color: const Color(0xFFCADBFC),
            action: 'add_task',
          ),
          FabAction(
            icon: Icons.track_changes,
            label: 'Add Habit',
            color: const Color(0xFFEBBCFC),
            action: 'add_habit',
          ),
          FabAction(
            icon: Icons.note_add,
            label: 'Quick Note',
            color: const Color(0xFFF9EAFE),
            action: 'add_note',
          ),
        ];
      case 1: // Tasks
        return [
          FabAction(
            icon: Icons.add_task,
            label: 'Add Task',
            color: const Color(0xFFCADBFC),
            action: 'add_task',
          ),
          FabAction(
            icon: Icons.filter_list,
            label: 'Filter',
            color: const Color(0xFFEBBCFC),
            action: 'filter_tasks',
          ),
        ];
      case 2: // Habits
        return [
          FabAction(
            icon: Icons.track_changes,
            label: 'Add Habit',
            color: const Color(0xFFEBBCFC),
            action: 'add_habit',
          ),
          FabAction(
            icon: Icons.analytics,
            label: 'View Stats',
            color: const Color(0xFFCADBFC),
            action: 'view_stats',
          ),
        ];
      case 3: // Progress
        return [
          FabAction(
            icon: Icons.refresh,
            label: 'Refresh',
            color: const Color(0xFFCADBFC),
            action: 'refresh_progress',
          ),
          FabAction(
            icon: Icons.share,
            label: 'Share',
            color: const Color(0xFFEBBCFC),
            action: 'share_progress',
          ),
        ];
      case 4: // Notes
        return [
          FabAction(
            icon: Icons.note_add,
            label: 'Quick Note',
            color: const Color(0xFFF9EAFE),
            action: 'add_note',
          ),
          FabAction(
            icon: Icons.search,
            label: 'Search',
            color: const Color(0xFFCADBFC),
            action: 'search_notes',
          ),
        ];
      case 5: // Profile
        return [
          FabAction(
            icon: Icons.edit,
            label: 'Edit Profile',
            color: const Color(0xFFEBBCFC),
            action: 'edit_profile',
          ),
          FabAction(
            icon: Icons.settings,
            label: 'Settings',
            color: const Color(0xFFCADBFC),
            action: 'settings',
          ),
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final actions = _getActionsForCurrentView();

    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Backdrop
        if (_isExpanded)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleExpanded,
              child: Container(
                color: Colors.black.withValues(alpha: 0.3),
              ),
            ),
          ).animate().fadeIn(duration: 200.ms),

        // Action buttons
        ...actions.asMap().entries.map((entry) {
          final index = entry.key;
          final action = entry.value;

          return AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              final offset = (index + 1) * 70.0 * _expandAnimation.value;

              return Positioned(
                bottom: 16 + offset,
                right: 16,
                child: Transform.scale(
                  scale: _expandAnimation.value,
                  child: Opacity(
                    opacity: _expandAnimation.value,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Label
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            action.label,
                            style: GoogleFonts.preahvihear(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Action button
                        FloatingActionButton(
                          mini: true,
                          heroTag: action.action,
                          backgroundColor: action.color,
                          onPressed: () {
                            _toggleExpanded();
                            widget.onActionSelected(action.action);
                          },
                          child: Icon(
                            action.icon,
                            color: Colors.black87,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),

        // Main FAB
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            heroTag: 'main_fab',
            backgroundColor: const Color(0xFFFF0061),
            onPressed: _toggleExpanded,
            child: AnimatedRotation(
              turns: _isExpanded ? 0.125 : 0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                _isExpanded ? Icons.close : Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FabAction {
  final IconData icon;
  final String label;
  final Color color;
  final String action;

  FabAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.action,
  });
}
