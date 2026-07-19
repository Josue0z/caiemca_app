import 'package:caiemca_app/functions.dart';
import 'package:caiemca_app/models/airtypes/airtype.dart';
import 'package:caiemca_app/widgets/modal.caiemca.widget.dart';
import 'package:flutter/material.dart';

Future<T> showAirTypeModal<T>({
  required BuildContext context,
  required AirType item,
  bool editing = false,
}) async {
  final GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController name = TextEditingController(text: item.name ?? '');
  submit() async {
    if (formKey.currentState!.validate()) {
      showLoader(context: context);
      try {
        item.name = name.text.trim();
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
        title: editing ? 'Editando Tipo' : 'Creando Tipo...',
        btnTitle: editing ? 'EDITAR' : 'CONFIRMAR',
        height: 250,
        onSubmit: submit,
        children: [
          TextFormField(
            controller: name,
            autofocus: true,
            validator: (val) => val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
            decoration: InputDecoration(
              labelText: 'TIPO',
              hintText: 'Escribir algo...',
            ),
          ),
        ],
      ),
    ),
  );
}
