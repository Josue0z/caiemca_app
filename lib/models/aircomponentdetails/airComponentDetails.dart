// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';



class AirComponentDetails {
  String? id;
  String? airItemId;
  int? componentId;
  int? formId;
  String? companyId;
  DateTime? createdAt;
  AirComponentDetails({
    this.id,
    this.airItemId,
    this.componentId,
    this.formId,
    this.companyId,
    this.createdAt,
  });

  AirComponentDetails copyWith({
    String? id,
    String? airItemId,
    int? componentId,
    int? formId,
    String? companyId,
    DateTime? createdAt,
  }) {
    return AirComponentDetails(
      id: id ?? this.id,
      airItemId: airItemId ?? this.airItemId,
      componentId: componentId ?? this.componentId,
      formId: formId ?? this.formId,
      companyId: companyId ?? this.companyId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'airItemId': airItemId,
      'componentId': componentId,
      'formId': formId,
      'companyId': companyId,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory AirComponentDetails.fromMap(Map<String, dynamic> map) {
    return AirComponentDetails(
      id: map['id'] != null ? map['id'] as String : null,
      airItemId: map['airItemId'] != null ? map['airItemId'] as String : null,
      componentId: map['componentId'] != null ? map['componentId'] as int : null,
      formId: map['formId'] != null ? map['formId'] as int : null,
      companyId: map['companyId'] != null ? map['companyId'] as String : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AirComponentDetails.fromJson(String source) => AirComponentDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AirComponentDetails(id: $id, airItemId: $airItemId, componentId: $componentId, formId: $formId, companyId: $companyId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant AirComponentDetails other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.airItemId == airItemId &&
      other.componentId == componentId &&
      other.formId == formId &&
      other.companyId == companyId &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      airItemId.hashCode ^
      componentId.hashCode ^
      formId.hashCode ^
      companyId.hashCode ^
      createdAt.hashCode;
  }
}
