import 'package:caiemca_app/functions.dart';
import 'package:caiemca_app/settings.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:localstorage/localstorage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configuracion',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.account_circle_outlined),
            title: Text('Ver Datos de Perfil'),
            onTap: () {},
            trailing: Icon(Icons.arrow_right),
          ),
          const Divider(),
          FingerprintAuthButton(),
          const Divider(),
        ],
      ),
    );
  }
}

class FingerprintAuthButton extends StatefulWidget {
  @override
  _FingerprintAuthButtonState createState() => _FingerprintAuthButtonState();
}

class _FingerprintAuthButtonState extends State<FingerprintAuthButton> {
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
          showTopSnackBar(
            context,
            message: "Autenticación exitosa ✅",
            color: Colors.green,
          );
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
      showTopSnackBar(
        context,
        message: "Error en autenticación: $e",
        color: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.fingerprint_outlined),
      title: Text(
        'Configurar Huella (${isEnabledFingerPrint ? '✅ HABILITADA' : '❌ DESHABILITADA'})',
      ),
      onTap: _authenticate,
      trailing: Icon(Icons.arrow_right)
    );
  }
}
