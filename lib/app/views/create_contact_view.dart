import 'package:app_contatos/app/components/app_bar_title.dart';
import 'package:app_contatos/app/components/contact_form.dart';
import 'package:app_contatos/app/components/custom_button.dart';
import 'package:app_contatos/app/controllers/contact_controller.dart';
import 'package:app_contatos/app/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class CreateContactView extends StatelessWidget {
  final _form = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  final phoneFormatter = MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

  CreateContactView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppBarTitle(
          label: "Adicionar Contatos",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            ContactForm(
              formKey: _form,
              formData: _formData,
              phoneFormatter: phoneFormatter,
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: "Salvar Contato",
              onPressed: () {
                if (_form.currentState!.validate()) {
                  _form.currentState!.save();

                  String phone =
                      _formData["phone"].replaceAll(RegExp(r'[^0-9]'), '');

                  Provider.of<ContactController>(context, listen: false).create(
                    Contact(
                      id: _formData["id"],
                      name: _formData["name"]!,
                      email: _formData["email"]!,
                      phone: phone,
                    ),
                  );
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Contato adicionado com sucesso",
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
