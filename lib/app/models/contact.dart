class Contact {
  final int? id;
  final String name;
  final String email;
  final String phone;

  Contact(
      {this.id, required this.name, required this.email, required this.phone});

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
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

  bool validate(Contact contact) {
    return contact.name.isNotEmpty &&
        contact.email.isNotEmpty &&
        contact.phone.isNotEmpty;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Contact) return false;
    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phone == phone;
  }

  @override
  int get hashCode => Object.hash(id, name, email, phone);
}
