import 'package:caiemca_app/functions.dart';
import 'package:caiemca_app/models/models/model.dart';
import 'package:caiemca_app/settings.dart';
import 'package:caiemca_app/widgets/modal.caiemca.widget.dart';
import 'package:flutter/material.dart';

Future<T> showModelModal<T>({
  required BuildContext context,
  required ModelCaiemca item,
  bool editing = false,
}) async {
  final GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController brandName = TextEditingController(
    text: item.brandName ?? '',
  );
  TextEditingController modelName = TextEditingController(
    text: item.name ?? '',
  );
  int? currentAirType = item.airTypeId;

  submit() async {
    if (formKey.currentState!.validate()) {
      showLoader(context: context);
      try {
        item.name = modelName.text.trim();
        item.airTypeId = currentAirType;

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
        title: editing ? 'Editando Modelo' : 'Creando Modelo...',
        btnTitle: editing ? 'EDITAR' : 'CONFIRMAR',
        height: 420,
        onSubmit: submit,
        children: [
          SizedBox(height: kDefaultPadding / 2),
          TextFormField(
            controller: brandName,
            autofocus: false,
            readOnly: true,
            validator: (val) => val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
            decoration: InputDecoration(
              labelText: 'MARCA',
              hintText: 'Escribir algo...',
            ),
          ),
          SizedBox(height: kDefaultPadding),
          TextFormField(
            controller: modelName,
            autofocus: true,
            validator: (val) => val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
            decoration: InputDecoration(
              labelText: 'MODELO',
              hintText: 'Escribir algo...',
            ),
          ),
          SizedBox(height: kDefaultPadding),
          DropdownButtonFormField(
            initialValue: currentAirType,
            validator: (val) => val == null ? 'CAMPO OBLIGATORIO' : null,
            decoration: InputDecoration(
              labelText: 'TIPO',
              hintText: 'SELECCIONAR TIPO...',
            ),
            items: List.generate(airsTypes.length, (index) {
              var type = airsTypes[index];
              return DropdownMenuItem(
                value: type.id,
                child: Text(type.name ?? ''),
              );
            }),
            onChanged: (val) {
              currentAirType = val;
            },
          ),
          SizedBox(height: kDefaultPadding),
        ],
      ),
    ),
  );
}
