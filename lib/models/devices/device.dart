// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:caiemca_app/apis/api.caiemca.dart';
import 'package:caiemca_app/models/abstracts.dart';
import 'package:caiemca_app/models/users/user.dart';
import 'package:dio/dio.dart';

class DeviceCaiemca implements CaiemcaItem<int> {
  @override
  int? id;
  int? modelId;
  String? modelName;
  int? brandId;
  String? brandName;
  int? airTypeId;
  String? airTypeName;
  int? locationId;
  String? airLocationName;
  int? brancheId;
  String? brancheName;
  String? serialNumber;
  String? clientName;
  String? clientIdentification;
  double? amperes;
  double? volt;
  String? companyId;
  DateTime? createdAt;
  DeviceCaiemca({
    this.id,
    this.modelId,
    this.modelName,
    this.brandId,
    this.brandName,
    this.airTypeId,
    this.airTypeName,
    this.locationId,
    this.airLocationName,
    this.brancheId,
    this.brancheName,
    this.serialNumber,
    this.clientName,
    this.clientIdentification,
    this.amperes,
    this.volt,
    this.companyId,
    this.createdAt,
  });
  static Future<List<DeviceCaiemca>> get({int? brancheId}) async {
    try {
      var params = '';
      var query = [];

      if (brancheId != null) {
        query.add('brancheId=$brancheId');
      }

      params = '?${query.join('&')}';

      await auth();
      var res = await apiCaiemca.get('/devices/all$params');

      if (res.statusCode == 200) {
        var data = res.data;
        return List.from(
          (data as List<dynamic>).map((e) => DeviceCaiemca.fromMap(e)).toList(),
        );
      }
      return [];
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }

  static Future<DeviceCaiemca?> findDeviceBySerialNumber({
    String? serialNumber,
    String? clientId,
    int? brancheId
  }) async {
    try {
   
      await auth();
    
      var res = await apiCaiemca.get('/devices/serials/serialNumber?serialNumber=$serialNumber&clientId=$clientId&brancheId=$brancheId');

      if (res.statusCode == 200) {
        var data = res.data;

        return DeviceCaiemca.fromMap(data);
      }
      return null;
    } on DioException catch (_) {
      return null;
    }
  }

  Future<DeviceCaiemca?> create() async {
    try {
      await auth();
      var map = toMap();
      map.remove('id');
      map.remove('companyId');
      map.remove('createdAt');
      map.remove('modelName');
      map.remove('brandName');
      map.remove('airTypeName');
      map.remove('airLocationName');
      map.remove('brancheName');
      map.remove('clientName');
      map.remove('clientIdentification');
      var res = await apiCaiemca.post('/devices/create', data: map);
      if (res.statusCode == 200) {
        return DeviceCaiemca.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }

  Future<DeviceCaiemca?> update() async {
    try {
      await auth();
      var map = toMap();
      map.remove('id');
      map.remove('companyId');
      map.remove('createdAt');
      map.remove('modelName');
      map.remove('brandName');
      map.remove('airTypeName');
      map.remove('airLocationName');
      map.remove('brancheName');
      map.remove('clientName');
      map.remove('clientIdentification');
      var res = await apiCaiemca.put('/devices/update/$id', data: map);
      if (res.statusCode == 200) {
        return DeviceCaiemca.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }

  DeviceCaiemca copyWith({
    int? id,
    int? modelId,
    String? modelName,
    int? brandId,
    String? brandName,
    int? airTypeId,
    String? airTypeName,
    int? locationId,
    String? airLocationName,
    int? brancheId,
    String? brancheName,
    String? serialNumber,
    String? clientName,
    String? clientIdentification,
    double? amperes,
    double? volt,
    String? companyId,
    DateTime? createdAt,
  }) {
    return DeviceCaiemca(
      id: id ?? this.id,
      modelId: modelId ?? this.modelId,
      modelName: modelName ?? this.modelName,
      brandId: brandId ?? this.brandId,
      brandName: brandName ?? this.brandName,
      airTypeId: airTypeId ?? this.airTypeId,
      airTypeName: airTypeName ?? this.airTypeName,
      locationId: locationId ?? this.locationId,
      airLocationName: airLocationName ?? this.airLocationName,
      brancheId: brancheId ?? this.brancheId,
      brancheName: brancheName ?? this.brancheName,
      serialNumber: serialNumber ?? this.serialNumber,
      clientName: clientName ?? this.clientName,
      clientIdentification: clientIdentification ?? this.clientIdentification,
      amperes: amperes ?? this.amperes,
      volt: volt ?? this.volt,
      companyId: companyId ?? this.companyId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'modelId': modelId,
      'modelName': modelName,
      'brandId': brandId,
      'brandName': brandName,
      'airTypeId': airTypeId,
      'airTypeName': airTypeName,
      'locationId': locationId,
      'airLocationName': airLocationName,
      'brancheId': brancheId,
      'brancheName': brancheName,
      'serialNumber': serialNumber,
      'clientName': clientName,
      'clientIdentification': clientIdentification,
      'amperes': amperes,
      'volt': volt,
      'companyId': companyId,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory DeviceCaiemca.fromMap(Map<String, dynamic> map) {
    return DeviceCaiemca(
      id: map['id'] != null ? map['id'] as int : null,
      modelId: map['modelId'] != null ? map['modelId'] as int : null,
      modelName: map['modelName'] != null ? map['modelName'] as String : null,
      brandId: map['brandId'] != null ? map['brandId'] as int : null,
      brandName: map['brandName'] != null ? map['brandName'] as String : null,
      airTypeId: map['airTypeId'] != null ? map['airTypeId'] as int : null,
      airTypeName: map['airTypeName'] != null
          ? map['airTypeName'] as String
          : null,
      locationId: map['locationId'] != null ? map['locationId'] as int : null,
      airLocationName: map['airLocationName'] != null
          ? map['airLocationName'] as String
          : null,
      brancheId: map['brancheId'] != null ? map['brancheId'] as int : null,
      brancheName: map['brancheName'] != null
          ? map['brancheName'] as String
          : null,
      serialNumber: map['serialNumber'] != null
          ? map['serialNumber'] as String
          : null,
      clientName: map['clientName'] != null
          ? map['clientName'] as String
          : null,
      clientIdentification: map['clientIdentification'] != null
          ? map['clientIdentification'] as String
          : null,
      amperes: map['amperes'] != null ? map['amperes'] as double : null,
      volt: map['volt'] != null ? map['volt'] as double : null,
      companyId: map['companyId'] != null ? map['companyId'] as String : null,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt']).toLocal()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DeviceCaiemca.fromJson(String source) =>
      DeviceCaiemca.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DeviceCaiemca(id: $id, modelId: $modelId, modelName: $modelName, brandId: $brandId, brandName: $brandName, airTypeId: $airTypeId, airTypeName: $airTypeName, locationId: $locationId, airLocationName: $airLocationName, brancheId: $brancheId, brancheName: $brancheName, serialNumber: $serialNumber, clientName: $clientName, clientIdentification: $clientIdentification, amperes: $amperes, volt: $volt, companyId: $companyId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant DeviceCaiemca other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.modelId == modelId &&
        other.modelName == modelName &&
        other.brandId == brandId &&
        other.brandName == brandName &&
        other.airTypeId == airTypeId &&
        other.airTypeName == airTypeName &&
        other.locationId == locationId &&
        other.airLocationName == airLocationName &&
        other.brancheId == brancheId &&
        other.brancheName == brancheName &&
        other.serialNumber == serialNumber &&
        other.clientName == clientName &&
        other.clientIdentification == clientIdentification &&
        other.amperes == amperes &&
        other.volt == volt &&
        other.companyId == companyId &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        modelId.hashCode ^
        modelName.hashCode ^
        brandId.hashCode ^
        brandName.hashCode ^
        airTypeId.hashCode ^
        airTypeName.hashCode ^
        locationId.hashCode ^
        airLocationName.hashCode ^
        brancheId.hashCode ^
        brancheName.hashCode ^
        serialNumber.hashCode ^
        clientName.hashCode ^
        clientIdentification.hashCode ^
        amperes.hashCode ^
        volt.hashCode ^
        companyId.hashCode ^
        createdAt.hashCode;
  }

  @override
  String? identification;

  @override
  String? name;

  @override
  String? roleName;

  @override
  String? workerAddress;

  @override
  String? workerEmail;

  @override
  String? workerIdentification;

  @override
  String? workerName;

  @override
  String? workerPhone;

  @override
  String? workerRoleName;
}
