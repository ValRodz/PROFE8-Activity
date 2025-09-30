class Note {
  final String id;
  final String content;
  final DateTime createdAt;
  final String category;
  final List<String> tags;
  final bool isPinned;

  Note({
    required this.id,
    required this.content,
    required this.createdAt,
    this.category = 'General',
    this.tags = const [],
    this.isPinned = false,
  });

  Note copyWith({
    String? id,
    String? content,
    DateTime? createdAt,
    String? category,
    List<String>? tags,
    bool? isPinned,
  }) {
    return Note(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'category': category,
      'tags': tags,
      'isPinned': isPinned,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      category: (json['category'] as String?) ?? 'General',
      tags: List<String>.from(json['tags'] as List<dynamic>? ?? []),
      isPinned: (json['isPinned'] as bool?) ?? false,
    );
  }
}
