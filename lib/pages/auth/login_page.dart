import 'package:caiemca_app/apis/api.caiemca.dart';
import 'package:caiemca_app/functions.dart';
import 'package:caiemca_app/models/users/user.dart';
import 'package:caiemca_app/pages/dashboard/home.dart';
import 'package:caiemca_app/settings.dart';
import 'package:caiemca_app/widgets/btn.caiemca.button.widget.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();
      await showLoader(context: context);
      try {
        currentUser = await UserCaiemca.login(
          username: username.text,
          password: password.text,
        );

        if (currentUser != null) {
          apiCaiemca.options.headers['x-companyid'] = currentUser?.company?.id;
          apiCaiemca.options.headers['x-user-token'] = currentUser?.id;

          if (currentUser?.isWorker == true) {
            apiCaiemca.options.headers['x-mode-cms'] = 'false';
          } else {
            apiCaiemca.options.headers['x-mode-cms'] = 'true';
          }
       
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (ctx) => HomeDashboard()),
            (_) => false,
          );
        }
      } catch (e) {
        Navigator.pop(context);
        showTopSnackBar(context, message: e.toString(), color: Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(kDefaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        Image.asset(
                          'assets/images/CAIEMCA_LOGO.png',
                          width: 300,
                        ),

                        SizedBox(height: kDefaultPadding * 2),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: kDefaultPadding / 3,
                                ),
                                child: Text(
                                  '¿DESEA INICIAR SESIÓN?',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: kDefaultPadding / 2,
                                ),
                                child: TextFormField(
                                  controller: username,
                                  validator: (val) =>
                                      val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.person_2_outlined),
                                    hintText: 'Usuario',
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: kDefaultPadding / 2,
                                ),
                                child: TextFormField(
                                  controller: password,
                                  obscureText: true,
                                  validator: (val) =>
                                      val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
                                  textInputAction: TextInputAction.send,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.lock_outline),
                                    hintText: 'Contraseña',
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: kDefaultPadding / 2,
                                ),
                                width: double.infinity,
                                height: 50,
                                child: CaiemcaButtonWidget(
                                  title: 'INICIAR CUENTA',
                                  onPressed: _onSubmit,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 0,
                right: 0,
                bottom: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.memory_outlined),
                    Text('Version 1.0.0'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
