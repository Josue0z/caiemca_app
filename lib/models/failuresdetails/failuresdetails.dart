// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


class FailuresDetails {
  String? id;
  String? formId;
  int? deviceId;
  String? description;
  bool? check;
  int? failureId;
  String? airItemId;
  String? companyId;
  DateTime? createdAt;
  FailuresDetails({
    this.id,
    this.formId,
    this.deviceId,
    this.description,
    this.check,
    this.failureId,
    this.airItemId,
    this.companyId,
    this.createdAt,
  });

  FailuresDetails copyWith({
    String? id,
    String? formId,
    int? deviceId,
    String? description,
    bool? check,
    int? failureId,
    String? airItemId,
    String? companyId,
    DateTime? createdAt,
  }) {
    return FailuresDetails(
      id: id ?? this.id,
      formId: formId ?? this.formId,
      deviceId: deviceId ?? this.deviceId,
      description: description ?? this.description,
      check: check ?? this.check,
      failureId: failureId ?? this.failureId,
      airItemId: airItemId ?? this.airItemId,
      companyId: companyId ?? this.companyId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'formId': formId,
      'deviceId': deviceId,
      'description': description,
      'check': check,
      'failureId': failureId,
      'airItemId': airItemId,
      'companyId': companyId,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory FailuresDetails.fromMap(Map<String, dynamic> map) {
    return FailuresDetails(
      id: map['id'] != null ? map['id'] as String : null,
      formId: map['formId'] != null ? map['formId'] as String : null,
      deviceId: map['deviceId'] != null ? map['deviceId'] as int : null,
      description: map['description'] != null ? map['description'] as String : null,
      check: map['check'] != null ? map['check'] as bool : null,
      failureId: map['failureId'] != null ? map['failureId'] as int : null,
      airItemId: map['airItemId'] != null ? map['airItemId'] as String : null,
      companyId: map['companyId'] != null ? map['companyId'] as String : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FailuresDetails.fromJson(String source) => FailuresDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FailuresDetails(id: $id, formId: $formId, deviceId: $deviceId, description: $description, check: $check, failureId: $failureId, airItemId: $airItemId, companyId: $companyId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant FailuresDetails other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.formId == formId &&
      other.deviceId == deviceId &&
      other.description == description &&
      other.check == check &&
      other.failureId == failureId &&
      other.airItemId == airItemId &&
      other.companyId == companyId &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      formId.hashCode ^
      deviceId.hashCode ^
      description.hashCode ^
      check.hashCode ^
      failureId.hashCode ^
      airItemId.hashCode ^
      companyId.hashCode ^
      createdAt.hashCode;
  }
}
