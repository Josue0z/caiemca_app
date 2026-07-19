import 'package:caiemca_app/functions.dart';
import 'package:caiemca_app/models/users/user.dart';
import 'package:caiemca_app/settings.dart';
import 'package:caiemca_app/widgets/modal.caiemca.widget.dart';
import 'package:flutter/material.dart';

Future<T> showUserModal<T>({
  required BuildContext context,
  required UserCaiemca item,
  bool editing = false,
}) async {
  final GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController username = TextEditingController(
    text: item.username ?? '',
  );
  TextEditingController identification = TextEditingController(
    text: item.identification ?? '',
  );
  TextEditingController phone = TextEditingController(text: item.phone ?? '');
  TextEditingController email = TextEditingController(text: item.email ?? '');
  TextEditingController address = TextEditingController(
    text: item.address ?? '',
  );
  TextEditingController password = TextEditingController(text: '');
  TextEditingController name = TextEditingController(text: item.name ?? '');

  List<String> xpermissions = item.permissions ?? [];

  int? currentRoleId = item.roleId;
  submit() async {
    if (formKey.currentState!.validate()) {
      showLoader(context: context);
      try {
        item.username = username.text;
        item.password = password.text;
        item.identification = identification.text;
        item.name = name.text;
        item.roleId = currentRoleId;
        item.permissions = xpermissions;
        item.address = address.text.isEmpty?null:address.text;
        item.phone = phone.text.isEmpty ? null : phone.text;
        item.email = email.text.isEmpty ? null : email.text;
        if (editing) {
          await item.update();
        } else {
          await item.create();
        }
        Navigator.pop(context);
        Navigator.pop(context, item.toMap().toString());
      } catch (e) {
        Navigator.pop(context);
        showTopSnackBar(context, message: e.toString(), color: Colors.red);
      }
    }
  }

  return await showDialog(
    context: context,
    builder: (ctx) => Form(
      key: formKey,
      child: ModalCaiemcaWidget(
        title: editing ? 'Editando Usuario' : 'Creando Usuario...',
        btnTitle: editing ? 'EDITAR' : 'CONFIRMAR',
        height: 450,
        onSubmit: submit,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: kDefaultPadding / 2,
              bottom: kDefaultPadding,
            ),
            child: TextFormField(
              controller: username,
              autofocus: true,
              validator: (val) => val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
              decoration: InputDecoration(
                labelText: 'USUARIO',
                hintText: 'Escribir algo...',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: kDefaultPadding),
            child: TextFormField(
              controller: name,
              autofocus: true,
              validator: (val) => val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
              decoration: InputDecoration(
                labelText: 'NOMBRE',
                hintText: 'Escribir algo...',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: kDefaultPadding),
            child: TextFormField(
              controller: identification,
              autofocus: true,
              validator: (val) => val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
              decoration: InputDecoration(
                labelText: 'IDENTIFICACION',
                hintText: 'Escribir algo...',
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(bottom: kDefaultPadding),
            child: TextFormField(
              controller: phone,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'TELEFONO',
                hintText: '809 000 0000',
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(bottom: kDefaultPadding),
            child: TextFormField(
              controller: email,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'CORREO',
                hintText: 'contact@example.com',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: kDefaultPadding),
            child: TextFormField(
              controller: address,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'DIRECCION',
                hintText: 'Escribir algo...',
              ),
            ),
          ),
          editing
              ? SizedBox()
              : Container(
                  margin: EdgeInsets.only(bottom: kDefaultPadding),
                  child: TextFormField(
                    controller: password,
                    autofocus: true,
                    validator: (val) =>
                        val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'CONTRASEÑA',
                      hintText: 'Escribir algo...',
                    ),
                  ),
                ),
          RolesSelectorWidget(
            currentRoleId: currentRoleId,
            permissions: xpermissions,
            onChanged: (roleId, permissions) {
              currentRoleId = roleId;
              xpermissions = permissions;
            },
          ),
        ],
      ),
    ),
  );
}

class RolesSelectorWidget extends StatefulWidget {
  int? currentRoleId;
  List<String> permissions;

  Function(int? roleId, List<String> permissions)? onChanged;

  RolesSelectorWidget({
    super.key,
    this.currentRoleId,
    this.permissions = const [],
    this.onChanged,
  });

  @override
  State<RolesSelectorWidget> createState() => _RolesSelectorWidgetState();
}

class _RolesSelectorWidgetState extends State<RolesSelectorWidget> with AutomaticKeepAliveClientMixin{
  List<String> xxpermissions = [];

  List<String> adminPermissions = [
    'ALLOW_VIEW_FORMS','ALLOW_VIEW_USERS','ALLOW_VIEW_WORKERS','ALLOW_EDIT_SERVICES','ALLOW_VIEW_CLIENTS','ALLOW_VIEW_BRANDS','ALLOW_VIEW_AIRTYPES','ALLOW_VIEW_LOCATIONS','ALLOW_VIEW_SERVICES','ALLOW_CREATE_SERVICES'
  ];

    List<String> workersPermissions = [
    'ALLOW_VIEW_FORMS'
  ];

@override
void initState() {
  super.initState();
  xxpermissions = List.from(widget.permissions);
}

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: kDefaultPadding),
          child: DropdownButtonFormField(
            initialValue: widget.currentRoleId,
            validator: (val) => widget.currentRoleId == null ? 'CAMPO OBLIGATORIO': null,
            decoration: InputDecoration(
              labelText: 'ROL',
              hintText: 'SELECCIONAR ROL'
            ),
            items: List.generate(roles.length, (i) {
              var role = roles[i];
              return DropdownMenuItem(
                value: role.id,
                child: Text(role.name ?? ''),
              );
            }),
            onChanged: (val) {
              widget.currentRoleId = val;

              if(val == 3){
                xxpermissions = workersPermissions;
              }
              if(val == 1 || val == 2) {
                xxpermissions = adminPermissions;
              }
              setState(() {
                
              });
              if (widget.onChanged != null) {
                widget.onChanged!(widget.currentRoleId, xxpermissions);
              }
            },
          ),
        ),

        Text(
          'PERMISOS (${permissions.length})',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: kPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),

        ...List.generate(permissions.length, (index) {
          var permission = permissions[index];

          return Container(
            margin: EdgeInsets.only(bottom: kDefaultPadding / 2),
            child: Row(
              children: [
                Checkbox.adaptive(
                  value: xxpermissions.contains(permission.name),
                  onChanged: (val) {
                    if (xxpermissions.contains(permission.name)) {
                      xxpermissions.remove(permission.name);
                    } else {
                      xxpermissions.add(permission.name ?? '');
                    }
                    if (widget.onChanged != null) {
                      widget.onChanged!(widget.currentRoleId, xxpermissions);
                    }
                    setState(() {});
                  },
                ),
                SizedBox(width: kDefaultPadding / 2),
                Expanded(
                  child: Text(
                    permission.description ?? '',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}
