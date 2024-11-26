import 'package:app_contatos/app/controllers/contact_controller.dart';
import 'package:app_contatos/app/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class UpdateContactView extends StatelessWidget {
  final _form = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  final phoneFormatter = MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

  UpdateContactView({super.key});

  void _loadFormData(Contact contact) {
    _formData["id"] = contact.id!;
    _formData["name"] = contact.name;
    _formData["email"] = contact.email;

    String formattedPhone = phoneFormatter.maskText(contact.phone);
    _formData["phone"] = formattedPhone;
  }

  @override
  Widget build(BuildContext context) {
    final contact = ModalRoute.of(context)!.settings.arguments as Contact?;
    if (contact != null) {
      _loadFormData(contact);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Editar Contato",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (_form.currentState!.validate()) {
                _form.currentState!.save();

                String phone =
                    _formData["phone"].replaceAll(RegExp(r'[^0-9]'), '');

                Provider.of<ContactController>(context, listen: false).update(
                  Contact(
                      id: _formData["id"],
                      name: _formData["name"]!,
                      email: _formData["email"]!,
                      phone: phone),
                );
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                initialValue: _formData["name"],
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome';
                  }
                  return null;
                },
                onSaved: (value) => _formData["name"] = value!,
              ),
              TextFormField(
                initialValue: _formData["email"],
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu e-mail';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Por favor, insira um e-mail válido';
                  }
                  return null;
                },
                onSaved: (value) => _formData["email"] = value!,
              ),
              TextFormField(
                initialValue: _formData["phone"],
                decoration:
                    const InputDecoration(labelText: 'Número de Telefone'),
                keyboardType: TextInputType.phone,
                inputFormatters: [phoneFormatter],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu telefone';
                  } else if (value.length != 15) {
                    // Verifica o formato
                    return 'Por favor, insira um telefone válido';
                  }
                  return null;
                },
                onSaved: (value) => _formData["phone"] = value!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
