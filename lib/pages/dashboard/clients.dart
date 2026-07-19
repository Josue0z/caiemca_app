import 'package:caiemca_app/l10n/app_localizations.dart';
import 'package:caiemca_app/modals/client.modal.dart';
import 'package:caiemca_app/models/clients/client.dart';
import 'package:caiemca_app/pages/dashboard/branches.dart';
import 'package:caiemca_app/settings.dart';
import 'package:caiemca_app/widgets/caiemca-listview.widget.dart';
import 'package:flutter/material.dart';

class ClientsDashboardPage extends StatefulWidget {
  const ClientsDashboardPage({super.key});

  @override
  State<ClientsDashboardPage> createState() => _ClientsDashboardPageState();
}

class _ClientsDashboardPageState extends State<ClientsDashboardPage> {
  Future? future;
  List<Client> clients = [];

  _loadClients() async {
    try {
      clients = await Client.get();
      setState(() {});
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    setState(() {
      future = _loadClients();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.clients,
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
            items: clients,
            icon: Icons.person_3_outlined,
            labelAction: 'Cliente',
            othersOptions: [
              {
                'id': 2,
                'name': 'Ver Sucursales',
                'icon': Icon(Icons.store_outlined),
                'call': (item) async {
                  print('selected: $item');
                  if (item is Client) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => BranchesDashboardPage(client: item),
                      ),
                    );
                  }
                },
              },
            ],
            onEdit: (item) async {
              if (item is Client) {
                var res = await showClientModal<String?>(
                  context: context,
                  item: item,
                  editing: true,
                );
                if (res != null) {
                  setState(() {
                    future = _loadClients();
                  });
                }
              }
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var res = await showClientModal<String?>(
            context: context,
            item: Client(),
          );
          if (res != null) {
            setState(() {
              future = _loadClients();
            });
          }
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
