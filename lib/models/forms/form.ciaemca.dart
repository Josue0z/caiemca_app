// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:caiemca_app/apis/api.caiemca.dart';
import 'package:caiemca_app/models/airitems/airitem.dart';
import 'package:caiemca_app/models/servicedetails/servicedetails.dart';
import 'package:caiemca_app/models/techniciansDetails/techniciansDetails.dart';
import 'package:caiemca_app/models/users/user.dart';
import 'package:caiemca_app/settings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


class FormCaiemca {
  String? id;
  String? companyId;
  String? clientId;
  String? clientIdentification;
  String? clientName;
  String? workerId;
  String? workerIdentification;
  String? workerName;
  int? workerRoleId;
  String? workerRoleName;
  String? workerPhone;
  String? workerEmail;
  String? workerAddress;
  int? responsibleId;
  String? responsibleName;
  String? responsibleIdentification;
  String? responsiblePhone;
  String? responsibleAddress;
  String? othersInfo;
  int? branchId;
  String? branchName;
  String? clientSignature;
  String? signatureResponsible;
  DateTime? createdAt;
  String? locationName;
  double? locationX;
  double? locationY;
  String? formNumber;
  String? createdBy;
  String? authorName;
  String? companyName;
  String? companyRnc;
  String? companyAddress;
  String? companyPhone1;
  String? companyPhone2;
  String? companyEmail;
  String? companyLogo;
  List<ServiceDetailsCaiemca> services;
  List<AirItemCaiemca> airItems;
  List<TechniciansDetails> technicians = [];
  bool isSignature;
  int? stateId;
  String? stateName;
  FormCaiemca({
    this.id,
    this.companyId,
    this.clientId,
    this.clientIdentification,
    this.clientName,
    this.workerId,
    this.workerIdentification,
    this.workerName,
    this.workerRoleId,
    this.workerRoleName,
    this.workerPhone,
    this.workerEmail,
    this.workerAddress,
    this.responsibleId,
    this.responsibleName,
    this.responsibleIdentification,
    this.responsiblePhone,
    this.responsibleAddress,
    this.othersInfo,
    this.branchId,
    this.branchName,
    this.clientSignature,
    this.signatureResponsible,
    this.createdAt,
    this.locationName,
    this.locationX = 0,
    this.locationY = 0,
    this.formNumber,
    this.createdBy,
    this.authorName,
    this.companyName,
    this.companyRnc,
    this.companyAddress,
    this.companyPhone1,
    this.companyPhone2,
    this.companyEmail,
    this.companyLogo,
    this.services = const [],
    this.airItems = const [],
    this.isSignature = false,
    this.stateId,
    this.stateName
  });

  String get formUrl {
    return '$kDomainBase/forms/pdfs/$id?companyId=${currentUser?.company?.id}';
  }

  Color get stateColor {
    if(stateId == 1) return Colors.green;
    if(stateId == 2) return Colors.orange;
    if(stateId == 3) return Colors.red;
    return Colors.transparent;
  }

  Future<bool?> create()async{
    try{
      await auth();
      var map = toMap();
      map.remove('id');
      map.remove('companyId');
      var res = await apiCaiemca.post('/forms/create',data: map);
      if(res.statusCode == 200){
        return true;
      }
      return null;
    }on DioException catch(e){
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }

  Future<bool?> signatureFormPdf()async{
    try{
      await auth();
      var res = await apiCaiemca.put('/forms/signature/$id',data: {
        'clientSignature': clientSignature,
        'signatureResponsible':signatureResponsible
      });
      if(res.statusCode == 200){
        return true;
      }
      return null;
    }on DioException catch(e){
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }


  static Future<List<FormCaiemca>> get({
    List<String> selectedBrands = const [],
    List<String> selectedModels = const [],
    List<String> selectedAirTypes = const [],
    List<String> selectedLocations = const [],
    List<String> selectedBranches = const []
  }) async {
    try {
      await auth();

      var query = [];

      if(selectedBrands.isNotEmpty){
        query.add('brands=${selectedBrands.join(',')}');
      }
      if(selectedModels.isNotEmpty){
        query.add('models=${selectedModels.join(',')}');
      }

       if(selectedAirTypes.isNotEmpty){
        query.add('airTypes=${selectedAirTypes.join(',')}');
      }

      if(selectedLocations.isNotEmpty){
        query.add('locations=${selectedLocations.join(',')}');
      }

      if(selectedBranches.isNotEmpty){
        query.add('branches=${selectedBranches.join(',')}');
      }


      var params ='?${query.join('&')}';
      var res = await apiCaiemca.get('/forms/all$params');

      if (res.statusCode == 200) {
        var data = res.data;
        return List.from(
          (data as List<dynamic>).map((e) => FormCaiemca.fromMap(e)).toList(),
        );
      }
      return [];
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }


  FormCaiemca copyWith({
    String? id,
    String? companyId,
    String? clientId,
    String? clientIdentification,
    String? clientName,
    String? workerId,
    String? workerIdentification,
    String? workerName,
    int? workerRoleId,
    String? workerRoleName,
    String? workerPhone,
    String? workerEmail,
    String? workerAddress,
    int? responsibleId,
    String? responsibleName,
    String? responsibleIdentification,
    String? responsiblePhone,
    String? responsibleAddress,
    String? othersInfo,
    int? branchId,
    String? branchName,
    String? clientSignature,
    String? signatureResponsible,
    DateTime? createdAt,
    String? locationName,
    double? locationX,
    double? locationY,
    String? formNumber,
    String? createdBy,
    String? authorName,
    String? companyName,
    String? companyRnc,
    String? companyAddress,
    String? companyPhone1,
    String? companyPhone2,
    String? companyEmail,
    String? companyLogo,
  }) {
    return FormCaiemca(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      clientId: clientId ?? this.clientId,
      clientIdentification: clientIdentification ?? this.clientIdentification,
      clientName: clientName ?? this.clientName,
      workerId: workerId ?? this.workerId,
      workerIdentification: workerIdentification ?? this.workerIdentification,
      workerName: workerName ?? this.workerName,
      workerRoleId: workerRoleId ?? this.workerRoleId,
      workerRoleName: workerRoleName ?? this.workerRoleName,
      workerPhone: workerPhone ?? this.workerPhone,
      workerEmail: workerEmail ?? this.workerEmail,
      workerAddress: workerAddress ?? this.workerAddress,
      responsibleId: responsibleId ?? this.responsibleId,
      responsibleName: responsibleName ?? this.responsibleName,
      responsibleIdentification: responsibleIdentification ?? this.responsibleIdentification,
      responsiblePhone: responsiblePhone ?? this.responsiblePhone,
      responsibleAddress: responsibleAddress ?? this.responsibleAddress,
      othersInfo: othersInfo ?? this.othersInfo,
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
      clientSignature: clientSignature ?? this.clientSignature,
      signatureResponsible: signatureResponsible ?? this.signatureResponsible,
      createdAt: createdAt ?? this.createdAt,
      locationName: locationName ?? this.locationName,
      locationX: locationX ?? this.locationX,
      locationY: locationY ?? this.locationY,
      formNumber: formNumber ?? this.formNumber,
      createdBy: createdBy ?? this.createdBy,
      authorName: authorName ?? this.authorName,
      companyName: companyName ?? this.companyName,
      companyRnc: companyRnc ?? this.companyRnc,
      companyAddress: companyAddress ?? this.companyAddress,
      companyPhone1: companyPhone1 ?? this.companyPhone1,
      companyPhone2: companyPhone2 ?? this.companyPhone2,
      companyEmail: companyEmail ?? this.companyEmail,
      companyLogo: companyLogo ?? this.companyLogo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
       'id': id,
       "form": {
        "clientId":clientId,
        "workerId": workerId,
        "othersInfo": othersInfo,
        "branchId": branchId,
        "clientSignature": clientSignature,
        "signatureResponsible": signatureResponsible,
        'responsibleIdentification':responsibleIdentification,
        'responsibleName':responsibleName,
        "locationName": locationName,
        "locationX":locationX,
        "locationY":locationY,
       },
      'companyId': companyId,
      'clientId': clientId,
      'clientIdentification': clientIdentification,
      'clientName': clientName,
      'workerId': workerId,
      'workerIdentification': workerIdentification,
      'workerName': workerName,
      'workerRoleId': workerRoleId,
      'workerRoleName': workerRoleName,
      'workerPhone': workerPhone,
      'workerEmail': workerEmail,
      'workerAddress': workerAddress,
      'responsibleId': responsibleId,
      'responsibleName': responsibleName,
      'responsibleIdentification': responsibleIdentification,
      'responsiblePhone': responsiblePhone,
      'responsibleAddress': responsibleAddress,
      'othersInfo': othersInfo,
      'branchId': branchId,
      'branchName': branchName,
      'clientSignature': clientSignature,
      'signatureResponsible': signatureResponsible,
      'createdAt': createdAt?.toIso8601String(),
      'locationName': locationName,
      'locationX': locationX,
      'locationY': locationY,
      'formNumber': formNumber,
      'createdBy': createdBy,
      'authorName': authorName,
      'companyName': companyName,
      'companyRnc': companyRnc,
      'companyAddress': companyAddress,
      'companyPhone1': companyPhone1,
      'companyPhone2': companyPhone2,
      'companyEmail': companyEmail,
      'companyLogo': companyLogo,
      'services': services.map((e)=>e.toMap()).toList(),
      'airItems': airItems.map((e) => e.toMap()).toList(),
      'technicians': technicians.map((e) => e.toMap()).toList(),
    };
  }

  factory FormCaiemca.fromMap(Map<String, dynamic> map) {
    return FormCaiemca(
      id: map['id'] != null ? map['id'] as String : null,
      companyId: map['companyId'] != null ? map['companyId'] as String : null,
      clientId: map['clientId'] != null ? map['clientId'] as String : null,
      clientIdentification: map['clientIdentification'] != null ? map['clientIdentification'] as String : null,
      clientName: map['clientName'] != null ? map['clientName'] as String : null,
      workerId: map['workerId'] != null ? map['workerId'] as String : null,
      workerIdentification: map['workerIdentification'] != null ? map['workerIdentification'] as String : null,
      workerName: map['workerName'] != null ? map['workerName'] as String : null,
      workerRoleId: map['workerRoleId'] != null ? map['workerRoleId'] as int : null,
      workerRoleName: map['workerRoleName'] != null ? map['workerRoleName'] as String : null,
      workerPhone: map['workerPhone'] != null ? map['workerPhone'] as String : null,
      workerEmail: map['workerEmail'] != null ? map['workerEmail'] as String : null,
      workerAddress: map['workerAddress'] != null ? map['workerAddress'] as String : null,
      responsibleId: map['responsibleId'] != null ? map['responsibleId'] as int : null,
      responsibleName: map['responsibleName'] != null ? map['responsibleName'] as String : null,
      responsibleIdentification: map['responsibleIdentification'] != null ? map['responsibleIdentification'] as String : null,
      responsiblePhone: map['responsiblePhone'] != null ? map['responsiblePhone'] as String : null,
      responsibleAddress: map['responsibleAddress'] != null ? map['responsibleAddress'] as String : null,
      othersInfo: map['othersInfo'] != null ? map['othersInfo'] as String : null,
      branchId: map['branchId'] != null ? map['branchId'] as int : null,
      branchName: map['branchName'] != null ? map['branchName'] as String : null,
      clientSignature: map['clientSignature'] != null ? map['clientSignature'] as String : null,
      signatureResponsible: map['signatureResponsible'] != null ? map['signatureResponsible'] as String : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']).toLocal() : null,
      locationName: map['locationName'] != null ? map['locationName'] as String : null,
      locationX: map['locationX'] != null ? map['locationX'] as double : null,
      locationY: map['locationY'] != null ? map['locationY'] as double : null,
      formNumber: map['formNumber'] != null ? map['formNumber'] as String : null,
      createdBy: map['createdBy'] != null ? map['createdBy'] as String : null,
      authorName: map['authorName'] != null ? map['authorName'] as String : null,
      companyName: map['companyName'] != null ? map['companyName'] as String : null,
      companyRnc: map['companyRnc'] != null ? map['companyRnc'] as String : null,
      companyAddress: map['companyAddress'] != null ? map['companyAddress'] as String : null,
      companyPhone1: map['companyPhone1'] != null ? map['companyPhone1'] as String : null,
      companyPhone2: map['companyPhone2'] != null ? map['companyPhone2'] as String : null,
      companyEmail: map['companyEmail'] != null ? map['companyEmail'] as String : null,
      companyLogo: map['companyLogo'] != null ? map['companyLogo'] as String : null,
      services:map['services'] != null ? List.from((map['services'] as List).map((e)=> ServiceDetailsCaiemca.fromMap(e)).toList()) : [],
      airItems:map['airItems'] != null ? List.from((map['airItems'] as List).map((e)=> AirItemCaiemca.fromMap(e)).toList()) : [],
      isSignature: map['isSignature'],
      stateId: map['stateId'],
      stateName: map['stateName']
    
    );
  }

  String toJson() => json.encode(toMap());

  factory FormCaiemca.fromJson(String source) => FormCaiemca.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FormCaiemca(id: $id, companyId: $companyId, clientId: $clientId, clientIdentification: $clientIdentification, clientName: $clientName, workerId: $workerId, workerIdentification: $workerIdentification, workerName: $workerName, workerRoleId: $workerRoleId, workerRoleName: $workerRoleName, workerPhone: $workerPhone, workerEmail: $workerEmail, workerAddress: $workerAddress, responsibleId: $responsibleId, responsibleName: $responsibleName, responsibleIdentification: $responsibleIdentification, responsiblePhone: $responsiblePhone, responsibleAddress: $responsibleAddress, othersInfo: $othersInfo, branchId: $branchId, branchName: $branchName, clientSignature: $clientSignature, signatureResponsible: $signatureResponsible, createdAt: $createdAt, locationName: $locationName, locationX: $locationX, locationY: $locationY, formNumber: $formNumber, createdBy: $createdBy, authorName: $authorName, companyName: $companyName, companyRnc: $companyRnc, companyAddress: $companyAddress, companyPhone1: $companyPhone1, companyPhone2: $companyPhone2, companyEmail: $companyEmail, companyLogo: $companyLogo, services: $services, airItems: $airItems, isSignature: $isSignature, stateId: $stateId, stateName: $stateName)';
  }

  @override
  bool operator ==(covariant FormCaiemca other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.companyId == companyId &&
      other.clientId == clientId &&
      other.clientIdentification == clientIdentification &&
      other.clientName == clientName &&
      other.workerId == workerId &&
      other.workerIdentification == workerIdentification &&
      other.workerName == workerName &&
      other.workerRoleId == workerRoleId &&
      other.workerRoleName == workerRoleName &&
      other.workerPhone == workerPhone &&
      other.workerEmail == workerEmail &&
      other.workerAddress == workerAddress &&
      other.responsibleId == responsibleId &&
      other.responsibleName == responsibleName &&
      other.responsibleIdentification == responsibleIdentification &&
      other.responsiblePhone == responsiblePhone &&
      other.responsibleAddress == responsibleAddress &&
      other.othersInfo == othersInfo &&
      other.branchId == branchId &&
      other.branchName == branchName &&
      other.clientSignature == clientSignature &&
      other.signatureResponsible == signatureResponsible &&
      other.createdAt == createdAt &&
      other.locationName == locationName &&
      other.locationX == locationX &&
      other.locationY == locationY &&
      other.formNumber == formNumber &&
      other.createdBy == createdBy &&
      other.authorName == authorName &&
      other.companyName == companyName &&
      other.companyRnc == companyRnc &&
      other.companyAddress == companyAddress &&
      other.companyPhone1 == companyPhone1 &&
      other.companyPhone2 == companyPhone2 &&
      other.companyEmail == companyEmail &&
      other.companyLogo == companyLogo;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      companyId.hashCode ^
      clientId.hashCode ^
      clientIdentification.hashCode ^
      clientName.hashCode ^
      workerId.hashCode ^
      workerIdentification.hashCode ^
      workerName.hashCode ^
      workerRoleId.hashCode ^
      workerRoleName.hashCode ^
      workerPhone.hashCode ^
      workerEmail.hashCode ^
      workerAddress.hashCode ^
      responsibleId.hashCode ^
      responsibleName.hashCode ^
      responsibleIdentification.hashCode ^
      responsiblePhone.hashCode ^
      responsibleAddress.hashCode ^
      othersInfo.hashCode ^
      branchId.hashCode ^
      branchName.hashCode ^
      clientSignature.hashCode ^
      signatureResponsible.hashCode ^
      createdAt.hashCode ^
      locationName.hashCode ^
      locationX.hashCode ^
      locationY.hashCode ^
      formNumber.hashCode ^
      createdBy.hashCode ^
      authorName.hashCode ^
      companyName.hashCode ^
      companyRnc.hashCode ^
      companyAddress.hashCode ^
      companyPhone1.hashCode ^
      companyPhone2.hashCode ^
      companyEmail.hashCode ^
      companyLogo.hashCode;
  }
}
