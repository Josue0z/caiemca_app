import 'package:caiemca_app/functions.dart';
import 'package:caiemca_app/models/aircomponentdetails/airComponentDetails.dart';
import 'package:caiemca_app/models/airitems/airitem.dart';
import 'package:caiemca_app/models/branches/branche.dart';
import 'package:caiemca_app/models/clients/client.dart';
import 'package:caiemca_app/models/components/component.dart';
import 'package:caiemca_app/models/devices/device.dart';
import 'package:caiemca_app/models/failures/failures.dart';
import 'package:caiemca_app/models/failuresdetails/failuresdetails.dart';
import 'package:caiemca_app/models/forms/form.ciaemca.dart';
import 'package:caiemca_app/models/responsibles/responsible.dart';
import 'package:caiemca_app/models/servicedetails/servicedetails.dart';
import 'package:caiemca_app/models/services/service.dart';
import 'package:caiemca_app/models/technicians/technicians.dart';
import 'package:caiemca_app/models/techniciansDetails/techniciansDetails.dart';
import 'package:caiemca_app/pages/crud/qr_code_scan_page.dart';
import 'package:caiemca_app/pages/dashboard/devices.dart';
import 'package:caiemca_app/settings.dart';
import 'package:caiemca_app/widgets/btn.caiemca.button.widget.dart';
import 'package:caiemca_app/widgets/modal.search.widget.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class FormGeneratorPage extends StatefulWidget {
  FormCaiemca formCaiemca;
  FormGeneratorPage({super.key, required this.formCaiemca});

  @override
  State<FormGeneratorPage> createState() => _FormGeneratorPageState();
}

class _FormGeneratorPageState extends State<FormGeneratorPage> {
  Future? future;

  String? currentClientId;
  Client? currentClient;
  int? currentBrancheId;
  BrancheCaiemca? currentBranche;
  String? currentResponsableId;
  TextEditingController serialNumber = TextEditingController();
  TextEditingController responsableIdentification = TextEditingController();
  TextEditingController responsableName = TextEditingController();

  List<AirItemCaiemca> airItems = [];
  List<ServiceCaiemca> selectedServices =[ ];

  ScrollController verticalScrollController = ScrollController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
 
  List<TechnicianCaiemca> selectedTechnicians = [];
  _loadData() async {
    try {
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  _onSubmit() async {
    if(formKey.currentState!.validate()){
       showLoader(context: context);
    try {
      widget.formCaiemca.clientId = currentClientId;
      widget.formCaiemca.branchId = currentBrancheId;
      widget.formCaiemca.workerId = currentUser?.id;
      widget.formCaiemca.responsibleIdentification =
          responsableIdentification.text;
      widget.formCaiemca.responsibleName = responsableName.text;
      widget.formCaiemca.services = List.generate(selectedServices.length, (i) {
        var service = selectedServices[i];
        return ServiceDetailsCaiemca(
          serviceId: service.id,
          description: service.name ?? '',
          check: true,
        );
      });

      widget.formCaiemca.technicians = List.generate(selectedTechnicians.length, (j) {
        var technician = selectedTechnicians[j];
        return TechniciansDetails(
          technicianId: technician.id,
          description: technician.name ?? ''
        );
      });

      widget.formCaiemca.createdAt = DateTime.now();
      widget.formCaiemca.airItems = airItems;

      await widget.formCaiemca.create();
      Navigator.pop(context);
      Navigator.pop(context, widget.formCaiemca);
    } catch (e) {
      Navigator.pop(context);
      showTopSnackBar(context, message: e.toString(), color: Colors.red);
    }
    }
  }

  Widget get contentFilled {
    return SingleChildScrollView(
      controller: verticalScrollController,
      padding: EdgeInsets.all(kDefaultPadding),
      child: Form(
        key:formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: kDefaultPadding),
              child: DropdownButtonFormField(
                initialValue: currentClientId,
                validator: (val) => val == null ? 'CAMPO OBLIGATORIO' : null,
                decoration: InputDecoration(
                  labelText: 'CLIENTE',
                  hintText: 'SELECCIONA CLIENTE...',
                ),
                items: List.generate(allClients.length, (index) {
                  var client = allClients[index];
                  return DropdownMenuItem(
                    value: client.id,
                    child: Text(client.name ?? ''),
                  );
                }),
                onChanged: (val) async {
                  currentClientId = val;
                  currentClient = allClients.firstWhere(
                    (e) => e.id == currentClientId,
                    orElse: () => Client(),
                  );
                  currentBrancheId = null;
                  allBranches = [];
                  showLoader(context: context);
                  try {
                    allBranches = await BrancheCaiemca.get(
                      clientId: currentClientId,
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    Navigator.pop(context);
                    showTopSnackBar(
                      context,
                      message: e.toString(),
                      color: Colors.red,
                    );
                  }
                  setState(() {});
                },
              ),
            ),

            Container(
              margin: EdgeInsets.only(bottom: kDefaultPadding),
              child: DropdownButtonFormField(
                initialValue: currentBrancheId,
                validator: (val) => val == null ? 'CAMPO OBLIGATORIO' : null,
                decoration: InputDecoration(
                  labelText: 'SUCURSAL',
                  hintText: 'SELECCIONA SUCURSAL...',
                ),
                items: List.generate(allBranches.length, (index) {
                  var branche = allBranches[index];
                  return DropdownMenuItem(
                    value: branche.id,
                    child: Text(branche.name ?? ''),
                  );
                }),
                onChanged: (val) {
                  currentBranche = allBranches.firstWhere(
                    (e) => e.id == val,
                    orElse: () => BrancheCaiemca(),
                  );
                  setState(() {
                    currentBrancheId = val;
                  });
                },
              ),
            ),

            Container(
              margin: EdgeInsets.only(bottom: kDefaultPadding),
              child: TextFormField(
                controller: responsableIdentification,
                textInputAction: TextInputAction.next,
                validator: (value) => value!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
                onChanged: (vals) async {
                  if (vals.length == 11) {
                    responsableName.text = 'Loading...';
                    var res = await ResponsibleCaiemca.findByIdentification(
                      identification: vals,
                    );

                    if (res != null) {
                      responsableName.text = res.name ?? '';
                    } else {
                      responsableName.text = '';
                    }
                  } else {
                    responsableName.text = '';
                  }
                },
                decoration: InputDecoration(
                  labelText: 'CEDULA',
                  hintText: 'Cedula del Responsable...',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: kDefaultPadding),
              child: TextFormField(
                controller: responsableName,
                validator: (value) => value!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'NOMBRE',
                  hintText: 'Nombre del Responsable...',
                ),
              ),
            ),
            Text(
              'Servicios Ofrecidos (${allServices.length})',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: kPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(allServices.length, (i) {
                var service = allServices[i];
                var contains = selectedServices.contains(service);
                return ListTile(
                  leading: Checkbox(
                    value: contains,
                    onChanged: (val) {
                      if (selectedServices.contains(service)) {
                        selectedServices.remove(service);
                      } else {
                        selectedServices.add(service);
                      }
                      setState(() {});
                    },
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: kDefaultPadding / 3,
                  ),
                  title: Text(service.name ?? ''),
                );
              }),
            ),

            airItems.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dispositivos (${airItems.length})',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),

                      ...List.generate(airItems.length, (i) {
                        var airItemCaiemca = airItems[i];
                        return AirItemDeviceWidget(
                          airItemCaiemca: airItemCaiemca,
                          onDelete: (item) {
                            airItems.removeAt(i);
                            setState(() {});
                          },
                        );
                      }),
                    ],
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  _openScan() async {
    var res = await Navigator.push<Barcode?>(
      context,
      MaterialPageRoute(builder: (ctx) => QRViewExample()),
    );

    if (res != null) {
      try {
        showLoader(context: context);
        var device = await DeviceCaiemca.findDeviceBySerialNumber(
          serialNumber: res.code,
          clientId: currentClientId,
          brancheId: currentBrancheId,
        );

        if (device == null) {
          throw 'NO SE ENCONTRO EL DISPOSITIVO CON EL SERIAL: ${res.code} PARA ESTA SUCURSAL';
        }

        var exist =
            airItems
                .firstWhere(
                  (e) => e.deviceId == device.id,
                  orElse: () => AirItemCaiemca(components: [], failures: []),
                )
                .deviceId !=
            null;

        if (exist) {
          throw 'YA EXISTE UN DISPOSITIVO CON ESTE SERIAL: ${res.code} REGISTRADO!';
        }
        Navigator.pop(context);
        airItems.add(
          AirItemCaiemca(
            components: [],
            failures: [],
            deviceId: device.id,
            deviceCaiemca: device,
            companyId: currentUser?.companyId,
            check: true,
          ),
        );

        showTopSnackBar(
          context,
          message: 'DISPOSITIVO CON SERIAL: ${res.code} AGREGADO!',
          color: Colors.green,
        );
        setState(() {});
      } catch (e) {
        Navigator.pop(context);
        showTopSnackBar(context, message: e.toString(), color: Colors.red);
      }
    }
  }

  _searchDevice() async {
    var res = await showModalSearch(
      context: context,
      hintText: 'Numero de Serial...',
    );
    if (res != null) {
      try {
        showLoader(context: context);
        var device = await DeviceCaiemca.findDeviceBySerialNumber(
          serialNumber: res,
          clientId: currentClientId,
          brancheId: currentBrancheId,
        );

        if (device == null) {
          throw 'NO SE ENCONTRO EL DISPOSITIVO CON EL SERIAL: $res PARA ESTA SUCURSAL';
        }

        var exist =
            airItems
                .firstWhere(
                  (e) => e.deviceId == device.id,
                  orElse: () => AirItemCaiemca(components: [], failures: []),
                )
                .deviceId !=
            null;

        if (exist) {
          throw 'YA EXISTE UN DISPOSITIVO CON ESTE SERIAL: $res REGISTRADO!';
        }
        Navigator.pop(context);
        airItems.add(
          AirItemCaiemca(
            components: [],
            failures: [],
            deviceId: device.id,
            deviceCaiemca: device,
            companyId: currentUser?.companyId,
            check: true,
          ),
        );

        showTopSnackBar(
          context,
          message: 'DISPOSITIVO CON SERIAL: $res AGREGADO!',
          color: Colors.green,
        );
        setState(() {});
      } catch (e) {
        Navigator.pop(context);
        showTopSnackBar(context, message: e.toString(), color: Colors.red);
      }
    }
  }

  _openDevicesSelector() async {
    if (currentClientId != null && currentBrancheId != null) {
      var device = await Navigator.push<DeviceCaiemca?>(
        context,
        MaterialPageRoute(
          builder: (ctx) => DevicesDashboardPage(
            client: currentClient,
            branche: currentBranche,
            selector: true,
          ),
        ),
      );
      if (device != null) {
        try {

          var exist =
              airItems
                  .firstWhere(
                    (e) => e.deviceId == device.id,
                    orElse: () => AirItemCaiemca(components: [], failures: []),
                  )
                  .deviceId !=
              null;

          if (exist) {
            throw 'YA EXISTE UN DISPOSITIVO CON ESTE SERIAL: ${device.serialNumber} REGISTRADO!';
          }

          airItems.add(
            AirItemCaiemca(
              components: [],
              failures: [],
              deviceId: device.id,
              deviceCaiemca: device,
              companyId: currentUser?.companyId,
              check: true,
            ),
          );

          showTopSnackBar(
            context,
            message: 'DISPOSITIVO CON SERIAL: ${device.serialNumber} AGREGADO!',
            color: Colors.green,
          );
          setState(() {});

          await Future.delayed(const Duration(milliseconds: 500));
          verticalScrollController.animateTo(
            verticalScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 400),
            curve: Curves.decelerate,
          );
        } catch (e) {
          showTopSnackBar(context, message: e.toString(), color: Colors.red);
        }
      }
    }
  }


    _openTechniciansSelector() async {
    await showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setStateModal) {
            return SizedBox(
              width: double.infinity,
              height: 300,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(kDefaultPadding / 2),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black12)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'SELECCIONAR TECNICOS (${allTechnicians.length})',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: allTechnicians.length,
                      itemBuilder: (ctx, i) {
                        var technician = allTechnicians[i];
                        var has = selectedTechnicians.contains(technician);
                        return ListTile(
                          leading: Checkbox(
                            value: has,
                            onChanged: (val) {
                              if (has) {
                                selectedTechnicians.remove(technician);
                              } else {
                                selectedTechnicians.add(technician);
                              }

                              setStateModal(() {});
                            },
                          ),
                          title: Text(technician.name ?? ''),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    widget.formCaiemca.technicians = List.generate(selectedTechnicians.length, (
      j,
    ) {
      var technician = selectedTechnicians[j];
      return TechniciansDetails(
        technicianId: technician.id,
        description: technician.name
      );
    }).toList();
    setState(() {});
  }

  @override
  void initState() {
    if (!mounted) return;
    setState(() {
      future = _loadData();
    });
    super.initState();
  }

  @override
  void dispose() {
    allComponents = [];
    allFailures = [];
    allClients = [];
    allServices = [];
    allBranches = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CREANDO FORMULARIO...',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          IconButton(onPressed: _searchDevice, icon: Icon(Icons.search)),
          IconButton(
            onPressed: _openDevicesSelector,
            icon: Icon(Icons.list_alt_outlined),
          ),
          IconButton(
            onPressed: _openTechniciansSelector,
            icon: Icon(Icons.person_2_rounded),
          ),
          IconButton(
            tooltip: 'ESCANEAR SERIAL',
            onPressed: _openScan,
            icon: Icon(Icons.qr_code_scanner),
          ),
          SizedBox(width: kDefaultPadding),
        ],
      ),

      body: FutureBuilder(
        future: future,
        builder: (ctx, s) {
          if (s.connectionState == ConnectionState.waiting &&
              allClients.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          if (s.hasError) {
            return Container(child: Text(s.error.toString()));
          }
          return contentFilled;
        },
      ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(kDefaultPadding),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: CaiemcaButtonWidget(
            title: 'CREAR FORMULARIO',
            onPressed: _onSubmit,
          ),
        ),
      ),
    );
  }
}

class AirItemDeviceWidget extends StatefulWidget {
  AirItemCaiemca airItemCaiemca;

  Function(AirItemCaiemca) onDelete;
  AirItemDeviceWidget({
    super.key,
    required this.airItemCaiemca,
    required this.onDelete,
  });

  @override
  State<AirItemDeviceWidget> createState() => _AirItemDeviceWidgetState();
}

class _AirItemDeviceWidgetState extends State<AirItemDeviceWidget> {
  List<ComponentCaiemca> selectedComponents = [];
  List<Failures> selectedFailures = [];

  _openComponentsSheet() async {
    await showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setStateModal) {
            return SizedBox(
              width: double.infinity,
              height: 300,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(kDefaultPadding / 2),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black12)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'SELECCIONAR COMPONENTES (${allComponents.length})',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: allComponents.length,
                      itemBuilder: (ctx, i) {
                        var component = allComponents[i];
                        var has = selectedComponents.contains(component);
                        return ListTile(
                          leading: Checkbox(
                            value: has,
                            onChanged: (val) {
                              if (has) {
                                selectedComponents.remove(component);
                              } else {
                                selectedComponents.add(component);
                              }

                              setStateModal(() {});
                            },
                          ),
                          title: Text(component.name ?? ''),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    widget.airItemCaiemca.components = List.generate(
      selectedComponents.length,
      (j) => AirComponentDetails(componentId: selectedComponents[j].id),
    ).toList();
    setState(() {});
  }

  _openFailuresSheet() async {
    await showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setStateModal) {
            return SizedBox(
              width: double.infinity,
              height: 300,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(kDefaultPadding / 2),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black12)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'SELECCIONAR FALLAS (${allFailures.length})',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: allFailures.length,
                      itemBuilder: (ctx, i) {
                        var failure = allFailures[i];
                        var has = selectedFailures.contains(failure);
                        return ListTile(
                          leading: Checkbox(
                            value: has,
                            onChanged: (val) {
                              if (has) {
                                selectedFailures.remove(failure);
                              } else {
                                selectedFailures.add(failure);
                              }

                              setStateModal(() {});
                            },
                          ),
                          title: Text(failure.name ?? ''),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    widget.airItemCaiemca.failures = List.generate(selectedFailures.length, (
      j,
    ) {
      var failure = selectedFailures[j];
      return FailuresDetails(
        failureId: failure.id,
        description: failure.name,
        deviceId: widget.airItemCaiemca.deviceId,
        check: true,
      );
    }).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: kDefaultPadding),
          padding: EdgeInsets.all(kDefaultPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kDefaultPadding / 2),
            color: const Color.fromARGB(31, 197, 197, 197),
            border: Border.all(color: Colors.black38),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SERIAL',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: kPrimaryColor),
                      ),
                      Text(
                        widget.airItemCaiemca.deviceCaiemca?.serialNumber ?? '',
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.onDelete(widget.airItemCaiemca);
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: kDefaultPadding / 2),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MARCA',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: kPrimaryColor),
                        ),
                        Text(
                          widget.airItemCaiemca.deviceCaiemca?.brandName ?? '',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MODELO',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: kPrimaryColor),
                        ),
                        Text(
                          widget.airItemCaiemca.deviceCaiemca?.modelName ?? '',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'UBICACION',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: kPrimaryColor),
                        ),
                        Text(
                          widget
                                  .airItemCaiemca
                                  .deviceCaiemca
                                  ?.airLocationName ??
                              '',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        selectedComponents.isNotEmpty
            ? Container(
                margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
                child: Text(
                  'COMPONENTES: (${selectedComponents.map((e) => e.name).toList().join(',')})',
                ),
              )
            : SizedBox(),
        selectedFailures.isNotEmpty
            ? Container(
                margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
                child: Text(
                  'FALLOS: (${selectedFailures.map((e) => e.name).toList().join(',')})',
                ),
              )
            : SizedBox(),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: CaiemcaButtonWidget(
                  dangerButton: true,
                  title: selectedFailures.isEmpty
                      ? 'Registrar Fallas'
                      : 'Editar Fallas',
                  onPressed: _openFailuresSheet,
                ),
              ),
            ),

            SizedBox(width: kDefaultPadding / 2),

            Expanded(
              child: SizedBox(
                height: 40,
                child: CaiemcaButtonWidget(
                  title: selectedComponents.isEmpty
                      ? 'Añadir Componentes'
                      : 'Editar Componentes',
                  onPressed: selectedFailures.isEmpty
                      ? null
                      : _openComponentsSheet,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
