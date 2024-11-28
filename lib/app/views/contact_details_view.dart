import 'package:app_contatos/app/components/app_bar_title.dart';
import 'package:app_contatos/app/controllers/contact_controller.dart';
import 'package:app_contatos/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class ContactDetailsView extends StatelessWidget {
  const ContactDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneFormatter = MaskTextInputFormatter(
        mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

    final contactId = ModalRoute.of(context)!.settings.arguments as int;
    final contact = Provider.of<ContactController>(context).findById(contactId);
    final formattedPhone = phoneFormatter.maskText(contact.phone);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppBarTitle(
          label: "Detalhes do Contato",
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Informações do contato
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.purple,
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.person, color: Colors.white, size: 30),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            contact.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.purple,
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.email, color: Colors.white, size: 30),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            contact.email,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.purple,
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.white, size: 30),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            formattedPhone,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Botões na parte inferior
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                          AppRoutes.updateContactForm,
                          arguments: contact);
                    },
                    child: const Text(
                      "Editar",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text("Excluir Usuário"),
                                content: const Text("Tem certeza?"),
                                actions: [
                                  TextButton(
                                    child: const Text("Não"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text("Sim"),
                                    onPressed: () {
                                      Provider.of<ContactController>(context,
                                              listen: false)
                                          .delete(contact.id!);

                                      Navigator.of(context)
                                          .pushReplacementNamed(AppRoutes.home);
                                    },
                                  ),
                                ],
                              ));
                    },
                    child: const Text(
                      "Excluir",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
