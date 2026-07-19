import 'package:caiemca_app/functions.dart';
import 'package:caiemca_app/modals/technician.modal.dart';
import 'package:caiemca_app/models/branches/branche.dart';
import 'package:caiemca_app/models/clients/client.dart';
import 'package:caiemca_app/models/technicians/technicians.dart';
import 'package:caiemca_app/settings.dart';
import 'package:caiemca_app/widgets/caiemca-listview.widget.dart';
import 'package:flutter/material.dart';

class TechniciansDashboardPage extends StatefulWidget {
  final BrancheCaiemca? branche;
  final Client? client;
  bool selector;
  TechniciansDashboardPage({super.key, this.branche, this.client,this.selector = false});

  @override
  State<TechniciansDashboardPage> createState() => _TechniciansDashboardPageState();
}

class _TechniciansDashboardPageState extends State<TechniciansDashboardPage> {
  List<TechnicianCaiemca> technicians = [];

  Future? future;

  _loadTechnicians() async {
    try {
      technicians = await TechnicianCaiemca.get();
      setState(() {});
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    setState(() {
      future = _loadTechnicians();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '(${technicians.length}) - Técnicos',
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
            items: technicians,
            selector: widget.selector,
            onSelected: (item){
               if(item is TechnicianCaiemca){
                  Navigator.pop(context,item);
               }
            },
            icon: Icons.person_2_rounded,
            labelAction: 'Técnico',
          
            builderTitle: (ctx, item) {
              if (item is TechnicianCaiemca) {
                return Text('${item.name}');
              }
              return SizedBox();
            },
            builderSubtitle: (ctx, item) {
              if (item is TechnicianCaiemca) {
                return Text(item.identification ?? '');
              }
              return SizedBox();
            },
            onEdit: (item) async {
              print('editando: $item');
         
              try {
                if (item is TechnicianCaiemca) {
           
                 
                  var res = await showTechnicianModal<String?>(
                    context: context,
                    item: item,
                    editing: true
                  );
                  if (res != null) {
                    setState(() {
                      future = _loadTechnicians();
                    });
                  }
                }
              } catch (e) {
            
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
          try {
            var res = await showTechnicianModal<String?>(
              context: context,
              item: TechnicianCaiemca(
             
              ),
         
            );

            if (res != null) {
              setState(() {
                future = _loadTechnicians();
              });
            }
          } catch (e) {

            showTopSnackBar(context, message: e.toString(), color: Colors.red);
          }
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
