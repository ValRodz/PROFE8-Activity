import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WelcomePageWidget extends StatelessWidget {
  final VoidCallback onAddTask;
  final VoidCallback onClearAll;
  final String userName;

  const WelcomePageWidget({
    super.key,
    required this.onAddTask,
    required this.onClearAll,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 600;
            final padding = isSmallScreen ? 16.0 : 24.0;
            final titleFontSize = isSmallScreen ? 28.0 : 32.0;
            final welcomeFontSize = isSmallScreen ? 20.0 : 24.0;

            return SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - (padding * 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 10 : 20,
                        vertical: isSmallScreen ? 10 : 20,
                      ),
                      padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFEBBCFC).withValues(alpha: 0.8),
                            const Color(0xFFCADBFC).withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.3),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Text(
                        'My To-do',
                        style: GoogleFonts.preahvihear(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ).animate().fadeIn(duration: 800.ms).scale(),
                    SizedBox(height: isSmallScreen ? 24 : 32),
                    Text(
                      'Welcome back, $userName!',
                      style: GoogleFonts.preahvihear(
                        fontSize: welcomeFontSize,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFFF0061),
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
                    const SizedBox(height: 16),
                    Text(
                      'Ready to tackle your goals today?',
                      style: GoogleFonts.preahvihear(
                        fontSize: isSmallScreen ? 14 : 16,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
                    SizedBox(height: isSmallScreen ? 32 : 48),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: constraints.maxWidth * 0.7,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: onAddTask,
                            icon: const Icon(Icons.add_task, size: 24),
                            label: Text(
                              'Add Task',
                              style: GoogleFonts.preahvihear(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFCADBFC),
                              foregroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 4,
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 600.ms, duration: 600.ms)
                            .slideY(begin: 0.3, end: 0),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: constraints.maxWidth * 0.7,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: onClearAll,
                            icon: const Icon(Icons.clear_all, size: 24),
                            label: Text(
                              'Clear All',
                              style: GoogleFonts.preahvihear(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEBBCFC),
                              foregroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 4,
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 800.ms, duration: 600.ms)
                            .slideY(begin: 0.3, end: 0),
                      ],
                    ),
                    SizedBox(height: isSmallScreen ? 24 : 32),
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                      margin: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 10 : 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9EAFE).withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFEBBCFC).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        '"The secret of getting ahead is getting started."',
                        style: GoogleFonts.preahvihear(
                          fontSize: isSmallScreen ? 12 : 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ).animate().fadeIn(delay: 1000.ms, duration: 600.ms),
                    SizedBox(height: isSmallScreen ? 16 : 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
