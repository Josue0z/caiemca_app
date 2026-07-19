
import 'package:caiemca_app/models/abstracts.dart';
import 'package:caiemca_app/settings.dart';
import 'package:flutter/material.dart';

class CaiemcaListView extends StatelessWidget {
  List<CaiemcaItem> items;
  IconData icon;
  String labelAction;
  bool selector;
  Widget Function(BuildContext, CaiemcaItem)? builderTitle;
  Widget Function(BuildContext, CaiemcaItem)? builderSubtitle;
  Widget? Function(BuildContext, CaiemcaItem, Widget? child)? builderOptions;
  Function(CaiemcaItem)? onEdit;
  Function(CaiemcaItem)? onSelected;
  List<Map<String, dynamic>>? othersOptions = [];
  CaiemcaListView({
    super.key,
    required this.items,
    required this.icon,
    this.onEdit,
    this.labelAction = '',
    this.builderOptions,
    this.builderTitle,
    this.builderSubtitle,
    this.othersOptions,
    this.selector= false,
    this.onSelected
  });

  List<Map<String, dynamic>> options = [
    {'id': 1, 'name': 'Editar', 'icon': Icon(Icons.edit)},
  ];

  _showAction({required int value, required CaiemcaItem item}) {
    switch (value) {
      case 1:
        if (onEdit != null) {
          onEdit?.call(item);
        }
        break;
      default:
    }

    if (othersOptions != null) {
      for (int i = 0; i < othersOptions!.length; i++) {
        var option = othersOptions![i];
        var xval = option['id'];

        if (value == xval) {
          var call = option['call'];

          if (call != null) {
            call(item);
          }
        }
      }
    }
  }

  Widget optionsWidget(CaiemcaItem item) {
    return PopupMenuButton<int>(
      onSelected: (value) {
        _showAction(value: value, item: item);
      },
      itemBuilder: (ctx) {
        return List.generate(options.length, (i) {
          var option = options[i];
          var id = option['id'];
          var label = labelAction;

          if (id == 2) {
            label = '';
          }
          var name = '${option['name']} $label';
          var icon = option['icon'];

          return PopupMenuItem(
            value: id,
            child: Row(
              children: [
                icon,
                SizedBox(width: kDefaultPadding / 3),
                Text(name),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (othersOptions != null) {
      options = [...options, ...othersOptions!];
    }

    return ListView.separated(
      itemBuilder: (ctx, index) {
        var item = items[index];
        var title = item.name ?? item.workerName ?? 'S/N';
        var subtitle = item.identification ?? '';
        return ListTile(
          key: ValueKey(item.id),
          leading: CircleAvatar(
            backgroundColor: kCardBackgroundColor,
            child: Icon(icon, color: kPrimaryColor),
          ),
          title: builderTitle != null
              ? builderTitle?.call(ctx, item)
              : Text(title),
          subtitle: builderSubtitle != null
              ? builderSubtitle?.call(ctx, item)
              : subtitle != ''
              ? Text(subtitle)
              : null,
          trailing: builderOptions != null
              ? builderOptions?.call(ctx, item, optionsWidget(item))
              : optionsWidget(item),
          onTap: selector ? (){
             if(onSelected != null){
              onSelected!(item);
             }
          } : null,
        );
      },
      separatorBuilder: (ctx, i) => const Divider(),
      itemCount: items.length,
    );
  }
}
