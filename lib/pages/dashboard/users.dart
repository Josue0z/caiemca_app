import 'package:caiemca_app/functions.dart';
import 'package:caiemca_app/modals/user.modal.dart';
import 'package:caiemca_app/models/permissions/permissions.dart';
import 'package:caiemca_app/models/roles/roles.dart';
import 'package:caiemca_app/models/users/user.dart';
import 'package:caiemca_app/settings.dart';
import 'package:caiemca_app/widgets/caiemca-listview.widget.dart';
import 'package:flutter/material.dart';

class UsersDashboardPage extends StatefulWidget {
  const UsersDashboardPage({super.key});

  @override
  State<UsersDashboardPage> createState() => _UsersDashboardPageState();
}

class _UsersDashboardPageState extends State<UsersDashboardPage> {
  Future? future;
  List<UserCaiemca> users = [];

  _loadUsers() async {
    try {
      users = await UserCaiemca.get();
      setState(() {});
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    setState(() {
      future = _loadUsers();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Usuarios',
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
            items: users,
            icon: Icons.person_2_outlined,
            labelAction: 'Usuario',
            builderOptions: (ctx, item, child) {
              if (item is UserCaiemca) {

                if(currentUser?.isWorker == true)return null;
                return item.isSuperUser && currentUser?.isAdmin == true
                    ? null
                    : child;
              }
              return child;
            },
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
                    item.roleName ?? '',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            onEdit: (item) async {
              showLoader(context: context);
              try {
                print('editando: $item');

                if (item is UserCaiemca) {
                  permissions = await PermissionCaiemca.get();
                  roles = [Role(name: 'ROL'), ...await Role.get()];
                  Navigator.pop(context);
                  var res = await showUserModal(
                    context: context,
                    item: item,
                    editing: true,
                  );
                  if (res != null) {
                    setState(() {
                      future = _loadUsers();
                    });
                  }
                }
              } catch (e) {
                Navigator.pop(context);
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
          showLoader(context: context);
          try {
            permissions = await PermissionCaiemca.get();
            roles = [Role(name: 'ROL'), ...await Role.get()];
            Navigator.pop(context);
            var res = await showUserModal(
              context: context,
              item: UserCaiemca(),
            );
            if (res != null) {
              setState(() {
                future = _loadUsers();
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
