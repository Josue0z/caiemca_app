import 'package:caiemca_app/l10n/app_localizations.dart';
import 'package:caiemca_app/modals/branche.modal.dart';
import 'package:caiemca_app/models/branches/branche.dart';
import 'package:caiemca_app/models/clients/client.dart';
import 'package:caiemca_app/pages/dashboard/devices.dart';
import 'package:caiemca_app/settings.dart';
import 'package:caiemca_app/widgets/caiemca-listview.widget.dart';
import 'package:flutter/material.dart';

class BranchesDashboardPage extends StatefulWidget {
  Client? client;
  BranchesDashboardPage({super.key, required this.client});

  @override
  State<BranchesDashboardPage> createState() => _BranchesDashboardPageState();
}

class _BranchesDashboardPageState extends State<BranchesDashboardPage> {
  List<BrancheCaiemca> branches = [
    BrancheCaiemca(id: 1, name: 'CORAL'),
    BrancheCaiemca(id: 2, name: 'BÁVARO'),
    BrancheCaiemca(id: 3, name: 'CUMAYASA I'),
    BrancheCaiemca(id: 4, name: 'CUMAYASA II'),
    BrancheCaiemca(id: 5, name: 'EMBRUJO'),
    BrancheCaiemca(id: 6, name: 'YAPUR DUMIT'),
  ];

  Future? future;

  _loadBranches() async {
    try {
      branches = await BrancheCaiemca.get(clientId: widget.client?.id);
      setState(() {});
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    setState(() {
      future = _loadBranches();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sucursales - ${widget.client?.name}',
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
            items: branches,
            icon: Icons.air_outlined,
            labelAction: 'Sucursal',
            othersOptions: [
                {
                'id': 2,
                'name': 'Ver Dispositivos',
                'icon': Icon(Icons.air_outlined),
                'call': (item) async {
                  print('selected: $item');
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => DevicesDashboardPage(branche: item,client: widget.client),
                    ),
                  );
                },
              },
            ],
            onEdit: (item) async{
              print('editando: $item');
                  if (item is BrancheCaiemca) {
                var res = await showBrancheModal<String?>(
                  context: context,
                  item: item,
                  editing: true,
                );
                if (res != null) {
                  setState(() {
                    future = _loadBranches();
                  });
                }
              }
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async{
             var res = await showBrancheModal<String?>(
                  context: context,
                  item: BrancheCaiemca(
                    clientId: widget.client?.id
                  ),
                );
                if (res != null) {
                  setState(() {
                    future = _loadBranches();
                  });
                }
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
