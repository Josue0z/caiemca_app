import 'package:caiemca_app/functions.dart';
import 'package:caiemca_app/models/technicians/technicians.dart';
import 'package:caiemca_app/settings.dart';
import 'package:caiemca_app/widgets/modal.caiemca.widget.dart';
import 'package:flutter/material.dart';

Future<T> showTechnicianModal<T>({
  required BuildContext context,
  required TechnicianCaiemca item,
  bool editing = false,
}) async {
  final GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController name = TextEditingController(text: item.name ?? '');
  TextEditingController identification = TextEditingController(
    text: item.identification ?? '',
  );

  TextEditingController phone = TextEditingController(text: item.phone ?? '');

  TextEditingController email = TextEditingController(text: item.email ?? '');
  submit() async {
    if (formKey.currentState!.validate()) {
      showLoader(context: context);
      try {
        item.name = name.text.trim();
        item.identification = identification.text.trim();
        item.phone = phone.text.isEmpty ? null : phone.text.trim();
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
        title: editing ? 'Editando Técnico' : 'Creando Técnico...',
        btnTitle: editing ? 'EDITAR' : 'CONFIRMAR',
        onSubmit: submit,
        children: [
          Container(
            margin: EdgeInsets.only(top: kDefaultPadding/2, bottom: kDefaultPadding),
            child: TextFormField(
              controller: name,
              autofocus: true,
              validator: (val) => val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
              decoration: InputDecoration(
                labelText: 'TÉCNICO',
                hintText: 'Escribir nombre...',
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(bottom: kDefaultPadding),
            child: TextFormField(
              controller: identification,
              validator: (val) => val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
              decoration: InputDecoration(
                labelText: 'IDENTIFICACION',
                hintText: '000000000000',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: kDefaultPadding),
            child: TextFormField(
              controller: phone,
              decoration: InputDecoration(
                labelText: 'TELÉFONO',
                hintText: '000000000000',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: kDefaultPadding),
            child: TextFormField(
              controller: email,
              decoration: InputDecoration(
                labelText: 'CORREO',
                hintText: 'contact@example.com',
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
