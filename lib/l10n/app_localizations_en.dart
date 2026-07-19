// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcome => 'Welcome';

  @override
  String createdFormLabel(Object created) {
    return 'Created $created';
  }

  @override
  String get explore_forms => 'Explore forms';

  @override
  String get forms => 'Forms';

  @override
  String get users => 'Users';

  @override
  String get services => 'Services';

  @override
  String get workers => 'Workers';

  @override
  String get brands => 'Brands';

  @override
  String get airtypes => 'Air Types';

  @override
  String get locations => 'Locations';

  @override
  String get clients => 'Clients';

  @override
  String get technicians => 'Technicians';
}
