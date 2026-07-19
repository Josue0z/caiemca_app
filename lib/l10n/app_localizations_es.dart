// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get welcome => 'Bienvenido';

  @override
  String createdFormLabel(Object created) {
    return 'Creado $created';
  }

  @override
  String get explore_forms => 'Explorar tus formularios';

  @override
  String get forms => 'Formularios';

  @override
  String get users => 'Usuarios';

  @override
  String get services => 'Servicios';

  @override
  String get workers => 'Trabajadores';

  @override
  String get brands => 'Marcas';

  @override
  String get airtypes => 'Tipos de Aires';

  @override
  String get locations => 'Ubicaciones';

  @override
  String get clients => 'Clientes';

  @override
  String get technicians => 'Tecnicos';
}
