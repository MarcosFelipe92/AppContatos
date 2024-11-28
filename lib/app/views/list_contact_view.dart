import 'package:app_contatos/app/components/app_bar_title.dart';
import 'package:app_contatos/app/components/contact_tile.dart';
import 'package:app_contatos/app/components/custom_button.dart';
import 'package:app_contatos/app/components/custom_search_bar.dart';
import 'package:app_contatos/app/controllers/contact_controller.dart';
import 'package:app_contatos/app/models/contact.dart';
import 'package:app_contatos/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListContactView extends StatefulWidget {
  const ListContactView({super.key});

  @override
  State<ListContactView> createState() => _ListContactViewState();
}

class _ListContactViewState extends State<ListContactView> {
  final TextEditingController _searchController = TextEditingController();
  List<Contact> _filteredContacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final contactController =
        Provider.of<ContactController>(context, listen: false);
    final contacts = await contactController.findAll();
    setState(() {
      _filteredContacts = contacts; // Inicializa contatos filtrados
    });
  }

  void _filterContacts(String query) {
    final contactController =
        Provider.of<ContactController>(context, listen: false);

    setState(() {
      _filteredContacts = contactController.contacts
          .where((contact) =>
              contact.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppBarTitle(
          label: "Lista de Contatos",
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: CustomSearchBar(
            controller: _searchController,
            onChanged: _filterContacts,
          ),
        ),
      ),
      body: Consumer<ContactController>(
        builder: (context, contactController, child) {
          if (contactController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              Expanded(
                child: _filteredContacts.isEmpty
                    ? const Center(child: Text('Nenhum contato encontrado.'))
                    : ListView.builder(
                        itemCount: _filteredContacts.length,
                        itemBuilder: (context, index) =>
                            ContactTile(contact: _filteredContacts[index]),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: CustomButton(
                    label: "Adicionar Contatos",
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(AppRoutes.createContactForm);
                    }),
              ),
            ],
          );
        },
      ),
    );
  }
}
