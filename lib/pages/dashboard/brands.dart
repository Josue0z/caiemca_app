import 'package:caiemca_app/l10n/app_localizations.dart';
import 'package:caiemca_app/modals/brands.modal.dart';
import 'package:caiemca_app/models/brands/brand.dart';
import 'package:caiemca_app/pages/dashboard/models.dart';
import 'package:caiemca_app/settings.dart';
import 'package:caiemca_app/widgets/caiemca-listview.widget.dart';
import 'package:flutter/material.dart';

class BrandsDashboardPage extends StatefulWidget {
  const BrandsDashboardPage({super.key});

  @override
  State<BrandsDashboardPage> createState() => _BrandsDashboardPageState();
}

class _BrandsDashboardPageState extends State<BrandsDashboardPage> {
  List<BrandCaiemca> brands = [];

  Future? future;

  _loadBrands() async {
    try {
      brands = await BrandCaiemca.get();
      setState(() {});
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    setState(() {
      future = _loadBrands();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.brands,
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
            items: brands,
            icon: Icons.air_outlined,
            labelAction: 'Marca',
            othersOptions: [
              {
                'id': 2,
                'name': 'Ver Modelos',
                'icon': Icon(Icons.air_outlined),
                'call': (item) async {
                  print('selected: $item');
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => ModelsDashboardPage(brand: item),
                    ),
                  );
                },
              },
            ],
            onEdit: (item) async {
              print('editando: $item');
              if (item is BrandCaiemca) {
                var res = await showBrandModal<String?>(
                  context: context,
                  item: item,
                  editing: true,
                );
                if (res != null) {
                  setState(() {
                    future = _loadBrands();
                  });
                }
              }
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var res = await showBrandModal<String?>(
            context: context,
            item: BrandCaiemca(),
          );
          if(res != null){
              setState(() {
                    future = _loadBrands();
                  });
          }
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
