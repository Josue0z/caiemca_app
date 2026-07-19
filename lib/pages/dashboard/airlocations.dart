import 'package:caiemca_app/l10n/app_localizations.dart';
import 'package:caiemca_app/modals/airlocation.modal.dart';
import 'package:caiemca_app/models/airlocations/airlocation.dart';
import 'package:caiemca_app/settings.dart';
import 'package:caiemca_app/widgets/caiemca-listview.widget.dart';
import 'package:flutter/material.dart';

class AirLocationsDashboardPage extends StatefulWidget {
  const AirLocationsDashboardPage({super.key});

  @override
  State<AirLocationsDashboardPage> createState() =>
      _AirLocationsDashboardPageState();
}

class _AirLocationsDashboardPageState extends State<AirLocationsDashboardPage> {
  List<AirLocationCaiemca> airLocations = [];
  Future? future;

  _loadAirLocations() async {
    try {
      airLocations = await AirLocationCaiemca.get();
      setState(() {});
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    setState(() {
      future = _loadAirLocations();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.locations,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: kBodyTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
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
            items: airLocations,
            icon: Icons.air_outlined,
            labelAction: 'Ubicacion',
            onEdit: (item) async {
              if (item is AirLocationCaiemca) {
                var res = await showAirLocationModal<String?>(
                  context: context,
                  item: item,
                  editing: true,
                );
                if (res != null) {
                  setState(() {
                    future = _loadAirLocations();
                  });
                }
              }
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var res = await showAirLocationModal<String?>(
            context: context,
            item: AirLocationCaiemca(),
          );
          if (res != null) {
            setState(() {
              future = _loadAirLocations();
            });
          }
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
