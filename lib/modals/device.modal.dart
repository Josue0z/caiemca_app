import 'package:caiemca_app/functions.dart';
import 'package:caiemca_app/models/devices/device.dart';
import 'package:caiemca_app/models/models/model.dart';
import 'package:caiemca_app/settings.dart';
import 'package:caiemca_app/widgets/modal.caiemca.widget.dart';
import 'package:flutter/material.dart';

Future<T> showDeviceModal<T>({
  required BuildContext context,
  required DeviceCaiemca item,
  bool editing = false,
}) async {
  final GlobalKey<FormState> formKey = GlobalKey();
  int? currentBrandId = item.brandId;
  int? currentModelId = item.modelId;
  int? currentAirTypeId = item.airTypeId;
  int? currentAirLocationId = item.locationId;
  TextEditingController clientName = TextEditingController(
    text: item.clientName ?? '',
  );
  TextEditingController brancheName = TextEditingController(
    text: item.brancheName ?? '',
  );

  TextEditingController serialNumber = TextEditingController(
    text: item.serialNumber ?? '',
  );
  TextEditingController amperes = TextEditingController(
    text: item.amperes == 0 ? '' : item.amperes?.toStringAsFixed(2) ?? '',
  );

  TextEditingController volt = TextEditingController(
    text: item.volt == 0 ? '' : item.volt?.toStringAsFixed(2) ?? '',
  );
  submit() async {
    if (formKey.currentState!.validate()) {
      showLoader(context: context);
      try {
        item.brandId = currentBrandId;
        item.modelId = currentModelId;
        item.airTypeId = currentAirTypeId;
        item.locationId = currentAirLocationId;
        item.serialNumber = serialNumber.text.isEmpty
            ? null
            : serialNumber.text.trim();
        item.volt = double.tryParse(volt.text) ?? 0.00;
        item.amperes = double.tryParse(amperes.text) ?? 0.00;

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
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ModalCaiemcaWidget(
        title: editing ? 'Editando Dispositivo' : 'Creando Dispositivo...',
        btnTitle: editing ? 'EDITAR' : 'CONFIRMAR',
        height: 500,
        onSubmit: submit,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            child: TextFormField(
              controller: clientName,
              readOnly: true,

              decoration: InputDecoration(
                labelText: 'CLIENTE',
                hintText: 'Escribir algo...',
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            child: TextFormField(
              controller: brancheName,
              autofocus: true,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'SUCURSAL',
                hintText: 'Escribir algo...',
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            child: DropdownButtonFormField(
              initialValue: currentAirLocationId,
              validator: (val) => val == null ? 'CAMPO OBLIGATORIO' : null,
              decoration: InputDecoration(labelText: 'UBICACION'),
              items: List.generate(airLocations.length, (index) {
                var airLocation = airLocations[index];
                return DropdownMenuItem(
                  value: airLocation.id,
                  child: Text(airLocation.name ?? ''),
                );
              }),
              onChanged: (val) {
                currentAirLocationId = val;
              },
            ),
          ),
          ModelsListSelectorWidget(
            currentBrandId: currentBrandId,
            currentModelId: currentModelId,
            currentAirTypeId: currentAirTypeId,
            onChanged: (brandId, modelId, airTypeId) {
              currentBrandId = brandId;
              currentModelId = modelId;
              currentAirTypeId = airTypeId;
            },
          ),

          Container(
            margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            child: TextFormField(
              controller: serialNumber,
              autofocus: true,
              validator: (val) => val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
              decoration: InputDecoration(
                labelText: 'SERIAL',
                hintText: 'Escribir algo...',
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            child: TextFormField(
              controller: amperes,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'AMPERES',
                hintText: 'Escribir algo...',
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            child: TextFormField(
              controller: volt,
              autofocus: true,
              textInputAction: TextInputAction.send,
              onFieldSubmitted: (_) => submit(),
              decoration: InputDecoration(
                labelText: 'VOLT',
                hintText: 'Escribir algo...',
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class ModelsListSelectorWidget extends StatefulWidget {
  int? currentBrandId;
  int? currentModelId;
  int? currentAirTypeId;
  Function(int? brandId, int? modelId, int? airTypeId)? onChanged;
  ModelsListSelectorWidget({
    super.key,
    this.currentBrandId,
    this.currentModelId,
    this.currentAirTypeId,
    this.onChanged,
  });

  @override
  State<ModelsListSelectorWidget> createState() =>
      _ModelsListSelectorWidgetState();
}

class _ModelsListSelectorWidgetState extends State<ModelsListSelectorWidget> {
  @override
  void dispose() {
    brands = [];
    models = [];
    airsTypes = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
          child: DropdownButtonFormField(
            initialValue: widget.currentBrandId,
            validator: (val) => val == null ? 'CAMPO OBLIGATORIO' : null,
            decoration: InputDecoration(labelText: 'MARCA'),
            items: List.generate(brands.length, (index) {
              var brand = brands[index];
              return DropdownMenuItem(
                value: brand.id,
                child: Text(brand.name ?? ''),
              );
            }),
            onChanged: (val) async {
              try {
                showLoader(context: context);
                widget.currentModelId = null;
                widget.currentAirTypeId = null;
                widget.currentBrandId = val;

                models = [
                  ModelCaiemca(name: 'MODELO'),
                  ...await ModelCaiemca.get(brandId: widget.currentBrandId),
                ];
                Navigator.pop(context);
                if (widget.onChanged != null) {
                  widget.onChanged!(
                    widget.currentBrandId,
                    widget.currentModelId,
                    widget.currentAirTypeId,
                  );
                }
                setState(() {});
              } catch (e) {
                Navigator.pop(context);
                showTopSnackBar(
                  context,
                  message: e.toString(),
                  color: Colors.red,
                );
              }
            },
          ),
        ),

        Container(
          margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
          child: DropdownButtonFormField(
            initialValue: widget.currentModelId,
            validator: (val) => val == null ? 'CAMPO OBLIGATORIO' : null,
            decoration: InputDecoration(labelText: 'MODELO'),
            items: List.generate(models.length, (index) {
              var model = models[index];
              return DropdownMenuItem(
                value: model.id,
                child: Text(model.name ?? ''),
              );
            }),
            onChanged: (val) async {
              setState(() {
                widget.currentModelId = val;
                var xmodel = models.firstWhere((e) => e.id == val);
                widget.currentAirTypeId = xmodel.airTypeId;

                if (widget.onChanged != null) {
                  widget.onChanged!(
                    widget.currentBrandId,
                    widget.currentModelId,
                    widget.currentAirTypeId,
                  );
                }
              });
            },
          ),
        ),

        Container(
          margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
          child: DropdownButtonFormField(
            initialValue: widget.currentAirTypeId,

            validator: (val) =>
                widget.currentAirTypeId == null ? 'CAMPO OBLIGATORIO' : null,
            decoration: InputDecoration(labelText: 'TIPO', hintText: 'TIPO'),
            items: List.generate(airsTypes.length, (index) {
              var airType = airsTypes[index];
              return DropdownMenuItem(
                value: airType.id,
                enabled: false,
                child: Text(airType.name ?? ''),
              );
            }),
            onChanged: null,
          ),
        ),
      ],
    );
  }
}
