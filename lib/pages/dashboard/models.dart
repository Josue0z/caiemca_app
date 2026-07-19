import 'package:caiemca_app/functions.dart';
import 'package:caiemca_app/modals/model.modal.dart';
import 'package:caiemca_app/models/airtypes/airtype.dart';
import 'package:caiemca_app/models/brands/brand.dart';
import 'package:caiemca_app/models/models/model.dart';
import 'package:caiemca_app/settings.dart';
import 'package:caiemca_app/widgets/caiemca-listview.widget.dart';
import 'package:flutter/material.dart';

class ModelsDashboardPage extends StatefulWidget {
  BrandCaiemca brand;
  ModelsDashboardPage({super.key, required this.brand});

  @override
  State<ModelsDashboardPage> createState() => _ModelsDashboardPageState();
}

class _ModelsDashboardPageState extends State<ModelsDashboardPage> {
  List<ModelCaiemca> models = [];

  Future? future;

  _loadModels() async {
    try {
      models = await ModelCaiemca.get(brandId: widget.brand.id);
      setState(() {});
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    setState(() {
      future = _loadModels();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Modelos - ${widget.brand.name}',
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
            items: models,
            icon: Icons.air_outlined,
            labelAction: 'Modelo',
            builderSubtitle: (ctx, item) {
              if (item is ModelCaiemca) {
                return Text('${item.airTypeName}');
              }
              return SizedBox();
            },
            onEdit: (item) async {
              if (item is ModelCaiemca) {
                showLoader(context: context);
                try {
                  airsTypes = await AirType.get();
                  Navigator.pop(context);
                  var res = await showModelModal<String?>(
                    context: context,
                    item: item.copyWith(brandName: widget.brand.name),
                    editing: true,
                  );
                  if (res != null) {
                    setState(() {
                      future = _loadModels();
                    });
                  }
                } catch (e) {
                  Navigator.pop(context);
                  showTopSnackBar(
                    context,
                    message: e.toString(),
                    color: Colors.red,
                  );
                }
              }
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showLoader(context: context);
          try {
            airsTypes = await AirType.get();

            Navigator.pop(context);
            var res = await showModelModal<String?>(
              context: context,
              item: ModelCaiemca(
                brandName: widget.brand.name,
                brandId: widget.brand.id,
              ),
            );
            if (res != null) {
              setState(() {
                future = _loadModels();
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
