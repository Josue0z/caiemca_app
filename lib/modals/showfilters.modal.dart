import 'package:caiemca_app/models/airlocations/airlocation.dart';
import 'package:caiemca_app/models/airtypes/airtype.dart';
import 'package:caiemca_app/models/branches/branche.dart';
import 'package:caiemca_app/models/models/model.dart';
import 'package:caiemca_app/settings.dart';
import 'package:caiemca_app/widgets/btn.caiemca.button.widget.dart';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

showFiltersModal({required BuildContext context}) async {
  List<String> selectedBrands = [];
  List<String> selectedModels = [];
  List<String> selectedAirTyes = [];
  List<ModelCaiemca> xmodels = [];
  List<AirType> xairTypes = [...airsTypes];
  List<String> selectedLocations = [];
  List<String> selectedBranches = [];
  return await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Filtros',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: kDefaultPadding),
                          child: DropDownMultiSelect(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onChanged: (List<String> selected) async {
                              // Actualizar marcas seleccionadas
                              selectedBrands = selected;

                              if (selectedBrands.isNotEmpty) {
                                // Recalcular modelos válidos según las marcas seleccionadas
                                xmodels = models
                                    .where(
                                      (e) => selectedBrands.contains(
                                        e.brandId.toString(),
                                      ),
                                    )
                                    .toList();

                                // Crear un set con los IDs válidos de modelos
                                final validModelIds = xmodels
                                    .map((m) => m.id.toString())
                                    .toSet();

                                // Filtrar los seleccionados para que solo queden los válidos
                                selectedModels = [
                                  ...selectedModels
                                      .where((id) => validModelIds.contains(id))
                                      .toList(),
                                ];

                                await Future.delayed(
                                  const Duration(microseconds: 600),
                                );
                              } else {
                                selectedModels = [];
                                selectedAirTyes = [];
                                selectedLocations = [];
                                selectedBranches = [];
                              }

                              setState(() {});
                            },
                            options: List.generate(
                              brands.length,
                              (i) => brands[i].id.toString(),
                            ),
                            selectedValues: selectedBrands,
                            whenEmpty: 'SELECCIONAR MARCAS...',
                            childBuilder: (values) {
                              var brandNames = List.generate(values.length, (
                                i,
                              ) {
                                return brands
                                    .firstWhere(
                                      (element) =>
                                          element.id.toString() == values[i],
                                    )
                                    .name;
                              });
                              return Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  values.isEmpty
                                      ? 'SELECCIONAR MARCAS...'
                                      : brandNames.join(', '),
                                ),
                              );
                            },

                            menuItembuilder: (String value) {
                              var brand = brands.firstWhere(
                                (element) => element.id.toString() == value,
                              );
                              var contains = selectedBrands.contains(value);
                              return ListTile(
                                title: Text(
                                  brand.name ?? '',
                                  style: TextStyle(
                                    color: contains
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.black,
                                  ),
                                ),

                                selected: contains,
                              );
                            },
                          ),
                        ),

                        Container(
                          key: ValueKey('MODELS_${selectedModels.length}'),
                          margin: EdgeInsets.only(bottom: kDefaultPadding),
                          child: DropDownMultiSelect(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onChanged: (List<String> selected) async {
                              selectedModels = selected;

                              final validModelIds = xmodels
                                  .map((m) => m.id.toString())
                                  .toSet();

                              selectedModels = selected
                                  .where((id) => validModelIds.contains(id))
                                  .toList();

                              if (selectedModels.isNotEmpty) {
                                // Recalcular tipos de aire válidos según los modelos seleccionados
                                var xmod = xmodels
                                    .where(
                                      (e) => selectedModels.contains(
                                        e.id.toString(),
                                      ),
                                    )
                                    .toList();
                                final validAirTypesIds = xmod
                                    .map((m) => m.airTypeId.toString())
                                    .toSet();

                                xairTypes = airsTypes
                                    .where(
                                      (e) => validAirTypesIds.contains(
                                        e.id.toString(),
                                      ),
                                    )
                                    .toList();

                                // Limpiar selección de tipos de aire inválidos
                                selectedAirTyes = selectedAirTyes
                                    .where(
                                      (id) => xairTypes.any(
                                        (air) => air.id.toString() == id,
                                      ),
                                    )
                                    .toList();
                              } else {
                                xairTypes = airsTypes;
                                selectedAirTyes = [];
                              }

                              setState(() {});
                            },
                            options: List.generate(
                              xmodels.length,
                              (i) => xmodels[i].id.toString(),
                            ),
                            selectedValues: selectedModels,

                            whenEmpty: 'SELECCIONAR MODELOS...',
                            childBuilder: (values) {
                              var modelNames = List.generate(values.length, (
                                i,
                              ) {
                                return xmodels
                                    .firstWhere(
                                      (element) =>
                                          element.id.toString() == values[i],
                                    )
                                    .name;
                              });
                              return Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  values.isEmpty
                                      ? 'SELECCIONAR MODELOS...'
                                      : modelNames.join(', '),
                                ),
                              );
                            },
                            menuItembuilder: (String value) {
                              var model = xmodels.firstWhere(
                                (element) => element.id.toString() == value,
                              );
                              var contains = selectedModels.contains(value);
                              return ListTile(
                                title: Text(
                                  model.name ?? '',
                                  style: TextStyle(
                                    color: contains
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.black,
                                  ),
                                ),
                                selected: contains,
                              );
                            },
                          ),
                        ),

                        Container(
                          key: ValueKey('AIRTYPES_${selectedModels.length}'),
                          margin: EdgeInsets.only(bottom: kDefaultPadding),
                          child: DropDownMultiSelect(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onChanged: (List<String> selected) {
                              if (selectedModels.isNotEmpty) {
                                var xmod = xmodels
                                    .where(
                                      (e) => selectedModels.contains(
                                        e.id.toString(),
                                      ),
                                    )
                                    .toList();
                                final validAirTypesIds = xmod
                                    .map((m) => m.airTypeId.toString())
                                    .toSet();

                                selectedAirTyes = selected
                                    .where(
                                      (id) => validAirTypesIds.contains(id),
                                    )
                                    .toList();
                              } else {
                                selectedAirTyes = selected;
                              }

                              setState(() {});
                            },
                            options: List.generate(
                              xairTypes.length,
                              (i) => xairTypes[i].id.toString(),
                            ),
                            selectedValues: selectedAirTyes,
                            childBuilder: (values) {
                              var airTypesName = values.map((id) {
                                return xairTypes
                                    .firstWhere(
                                      (element) => element.id.toString() == id,
                                      orElse: () =>
                                          AirType(id: -1, name: 'Desconocido'),
                                    )
                                    .name;
                              }).toList();

                              return Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  values.isEmpty
                                      ? 'SELECCIONAR TIPO DE AIRE...'
                                      : airTypesName.join(', '),
                                ),
                              );
                            },
                            menuItembuilder: (String value) {
                              var airType = xairTypes.firstWhere(
                                (element) => element.id.toString() == value,
                                orElse: () =>
                                    AirType(id: -1, name: 'Desconocido'),
                              );
                              var contains = selectedAirTyes.contains(value);
                              return ListTile(
                                title: Text(
                                  airType.name ?? '',
                                  style: TextStyle(
                                    color: contains
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.black,
                                  ),
                                ),
                                selected: contains,
                              );
                            },
                          ),
                        ),

                        Container(
                          key: ValueKey(
                            'LOCATIONS_${selectedLocations.length}',
                          ),
                          margin: EdgeInsets.only(bottom: kDefaultPadding),
                          child: DropDownMultiSelect(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onChanged: (List<String> selected) {
                              selectedLocations = selected;

                              setState(() {});
                            },
                            options: List.generate(
                              airLocations.length,
                              (i) => airLocations[i].id.toString(),
                            ),
                            selectedValues: selectedLocations,
                            childBuilder: (values) {
                              var locationName = values.map((id) {
                                return airLocations
                                    .firstWhere(
                                      (element) => element.id.toString() == id,
                                      orElse: () => AirLocationCaiemca(
                                        id: -1,
                                        name: 'Desconocido',
                                      ),
                                    )
                                    .name;
                              }).toList();

                              return Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  values.isEmpty
                                      ? 'SELECCIONAR UBICACION...'
                                      : locationName.join(', '),
                                ),
                              );
                            },
                            menuItembuilder: (String value) {
                              var airLocation = airLocations.firstWhere(
                                (element) => element.id.toString() == value,
                                orElse: () => AirLocationCaiemca(
                                  id: -1,
                                  name: 'Desconocido',
                                ),
                              );
                              var contains = selectedLocations.contains(value);
                              return ListTile(
                                title: Text(
                                  airLocation.name ?? '',
                                  style: TextStyle(
                                    color: contains
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.black,
                                  ),
                                ),
                                selected: contains,
                              );
                            },
                          ),
                        ),

                        Container(
                          key: ValueKey('BRANCHES_${selectedLocations.length}'),
                          margin: EdgeInsets.only(bottom: kDefaultPadding),
                          child: DropDownMultiSelect(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onChanged: (List<String> selected) {
                              selectedBranches = selected;

                              setState(() {});
                            },
                            options: List.generate(
                              allBranches.length,
                              (i) => allBranches[i].id.toString(),
                            ),
                            selectedValues: selectedBranches,
                            childBuilder: (values) {
                              var brancheName = values.map((id) {
                                return allBranches
                                    .firstWhere(
                                      (element) => element.id.toString() == id,
                                      orElse: () => BrancheCaiemca(
                                        id: -1,
                                        name: 'Desconocido',
                                      ),
                                    )
                                    .name;
                              }).toList();

                              return Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  values.isEmpty
                                      ? 'SELECCIONAR SUCURSAL...'
                                      : brancheName.join(', '),
                                ),
                              );
                            },
                            menuItembuilder: (String value) {
                              var branche = allBranches.firstWhere(
                                (element) => element.id.toString() == value,
                                orElse: () =>
                                    BrancheCaiemca(id: -1, name: 'Desconocido'),
                              );
                              var contains = selectedBranches.contains(value);
                              return ListTile(
                                title: Text(
                                  branche.name ?? '',
                                  style: TextStyle(
                                    color: contains
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.black,
                                  ),
                                ),
                                selected: contains,
                              );
                            },
                          ),
                        ),

                        SizedBox(
                          height: kDefaultPadding,
                        ),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: CaiemcaButtonWidget(
                            onPressed: (){
                              Navigator.pop(context,{
                                'selectedBrands':selectedBrands,
                                'selectedModels':selectedModels,
                                'selectedAirTypes':selectedAirTyes,
                                'selectedLocations':selectedLocations,
                                'selectedBranches':selectedBranches
                              });
                            },
                            title: 'APLICAR',
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
