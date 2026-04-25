class Note {
  final String id;
  final String content;
  final String title;
  final bool isLiked;
  final DateTime createdAt;
  final DateTime updatedAt;

  Note({
    required this.id,
    required this.content,
    required this.title,
    required this.isLiked,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "content": content,
    "title": title,
    "isLiked": isLiked,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'] ?? "",
    content: json['content'] ?? "",
    title: json['title'] ?? "",
    isLiked: json['isLiked'] ?? false,
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
  );
}