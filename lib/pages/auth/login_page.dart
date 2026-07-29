import 'package:caiemca_app/apis/api.caiemca.dart';
import 'package:caiemca_app/functions.dart';
import 'package:caiemca_app/models/users/user.dart';
import 'package:caiemca_app/pages/dashboard/home.dart';
import 'package:caiemca_app/settings.dart';
import 'package:caiemca_app/widgets/btn.caiemca.button.widget.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:localstorage/localstorage.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  submit() {
    if(_formKey.currentState!.validate()){
       _onSubmit(
      context: context,
      username: username.text,
      password: password.text,
    );
    }
  }

  @override
  void initState() {
    username.text =localStorage.getItem('caiemca_username') ?? '';
    super.initState();
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
                                  onFieldSubmitted: (_) => submit(),
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
                                  onPressed: submit,
                                ),
                              ),

                          isEnabledFingerPrint ?     Align(
                          child: TextButton(
                            onPressed: () async {
                              await Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => AuthWithFingerPrintPage(),
                                ),
                                (_) => false
                              );
                            },
                            child: Text('Acceso con huella',style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: kPrimaryColor
                            )),
                          ),
                        ) : SizedBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FingerprintAuthButtonLogin extends StatefulWidget {
  VoidCallback? onAuthenticate;
  FingerprintAuthButtonLogin({required this.onAuthenticate, super.key});
  @override
  _FingerprintAuthButtonState createState() => _FingerprintAuthButtonState();
}

class _FingerprintAuthButtonState extends State<FingerprintAuthButtonLogin> {
  final LocalAuthentication auth = LocalAuthentication();
  bool canCheckBiometrics = false;
  bool isDeviceSupported = false;

  Future<void> _authenticate() async {
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
      isDeviceSupported = await auth.isDeviceSupported();

      if (canCheckBiometrics && isDeviceSupported) {
        bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Autentícate con tu huella digital',
          authMessages: const <AuthMessages>[
            AndroidAuthMessages(
              signInTitle: 'Oops! Biometric authentication required!',
              cancelButton: 'No thanks',
            ),
            IOSAuthMessages(cancelButton: 'No thanks'),
          ],
        );

        if (didAuthenticate) {
          isEnabledFingerPrint = true;
          localStorage.setItem('caiemca_fingerprint', 'ok');
          print(widget.onAuthenticate);
          if (widget.onAuthenticate != null) {
            widget.onAuthenticate!();
          }
        } else {
          showTopSnackBar(
            context,
            message: "Autenticación fallida ❌",
            color: Colors.red,
          );
        }
      } else {
        showTopSnackBar(
          context,
          message: "Biometría no disponible en este dispositivo",
          color: Colors.red,
        );
      }
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: ElevatedButton(
        onPressed: _authenticate,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(kPrimaryColor),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fingerprint_outlined, color: Colors.white),
            SizedBox(width: kDefaultPadding / 3),
            Padding(
              padding: EdgeInsets.all(kDefaultPadding * 0.76),
              child: Text(
                'Acceso con huella',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthWithFingerPrintPage extends StatefulWidget {
  const AuthWithFingerPrintPage({super.key});

  @override
  State<AuthWithFingerPrintPage> createState() =>
      _AuthWithFingerPrintPageState();
}

class _AuthWithFingerPrintPageState extends State<AuthWithFingerPrintPage> {
  String? get fullName {
    var name =  localStorage.getItem('caiemca_userfullname');

    if(name != null){
      return name.split(' ')[0];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Form(
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
                           SizedBox(height: kDefaultPadding),
                        Text(fullName != null ? 'Hola, $fullName!' : 'Hola!',style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600
                        )),
                        SizedBox(height: kDefaultPadding),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FingerprintAuthButtonLogin(
                                onAuthenticate: () {
                                  var username =
                                      localStorage.getItem(
                                        'caiemca_username',
                                      ) ??
                                      '';
                                  var password =
                                      localStorage.getItem(
                                        'caiemca_userpassword',
                                      ) ??
                                      '';

                                  _onSubmit(
                                    context: context,
                                    username: username,
                                    password: password
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        Align(
                          child: TextButton(
                            onPressed: () async {
                              await Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => LoginPage(),
                                ),
                                (_) => false
                              );
                            },
                            child: Text('Acceso con contraseña',style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w600
                            ),),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

_onSubmit({
  required BuildContext context,
  required String username,
  required String password,
}) async {

    FocusManager.instance.primaryFocus?.unfocus();
    await showLoader(context: context);
    try {
      currentUser = await UserCaiemca.login(
        username: username,
        password: password,
      );

      if (currentUser != null) {
        localStorage.setItem('caiemca_username', currentUser?.username ?? '');
        localStorage.setItem('caiemca_userpassword', password);
        localStorage.setItem('caiemca_userfullname', currentUser?.name ?? '');
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
