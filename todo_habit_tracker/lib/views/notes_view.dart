import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/note.dart';
import '../widgets/chat_bubble_widget.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  List<Note> _notes = [];
  bool _isLoading = true;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadNotes() async {
    final sampleNotes = [
      Note(
        id: '1',
        content:
            'Remember to review the quarterly reports before the meeting tomorrow.',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        category: 'Work',
        tags: ['meeting', 'reports'],
        isPinned: true,
      ),
      Note(
        id: '2',
        content:
            'Great idea for the weekend project: build a small garden in the backyard!',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        category: 'Personal',
        tags: ['weekend', 'garden'],
      ),
      Note(
        id: '3',
        content:
            'Don\'t forget to call mom this evening. She mentioned wanting to discuss the family reunion plans.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        category: 'Personal',
        tags: ['family', 'call'],
      ),
      Note(
        id: '4',
        content:
            'New workout routine: 30 minutes cardio, 20 minutes strength training, 10 minutes stretching.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        category: 'Health',
        tags: ['workout', 'routine'],
        isPinned: true,
      ),
    ];

    setState(() {
      _notes = sampleNotes;
      _isLoading = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _addNote() {
    if (_messageController.text.trim().isEmpty) {
      return;
    }

    final newNote = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: _messageController.text.trim(),
      createdAt: DateTime.now(),
      category: 'General',
      tags: _extractTags(_messageController.text),
    );

    setState(() {
      _notes.add(newNote);
    });

    _messageController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  List<String> _extractTags(String content) {
    final RegExp tagRegex = RegExp(r'#(\w+)');
    final matches = tagRegex.allMatches(content);
    return matches.map((match) => match.group(1)!).toList();
  }

  void _showNoteOptions(Note note) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(
                note.isPinned ? Icons.push_pin_outlined : Icons.push_pin,
                color: const Color(0xFFFF0061),
              ),
              title: Text(note.isPinned ? 'Unpin Note' : 'Pin Note'),
              onTap: () {
                setState(() {
                  final index = _notes.indexWhere((n) => n.id == note.id);
                  if (index != -1) {
                    _notes[index] = note.copyWith(isPinned: !note.isPinned);
                  }
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit, color: Color(0xFFFF0061)),
              title: const Text('Edit Note'),
              onTap: () {
                Navigator.pop(context);
                _showEditNoteDialog(note);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Note'),
              onTap: () {
                setState(() {
                  _notes.removeWhere((n) => n.id == note.id);
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditNoteDialog(Note note) {
    final controller = TextEditingController(text: note.content);

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Note', style: GoogleFonts.preahvihear()),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter your note...',
            border: OutlineInputBorder(),
          ),
          maxLines: 4,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  final index = _notes.indexWhere((n) => n.id == note.id);
                  if (index != -1) {
                    _notes[index] = note.copyWith(
                      content: controller.text.trim(),
                      tags: _extractTags(controller.text),
                    );
                  }
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF0061),
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes',
          style: GoogleFonts.preahvihear(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: _notes.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No notes yet',
                                style: GoogleFonts.preahvihear(
                                  fontSize: 18,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Start a conversation with yourself!',
                                style: GoogleFonts.preahvihear(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: _notes.length,
                          itemBuilder: (context, index) {
                            final note = _notes[index];
                            final isOwnMessage = index % 3 != 1;

                            return ChatBubbleWidget(
                              note: note,
                              isOwnMessage: isOwnMessage,
                              onLongPress: () => _showNoteOptions(note),
                            );
                          },
                        ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, -1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          child: TextField(
                            controller: _messageController,
                            decoration: const InputDecoration(
                              hintText: 'Type a note... (use #tags)',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            maxLines: null,
                            textCapitalization: TextCapitalization.sentences,
                            onSubmitted: (_) => _addNote(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF0061),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: _addNote,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
