import 'package:caiemca_app/functions.dart';
import 'package:caiemca_app/models/clients/client.dart';
import 'package:caiemca_app/settings.dart';
import 'package:caiemca_app/widgets/modal.caiemca.widget.dart';
import 'package:flutter/material.dart';

Future<T> showClientModal<T>({
  required BuildContext context,
  required Client item,
  bool editing = false,
}) async {
  final GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController name = TextEditingController(text: item.name ?? '');
  TextEditingController phone = TextEditingController(text: item.phone ?? '');
  TextEditingController identification = TextEditingController(
    text: item.identification ?? '',
  );
  TextEditingController email = TextEditingController(text: item.email ?? '');
  submit() async {
    if (formKey.currentState!.validate()) {
      showLoader(context: context);
      try {
        item.name = name.text.trim();
        item.phone = phone.text.isEmpty ? null : phone.text.trim();
        item.identification = identification.text.isEmpty
            ? null
            : identification.text.trim();
        item.email = email.text.isEmpty ? null : email.text.trim();
        if (editing) {
          await item.update();
        } else {
          await item.create();
        }
        Navigator.pop(context);
        Navigator.pop(context, item.toMap().toString());
      } catch (e) {
        Navigator.pop(context);
        showTopSnackBar(context, message: e.toString(), color: Colors.red);
      }
    }
  }

  return await showDialog(
    context: context,
    builder: (ctx) => Form(
      key: formKey,
      child: ModalCaiemcaWidget(
        title: editing ? 'Editando Cliente...' : 'Creando Cliente...',
        btnTitle: editing ? 'EDITAR' : 'CONFIRMAR',
        height: 500,
        onSubmit: submit,
        children: [
       
          Container(
            margin: EdgeInsets.only(top: kDefaultPadding/2, bottom: kDefaultPadding),
            child: TextFormField(
              controller: identification,
              autofocus: true,
              validator: (val) => val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'IDENTIFICACION',
                hintText: 'Escribir algo...',
              ),
            ),
          ),

             Container(
            margin: EdgeInsets.only(
              bottom: kDefaultPadding,
            ),
            child: TextFormField(
              controller: name,
              validator: (val) => val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'CLIENTE',
                hintText: 'Escribir algo...',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: kDefaultPadding),
            child: TextFormField(
              controller: phone,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'TELEFONO',
                hintText: 'Escribir algo...',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: kDefaultPadding),
            child: TextFormField(
              controller: email,
              textInputAction: TextInputAction.send,
              onFieldSubmitted: (_) => submit(),
              decoration: InputDecoration(
                labelText: 'CORREO',
                hintText: 'Escribir algo...',
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
