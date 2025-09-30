import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/note.dart';

class ChatBubbleWidget extends StatelessWidget {
  final Note note;
  final bool isOwnMessage;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ChatBubbleWidget({
    super.key,
    required this.note,
    this.isOwnMessage = true,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        mainAxisAlignment:
            isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isOwnMessage) ...[
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFCADBFC),
              child: Icon(
                Icons.lightbulb,
                size: 16,
                color: Color(0xFFFF0061),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: GestureDetector(
              onTap: onTap,
              onLongPress: onLongPress,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isOwnMessage
                      ? const Color(0xFFFF0061)
                      : const Color(0xFFFEECF5),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: Radius.circular(isOwnMessage ? 20 : 4),
                    bottomRight: Radius.circular(isOwnMessage ? 4 : 20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Note content
                    Text(
                      note.content,
                      style: GoogleFonts.preahvihear(
                        fontSize: 14,
                        color: isOwnMessage ? Colors.white : Colors.black87,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Tags and metadata row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Tags
                        if (note.tags.isNotEmpty)
                          Expanded(
                            child: Wrap(
                              spacing: 4,
                              runSpacing: 2,
                              children: note.tags.take(2).map((tag) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isOwnMessage
                                        ? Colors.white.withValues(alpha: 0.2)
                                        : const Color(0xFFEBBCFC)
                                            .withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '#$tag',
                                    style: GoogleFonts.preahvihear(
                                      fontSize: 10,
                                      color: isOwnMessage
                                          ? Colors.white
                                          : Colors.black54,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                        // Pin icon and timestamp
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (note.isPinned)
                              Icon(
                                Icons.push_pin,
                                size: 12,
                                color: isOwnMessage
                                    ? Colors.white.withValues(alpha: 0.7)
                                    : const Color(0xFFFF0061),
                              ),
                            const SizedBox(width: 4),
                            Text(
                              _formatTime(note.createdAt),
                              style: GoogleFonts.preahvihear(
                                fontSize: 10,
                                color: isOwnMessage
                                    ? Colors.white.withValues(alpha: 0.7)
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isOwnMessage) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFEBBCFC),
              child: Icon(
                Icons.person,
                size: 16,
                color: Color(0xFFFF0061),
              ),
            ),
          ],
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideX(begin: isOwnMessage ? 0.3 : -0.3, end: 0);
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'now';
    }
  }
}
