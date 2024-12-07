import 'package:app_contatos/app/controllers/contact_controller.dart';
import 'package:app_contatos/app/repositories/contact_repository.dart';
import 'package:app_contatos/app/routes/app_routes.dart';
import 'package:app_contatos/app/views/contact_details_view.dart';
import 'package:app_contatos/app/views/create_contact_view.dart';
import 'package:app_contatos/app/views/update_contact_view.dart';
import 'package:app_contatos/app/views/list_contact_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => ContactController(ContactRepository()),
          )
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
                color: Colors.purple,
                iconTheme: IconThemeData(color: Colors.white)),
          ),
          routes: {
            AppRoutes.home: (context) => const ListContactView(),
            AppRoutes.createContactForm: (context) => CreateContactView(),
            AppRoutes.updateContactForm: (context) => UpdateContactView(),
            AppRoutes.contactDetails: (context) => const ContactDetailsView(),
          },
        ));
  }
}
