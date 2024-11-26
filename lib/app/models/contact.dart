class Contact {
  final int? id;
  final String name;
  final String email;
  final String phone;

  Contact(
      {this.id, required this.name, required this.email, required this.phone});

  factory Contact.fromMap(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}
