import 'package:app_contatos/app/controllers/contact_controller.dart';
import 'package:app_contatos/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactDetailsView extends StatelessWidget {
  const ContactDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final contactId = ModalRoute.of(context)!.settings.arguments as int;
    final contact = Provider.of<ContactController>(context).findById(contactId);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Detalhes do Contato",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
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
                Text(
                  contact.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  contact.email,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  contact.phone,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
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
                                          .pushNamed(AppRoutes.home);
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
