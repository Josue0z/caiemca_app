import 'package:caiemca_app/models/workers/worker.dart';
import 'package:caiemca_app/settings.dart';
import 'package:caiemca_app/widgets/caiemca-listview.widget.dart';
import 'package:flutter/material.dart';

class WorkersDashboardPage extends StatefulWidget {
  const WorkersDashboardPage({super.key});

  @override
  State<WorkersDashboardPage> createState() => _WorkersDashboardPageState();
}

class _WorkersDashboardPageState extends State<WorkersDashboardPage> {
  List<WorkerCaiemca> workers = [
  ];

  Future? future;

  _loadWorkers() async {
    try {
      workers = await WorkerCaiemca.get();
      setState(() {});
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    setState(() {
      future = _loadWorkers();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trabajadores',
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
            items: workers,
            icon: Icons.person_2_outlined,
            labelAction: 'Trabajador',
            builderSubtitle: (ctx, item) => Wrap(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 3),
                  padding: EdgeInsets.all(kDefaultPadding / 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(90),
                    color: kPrimaryColor,
                  ),
                  child: Text(
                    item.workerRoleName ?? '',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            onEdit: (item) {
              print('editando: $item');
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
