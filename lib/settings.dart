

import 'package:caiemca_app/models/airlocations/airlocation.dart';
import 'package:caiemca_app/models/airtypes/airtype.dart';
import 'package:caiemca_app/models/branches/branche.dart';
import 'package:caiemca_app/models/brands/brand.dart';
import 'package:caiemca_app/models/clients/client.dart';
import 'package:caiemca_app/models/components/component.dart';
import 'package:caiemca_app/models/failures/failures.dart';
import 'package:caiemca_app/models/models/model.dart';
import 'package:caiemca_app/models/permissions/permissions.dart';
import 'package:caiemca_app/models/roles/roles.dart';
import 'package:caiemca_app/models/services/service.dart';
import 'package:caiemca_app/models/technicians/technicians.dart';
import 'package:caiemca_app/models/users/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const String kAppName = 'CAIEMCA';

const Color kPrimaryColor = Color(0xFFE3A20A);

const Color kSecondaryColor = Color(0xFF17A1FA);

const Color kGreyColor = Color(0xFFB6B6B6);

const Color kBodyTextColor = Color(0xFF848383);

const double kBorderRadius = 20;

const double kDefaultPadding = 20;

const double kIconSize = 35;

const Color kCardBackgroundColor = Color(0xFFF6F6F6);

const Color kCardBorderColor = Color(0xFFE0E0E0);


UserCaiemca? currentUser;
String? currentUsername;
bool isEnabledFingerPrint = false;
List<AirType> airsTypes = [];
List<AirLocationCaiemca> airLocations = [];
List<BrandCaiemca> brands = [];
List<ModelCaiemca> models = [];
List<Role> roles = [];
List<PermissionCaiemca> permissions = [];

  List<Client> allClients = [];
  List<BrancheCaiemca> allBranches = [];
  List<ServiceCaiemca> allServices = [];
List<Failures> allFailures = [];
List<ComponentCaiemca> allComponents = [];
List<TechnicianCaiemca> allTechnicians = [];