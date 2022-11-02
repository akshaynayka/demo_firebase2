class Group {
  String? id;
  String? name;
  String? createdAt;
  String? imageUrl;

  Group({
    this.id,
    this.name,
    this.createdAt,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'createdAt': createdAt,
        'imageUrl': imageUrl,
      };

  static Group fromJson(Map<String, dynamic> json) => Group(
        id: json['id'],
        name: json['name'],
        createdAt: json['createdAt'],
        imageUrl: json['imageUrl'],
      );
}
