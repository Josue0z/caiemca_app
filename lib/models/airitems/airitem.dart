// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:caiemca_app/models/devices/device.dart';
import 'package:flutter/foundation.dart';

import 'package:caiemca_app/models/aircomponentdetails/airComponentDetails.dart';
import 'package:caiemca_app/models/failuresdetails/failuresdetails.dart';

class AirItemCaiemca {
  String? id;
  String? formId;
  String? companyId;
  int? deviceId;
  DeviceCaiemca? deviceCaiemca;
  bool? check;
  List<AirComponentDetails> components;
  List<FailuresDetails> failures;
  DateTime? createdAt;
  AirItemCaiemca({
    this.id,
    this.formId,
    this.companyId,
    this.deviceId,
    this.deviceCaiemca,
    this.check,
    required this.components,
    required this.failures,
    this.createdAt,
  });

  AirItemCaiemca copyWith({
    String? id,
    String? formId,
    String? companyId,
    int? deviceId,
    bool? check,
    List<AirComponentDetails>? components,
    List<FailuresDetails>? failures,
    DateTime? createdAt,
  }) {
    return AirItemCaiemca(
      id: id ?? this.id,
      formId: formId ?? this.formId,
      companyId: companyId ?? this.companyId,
      deviceId: deviceId ?? this.deviceId,
      check: check ?? this.check,
      components: components ?? this.components,
      failures: failures ?? this.failures,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'formId': formId,
      'companyId': companyId,
      'deviceId': deviceId,
      'check': check,
      'components': components.map((x) => x.toMap()).toList(),
      'failures': failures.map((x) => x.toMap()).toList(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory AirItemCaiemca.fromMap(Map<String, dynamic> map) {
    return AirItemCaiemca(
      id: map['id'] != null ? map['id'] as String : null,
      formId: map['formId'] != null ? map['formId'] as String : null,
      companyId: map['companyId'] != null ? map['companyId'] as String : null,
      deviceId: map['deviceId'] != null ? map['deviceId'] as int : null,
      check: map['check'] != null ? map['check'] as bool : null,
      components:map['components']  != null ? List<AirComponentDetails>.from((map['components'] as List).map((x) => AirComponentDetails.fromMap(x)).toList()) : [],
      failures:map['failures'] != null ? List<FailuresDetails>.from((map['failures'] as List).map((x) => FailuresDetails.fromMap(x)).toList()) : [],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AirItemCaiemca.fromJson(String source) => AirItemCaiemca.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AirItemCaiemca(id: $id, formId: $formId, companyId: $companyId, deviceId: $deviceId, check: $check, components: $components, failures: $failures, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant AirItemCaiemca other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.formId == formId &&
      other.companyId == companyId &&
      other.deviceId == deviceId &&
      other.check == check &&
      listEquals(other.components, components) &&
      listEquals(other.failures, failures) &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      formId.hashCode ^
      companyId.hashCode ^
      deviceId.hashCode ^
      check.hashCode ^
      components.hashCode ^
      failures.hashCode ^
      createdAt.hashCode;
  }
}
