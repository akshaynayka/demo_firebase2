class User {
  String? id;
  String? name;
  String? email;
  String? password;
  String? imageUrl;

  User({
    this.id,
    this.name,
    this.email,
    this.imageUrl,
    this.password,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'imageUrl': imageUrl,
      };

  static User fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        imageUrl: json['imageUrl'],
      );
}
