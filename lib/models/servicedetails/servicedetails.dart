// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


class ServiceDetailsCaiemca {
  String? id;
  String? description;
  String? formId;
  bool? check;
  String? companyId;
  int? serviceId;
  DateTime? createdAt;
  ServiceDetailsCaiemca({
    this.id,
    this.description,
    this.formId,
    this.check,
    this.companyId,
    this.serviceId,
    this.createdAt,
  });

  ServiceDetailsCaiemca copyWith({
    String? id,
    String? description,
    String? formId,
    bool? check,
    String? companyId,
    int? serviceId,
    DateTime? createdAt,
  }) {
    return ServiceDetailsCaiemca(
      id: id ?? this.id,
      description: description ?? this.description,
      formId: formId ?? this.formId,
      check: check ?? this.check,
      companyId: companyId ?? this.companyId,
      serviceId: serviceId ?? this.serviceId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'description': description,
      'formId': formId,
      'check': check,
      'companyId': companyId,
      'serviceId': serviceId,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory ServiceDetailsCaiemca.fromMap(Map<String, dynamic> map) {
    return ServiceDetailsCaiemca(
      id: map['id'] != null ? map['id'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      formId: map['formId'] != null ? map['formId'] as String : null,
      check: map['check'] != null ? map['check'] as bool : null,
      companyId: map['companyId'] != null ? map['companyId'] as String : null,
      serviceId: map['serviceId'] != null ? map['serviceId'] as int : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceDetailsCaiemca.fromJson(String source) => ServiceDetailsCaiemca.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ServiceDetailsCaiemca(id: $id, description: $description, formId: $formId, check: $check, companyId: $companyId, serviceId: $serviceId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant ServiceDetailsCaiemca other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.description == description &&
      other.formId == formId &&
      other.check == check &&
      other.companyId == companyId &&
      other.serviceId == serviceId &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      description.hashCode ^
      formId.hashCode ^
      check.hashCode ^
      companyId.hashCode ^
      serviceId.hashCode ^
      createdAt.hashCode;
  }
}
