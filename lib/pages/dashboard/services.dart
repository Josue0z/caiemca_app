import 'package:caiemca_app/modals/service.modal.dart';
import 'package:caiemca_app/models/services/service.dart';
import 'package:caiemca_app/settings.dart';
import 'package:caiemca_app/widgets/caiemca-listview.widget.dart';
import 'package:flutter/material.dart';

class ServicesDashboardPage extends StatefulWidget {
  const ServicesDashboardPage({super.key});

  @override
  State<ServicesDashboardPage> createState() => _ServicesDashboardPageState();
}

class _ServicesDashboardPageState extends State<ServicesDashboardPage> {
  Future? future;
  List<ServiceCaiemca> services = [];

  _loadServices() async {
    try {
      services = await ServiceCaiemca.get();
      setState(() {});
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    setState(() {
      future = _loadServices();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tus Servicios',
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
            items: services,
            icon: Icons.cleaning_services_outlined,
            labelAction: 'Servicio',
            onEdit: (item) async {
              print('editando: $item');
              if (item is ServiceCaiemca) {
                var res = await showServiceModal<String?>(
                  context: context,
                  item: item,
                  editing: true,
                );
                if (res != null) {
                  setState(() {
                    future = _loadServices();
                  });
                }
              }
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var res = await showServiceModal<String?>(
            context: context,
            item: ServiceCaiemca(),
          );

          if (res != null) {
            setState(() {
              future = _loadServices();
            });
          }
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
