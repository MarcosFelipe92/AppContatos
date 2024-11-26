import 'package:app_contatos/app/models/contact.dart';
import 'package:app_contatos/app/routes/app_routes.dart';
import 'package:flutter/material.dart';

class ContactTile extends StatelessWidget {
  final Contact contact;

  const ContactTile({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    String firstLetter = contact.name[0];

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.purple[100],
          child: Text(
            firstLetter,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
        ),
        title: Text(
          contact.name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        onTap: () {
          Navigator.of(context)
              .pushNamed(AppRoutes.contactDetails, arguments: contact.id);
        },
      ),
    );
  }
}
