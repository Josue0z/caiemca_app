import 'package:caiemca_app/functions.dart';
import 'package:caiemca_app/modals/device.modal.dart';
import 'package:caiemca_app/modals/showmodal.qr.dart';
import 'package:caiemca_app/models/airlocations/airlocation.dart';
import 'package:caiemca_app/models/airtypes/airtype.dart';
import 'package:caiemca_app/models/branches/branche.dart';
import 'package:caiemca_app/models/brands/brand.dart';
import 'package:caiemca_app/models/clients/client.dart';
import 'package:caiemca_app/models/devices/device.dart';
import 'package:caiemca_app/models/models/model.dart';
import 'package:caiemca_app/settings.dart';
import 'package:caiemca_app/widgets/caiemca-listview.widget.dart';
import 'package:flutter/material.dart';

class DevicesDashboardPage extends StatefulWidget {
  final BrancheCaiemca? branche;
  final Client? client;
  bool selector;
  DevicesDashboardPage({super.key, this.branche, this.client,this.selector = false});

  @override
  State<DevicesDashboardPage> createState() => _DevicesDashboardPageState();
}

class _DevicesDashboardPageState extends State<DevicesDashboardPage> {
  List<DeviceCaiemca> devices = [];

  Future? future;

  _loadDevices() async {
    try {
      devices = await DeviceCaiemca.get(brancheId: widget.branche?.id);
      setState(() {});
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    setState(() {
      future = _loadDevices();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '(${devices.length}) ${widget.branche?.name} - Dispositivos',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: kBodyTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          SizedBox(width: kDefaultPadding),
        ],
      ),
      body: FutureBuilder(
        future: future,
        builder: (ctx, s) {
          if (s.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (s.hasError) {
            return Center(child: Column(children: [Text(s.error.toString())]));
          }

          return CaiemcaListView(
            items: devices,
            selector: widget.selector,
            othersOptions: [
                 {
                'id': 2,
                'name': 'Ver Codigo Qr',
                'icon': Icon(Icons.qr_code),
                'call': (item)  {
                  print('selected: $item');
                  if (item is DeviceCaiemca) {
                     showQrModal(context,item);
                  }
                },
              },
            ],
            onSelected: (item){
               if(item is DeviceCaiemca){
                  Navigator.pop(context,item);
               }
            },
            icon: Icons.air_outlined,
            labelAction: 'Dispositivo',
          
            builderTitle: (ctx, item) {
              if (item is DeviceCaiemca) {
                return Text('${item.brandName} ${item.modelName}');
              }
              return SizedBox();
            },
            builderSubtitle: (ctx, item) {
              if (item is DeviceCaiemca) {
                return Text('${item.airLocationName} - ${item.airTypeName}');
              }
              return SizedBox();
            },
            onEdit: (item) async {
              print('editando: $item');
              showLoader(context: context);
              try {
                if (item is DeviceCaiemca) {
                  brands = [BrandCaiemca(name: 'MARCA'),...await BrandCaiemca.get()];
                  models = [ModelCaiemca(name: 'MODELO'), ...await ModelCaiemca.get(brandId: item.brandId)];
                  airsTypes = airsTypes = [AirType(name: 'TIPO'), ...await AirType.get()];
                  airLocations =[AirLocationCaiemca(name: 'UBICACION'), ...await AirLocationCaiemca.get()];
                  Navigator.pop(context);
                  var res = await showDeviceModal<String?>(
                    context: context,
                    item: item,
                    editing: true,
                  );
                  if (res != null) {
                    setState(() {
                      future = _loadDevices();
                    });
                  }
                }
              } catch (e) {
                Navigator.pop(context);
                showTopSnackBar(
                  context,
                  message: e.toString(),
                  color: Colors.red,
                );
              }
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showLoader(context: context);
          try {
            brands = [BrandCaiemca(name: 'MARCA'),...await BrandCaiemca.get()];
            airsTypes = [AirType(name: 'TIPO'), ...await AirType.get()];
            airLocations = [AirLocationCaiemca(name: 'UBICACION'), ...await AirLocationCaiemca.get()];
            Navigator.pop(context);
            var res = await showDeviceModal<String?>(
              context: context,
              item: DeviceCaiemca(
                brancheId: widget.branche?.id,
                brancheName: widget.branche?.name,
                clientName: widget.client?.name,
              ),
         
            );

            if (res != null) {
              setState(() {
                future = _loadDevices();
              });
            }
          } catch (e) {
            Navigator.pop(context);
            showTopSnackBar(context, message: e.toString(), color: Colors.red);
          }
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
