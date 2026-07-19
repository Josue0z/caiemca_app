import 'package:caiemca_app/l10n/app_localizations.dart';
import 'package:caiemca_app/modals/showfilters.modal.dart';
import 'package:caiemca_app/models/airlocations/airlocation.dart';
import 'package:caiemca_app/models/airtypes/airtype.dart';
import 'package:caiemca_app/models/branches/branche.dart';
import 'package:caiemca_app/models/brands/brand.dart';
import 'package:caiemca_app/models/clients/client.dart';
import 'package:caiemca_app/models/components/component.dart';
import 'package:caiemca_app/models/failures/failures.dart';
import 'package:caiemca_app/models/forms/form.ciaemca.dart';
import 'package:caiemca_app/functions.dart';
import 'package:caiemca_app/models/models/model.dart';
import 'package:caiemca_app/models/services/service.dart';
import 'package:caiemca_app/models/technicians/technicians.dart';
import 'package:caiemca_app/pages/crud/form_generator_page.dart';
import 'package:caiemca_app/pages/dashboard/signature.box.page.dart';
import 'package:caiemca_app/settings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';

class FormsDashboard extends StatefulWidget {
  const FormsDashboard({super.key});

  @override
  State<FormsDashboard> createState() => _FormsDashboardState();
}

class _FormsDashboardState extends State<FormsDashboard> {
  Future? future;

  List<FormCaiemca> forms = [];

  Future<void> _loadForms({
        List<String> selectedBrands = const [],
    List<String> selectedModels = const [],
    List<String> selectedAirTypes = const [],
    List<String> selectedLocations = const [],
    List<String> selectedBranches = const []
  }) async {
    try {
      forms = await FormCaiemca.get(
        selectedBrands: selectedBrands,
        selectedModels: selectedModels,
        selectedAirTypes: selectedAirTypes,
        selectedLocations: selectedLocations,
        selectedBranches: selectedBranches
      );
      setState(() {});
    } catch (e) {
      rethrow;
    }
  }

  _openPdfFile(FormCaiemca form) async {
    Navigator.pop(context);
    try {
      showLoader(context: context);
      final dir = await getTemporaryDirectory();
      final filePath = path.join(
        dir.path,
        'caiemca',
        'pdfs',
        'CAIEMCA_REPORTE_${form.formNumber}.pdf',
      );

      String url = form.formUrl;

      await Dio().download(url, filePath);

      Navigator.pop(context);
      await OpenFile.open(filePath);
    } catch (e) {
      Navigator.pop(context);
      showTopSnackBar(context, message: e.toString(), color: Colors.red);
    }
  }

  _exportPdfFile(FormCaiemca form) async {
    Navigator.pop(context);
    try {
      showLoader(context: context);
      final dir = await getTemporaryDirectory();
      final filePath = path.join(
        dir.path,
        'caiemca',
        'pdfs',
        'CAIEMCA_REPORTE_${form.formNumber}.pdf',
      );

      String url = form.formUrl;

      await Dio().download(url, filePath);

      Navigator.pop(context);
      await SharePlus.instance.share(ShareParams(files: [XFile(filePath)]));
    } catch (e) {
      Navigator.pop(context);
      showTopSnackBar(context, message: e.toString(), color: Colors.red);
    }
  }

  _openSignatureBox(FormCaiemca form) async {
    Navigator.pop(context);
    var res = await Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => SignatureBoxPage(form: form)),
    );

    if (res != null) {
      setState(() {
        future = _loadForms();
      });
    }
  }

  _handlerOptions(option, FormCaiemca form) async {
    var val = option['id'];
    switch (val) {
      case 1:
        _openPdfFile(form);
        break;
      case 2:
        _exportPdfFile(form);
        break;
      case 3:
        if (form.isSignature == false) {
          _openSignatureBox(form);
        }

        break;
    }
  }

  @override
  void initState() {
    setState(() {
      future = _loadForms();
    });
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  _showSheetOptions(FormCaiemca form, options) {
    double height = 60;

    final localizations = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: _scaffoldKey.currentContext!,
      elevation: 2,
      builder: (ctx) {
        return SizedBox(
          height: 350,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: kDefaultPadding,
                  vertical: kDefaultPadding / 2,
                ),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: kCardBorderColor)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            form.formNumber ?? '',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: kDefaultPadding,
                  vertical: kDefaultPadding / 2,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: kCardBackgroundColor,
                      child: Icon(Icons.person, color: kPrimaryColor),
                    ),
                    SizedBox(width: kDefaultPadding / 2),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(form.authorName ?? ''),
                        Text(
                          localizations.createdFormLabel(
                            form.createdAt?.format(payload: 'LLLL') ?? '',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: options.length,
                  separatorBuilder: (ctx, i) => const Divider(),
                  itemBuilder: (ctx, index) {
                    var option = options[index];
                    var id = option['id'];
                    var name = option['name'];
                    var icon = option['icon'];
                    var enabled = option['enabled'];

                    return ListTile(
                      leading: icon,
                      minTileHeight: height,
                      title: Text(name),
                      enabled: enabled,
                      trailing: form.isSignature && id == 3
                          ? Icon(
                              Icons.check_circle_outline,
                              color: Colors.green,
                            )
                          : null,
                      onTap: enabled
                          ? () => _handlerOptions(option, form)
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Explora tus formularios',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(
            onPressed: () async {
              try {
                showLoader(context: context);
                brands = await BrandCaiemca.get();
                models = await ModelCaiemca.get();
                airsTypes = await AirType.get();
                airLocations = await AirLocationCaiemca.get();
                allBranches = await BrancheCaiemca.get();
                Navigator.pop(context);
               var res =  await showFiltersModal(context: context);

               if(res != null){
           
                setState(() {
                  future =  _loadForms(
                  selectedBrands: res['selectedBrands'],
                  selectedModels: res['selectedModels'],
                  selectedAirTypes: res['selectedAirTypes'],
                  selectedBranches: res['selectedBranches'],
                  selectedLocations: res['selectedLocations']
                  
                );
                });
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
            icon: Icon(Icons.tune),
          ),
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

          return GridView.builder(
            itemCount: forms.length,
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 250,
              crossAxisSpacing: kDefaultPadding / 2,
              mainAxisSpacing: kDefaultPadding,
            ),
            itemBuilder: (ctx, index) {
              var form = forms[index];
              var options = [
                {
                  'id': 1,
                  'name': 'Ver Formulario .PDF',
                  'icon': Icon(Icons.picture_as_pdf),
                  'enabled': true,
                },
                {
                  'id': 2,
                  'name': 'Compartir Formulario .PDF',
                  'icon': Icon(Icons.share_outlined),
                  'enabled': true,
                },
              ];

              options.add({
                'id': 3,
                'name': form.isSignature == false
                    ? 'Firmar Documento'
                    : 'Documento Firmado',
                'icon': Icon(Icons.draw_outlined),
                'enabled': form.isSignature == false,
              });
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onDoubleTap: () => _showSheetOptions(form, options),
                      child: Card(
                        color: kCardBackgroundColor,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 0.5, color: kCardBorderColor),
                          borderRadius: BorderRadiusGeometry.circular(
                            kBorderRadius,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Align(
                                alignment: AlignmentGeometry.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.only(
                                    left: kDefaultPadding / 2,
                                  ),
                                  padding: EdgeInsets.all(kDefaultPadding / 3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: form.stateColor.withOpacity(0.05),
                                  ),
                                  child: Text(
                                    form.stateName ?? '',
                                    style: TextStyle(color: form.stateColor),
                                  ),
                                ),
                              ),
                              SvgPicture.asset(
                                'assets/svgs/file-text-light.svg',
                                width: 100,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: kDefaultPadding),
                                child: Text('.PDF'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: kDefaultPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          form.formNumber ?? '',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          form.createdAt?.format(payload: 'DD/MM/YYYY') ?? '',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showLoader(context: context);
          try {
            allClients = await Client.get();
            allServices = await ServiceCaiemca.get();
            allComponents = await ComponentCaiemca.get();
            allFailures = await Failures.get();
            allTechnicians = await TechnicianCaiemca.get();

            Navigator.pop(context);
            var res = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => FormGeneratorPage(formCaiemca: FormCaiemca()),
              ),
            );
            if (res != null) {
              setState(() {
                future = _loadForms();
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
