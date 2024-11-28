import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ContactForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> formData;
  final MaskTextInputFormatter phoneFormatter;

  const ContactForm({
    required this.formKey,
    required this.formData,
    required this.phoneFormatter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: formData["name"],
            decoration: const InputDecoration(labelText: 'Nome'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira seu nome';
              } else if (value.length < 3) {
                return 'Por favor, insira um nome com pelo menos 3 caracteres';
              }
              return null;
            },
            onSaved: (value) => formData["name"] = value!,
          ),
          TextFormField(
            initialValue: formData["email"],
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
            onSaved: (value) => formData["email"] = value!,
          ),
          TextFormField(
            initialValue: formData["phone"],
            decoration: const InputDecoration(labelText: 'Número de Telefone'),
            keyboardType: TextInputType.phone,
            inputFormatters: [phoneFormatter],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira seu telefone';
              } else if (value.length != 15) {
                return 'Por favor, insira um telefone válido';
              }
              return null;
            },
            onSaved: (value) => formData["phone"] = value!,
          ),
        ],
      ),
    );
  }
}
