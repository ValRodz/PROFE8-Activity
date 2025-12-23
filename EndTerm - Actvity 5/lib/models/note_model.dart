class NoteModel {
  final int id;
  final int userId;
  final String title;
  final String content;
  final String category;
  final String createdAt;
  final String updatedAt;

  NoteModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: int.parse(json['id'].toString()),
      userId: int.parse(json['user_id'].toString()),
      title: json['title'],
      content: json['content'] ?? '',
      category: json['category'] ?? 'General',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
      'category': category,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
