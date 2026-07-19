import 'package:caiemca_app/l10n/app_localizations.dart';
import 'package:caiemca_app/modals/airtype.modal.dart';
import 'package:caiemca_app/models/airtypes/airtype.dart';
import 'package:caiemca_app/settings.dart';
import 'package:caiemca_app/widgets/caiemca-listview.widget.dart';
import 'package:flutter/material.dart';

class AirTypesDashboardPage extends StatefulWidget {
  const AirTypesDashboardPage({super.key});

  @override
  State<AirTypesDashboardPage> createState() => _AirTypesDashboardPageState();
}

class _AirTypesDashboardPageState extends State<AirTypesDashboardPage> {
  List<AirType> airTypes = [];

  Future? future;

  _loadAirTypes() async {
    try {
      airTypes = await AirType.get();
      setState(() {});
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    setState(() {
      future = _loadAirTypes();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.airtypes,
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
            items: airTypes,
            icon: Icons.air_outlined,
            labelAction: 'Aire',
            onEdit: (item) async {
              if (item is AirType) {
                var res = await showAirTypeModal<String?>(
                  context: context,
                  item: item,
                  editing: true,
                );
                if (res != null) {
                  setState(() {
                    future = _loadAirTypes();
                  });
                }
              }
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var res = await showAirTypeModal<String?>(
            context: context,
            item: AirType()
          );
          if (res != null) {
            setState(() {
              future = _loadAirTypes();
            });
          }
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
