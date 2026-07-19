import 'package:caiemca_app/l10n/app_localizations.dart';
import 'package:caiemca_app/models/users/user.dart';
import 'package:caiemca_app/pages/dashboard/airlocations.dart';
import 'package:caiemca_app/pages/dashboard/airtypes.dart';
import 'package:caiemca_app/pages/dashboard/brands.dart';
import 'package:caiemca_app/pages/dashboard/clients.dart';
import 'package:caiemca_app/pages/dashboard/devices.dart';
import 'package:caiemca_app/pages/dashboard/forms.dart';
import 'package:caiemca_app/pages/dashboard/services.dart';
import 'package:caiemca_app/pages/dashboard/technicians.dart';
import 'package:caiemca_app/pages/dashboard/users.dart';
import 'package:caiemca_app/pages/dashboard/workers.dart';
import 'package:caiemca_app/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  List<Map<String, dynamic>> options = [
    {'id': 1, 'name': 'forms', 'svg': 'assets/svgs/file-text.svg'},
    {'id': 2, 'name': 'users', 'svg': 'assets/svgs/users.svg'},
    {'id': 3, 'name': 'services', 'svg': 'assets/svgs/pickaxe.svg'},

    {'id': 5, 'name': 'clients', 'svg': 'assets/svgs/user-round-pen.svg'},

    {'id': 6, 'name': 'brands', 'svg': 'assets/svgs/air-vent.svg'},
    //{'id': 7, 'name': 'Dispositivos', 'svg': 'assets/svgs/wind.svg'},
    {
      'id': 8,
      'name': 'airtypes',
      'svg': 'assets/svgs/thermometer-snowflake.svg',
    },
    {'id': 9, 'name': 'locations', 'svg': 'assets/svgs/map-pin-search.svg'},

    {'id': 10, 'name': 'technicians', 'svg': 'assets/svgs/user-round-pen.svg'},
  ];

  _showFormsPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => FormsDashboard()),
    );
  }

  _showClientsPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => ClientsDashboardPage()),
    );
  }

  _showServicesPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => ServicesDashboardPage()),
    );
  }

  _showWorkersPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => WorkersDashboardPage()),
    );
  }

  _showUsersPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => UsersDashboardPage()),
    );
  }

  _showBrandsPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => BrandsDashboardPage()),
    );
  }

  _showDevicesPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => DevicesDashboardPage()),
    );
  }

  _showAirTypesPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => AirTypesDashboardPage()),
    );
  }

  _showAirLocationsPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => AirLocationsDashboardPage()),
    );
  }

  _showTechniciansDashboardPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => TechniciansDashboardPage()),
    );
  }

  _showPage(int id) async {
    switch (id) {
      case 1:
        _showFormsPage();
      case 2:
        _showUsersPage();
        break;
      case 5:
        _showClientsPage();
        break;
      case 3:
        _showServicesPage();
        break;
      case 4:
        _showWorkersPage();
      case 6:
        _showBrandsPage();
        break;
      case 7:
        _showDevicesPage();
        break;
      case 8:
        _showAirTypesPage();
        break;
      case 9:
        _showAirLocationsPage();
        break;
      case 10:
        _showTechniciansDashboardPage();
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    if (!currentUser!.permissions!.contains('ALLOW_VIEW_USERS')) {
      options.removeWhere((option) => option['id'] == 2);
    }

    if (!currentUser!.permissions!.contains('ALLOW_VIEW_SERVICES')) {
      options.removeWhere((option) => option['id'] == 3);
    }

    if (!currentUser!.permissions!.contains('ALLOW_VIEW_CLIENTS')) {
      options.removeWhere((option) => option['id'] == 5);
    }
    if (!currentUser!.permissions!.contains('ALLOW_VIEW_BRANDS')) {
      options.removeWhere((option) => option['id'] == 6);
    }
    if (!currentUser!.permissions!.contains('ALLOW_VIEW_AIRTYPES')) {
      options.removeWhere((option) => option['id'] == 8);
    }
    if (!currentUser!.permissions!.contains('ALLOW_VIEW_LOCATIONS')) {
      options.removeWhere((option) => option['id'] == 9);
    }

    if (!currentUser!.permissions!.contains('ALLOW_VIEW_TECHNICIANS')) {
      options.removeWhere((option) => option['id'] == 10);
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight * 2.5),
        child: Container(
          padding: EdgeInsets.only(
            left: kDefaultPadding,
            right: kDefaultPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: kDefaultPadding * 2),
                child: Text(
                  'Tablero  - ${currentUser?.company?.name}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontSize: 22),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${loc?.welcome} ',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text: '${currentUser?.name?.split(' ')[0]}',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),

                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.account_circle_outlined,
                          color: kPrimaryColor,
                          size: kIconSize,
                        ),
                      ),
                      SizedBox(width: kDefaultPadding / 3),
                      IconButton(
                        onPressed: () => UserCaiemca.loggout(context: context),
                        icon: Icon(
                          Icons.exit_to_app,
                          color: kPrimaryColor,
                          size: kIconSize,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(kDefaultPadding / 2),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  '${currentUser?.roleName}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: GridView.builder(
        itemCount: options.length,
        padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 250,
        ),
        itemBuilder: (ctx, index) {
          var option = options[index];
          var name = '';

          switch (option['name']) {
            case 'forms':
              name = loc?.forms ?? '';
              break;
            case 'users':
              name = loc?.users ?? '';
              break;
            case 'services':
              name = loc?.services ?? '';
              break;
            case 'clients':
              name = loc?.clients ?? '';
              break;
            case 'brands':
              name = loc?.brands ?? '';
              break;
            case 'airtypes':
              name = loc?.airtypes ?? '';
              break;
            case 'locations':
              name = loc?.locations ?? '';
              break;
            case 'technicians':
              name = loc?.technicians ?? '';
            default:
              name = '';
          }
          var id = option['id'];
          var svgAsset = option['svg'];

          return GestureDetector(
            onTap: () {
              _showPage(id);
            },
            child: Card(
              color: kCardBackgroundColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 0.5, color: kCardBorderColor),
                borderRadius: BorderRadiusGeometry.circular(kBorderRadius),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(svgAsset, width: 100),
                    Container(
                      margin: EdgeInsets.only(top: kDefaultPadding),
                      child: Text(
                        name,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
