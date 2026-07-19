// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TechniciansDetails {
  String? id;
  String? technicianId;
  String? description;
  String? formId;
  String? companyId;
  DateTime? createdAt;
  TechniciansDetails({
    this.id,
    this.technicianId,
    this.description,
    this.formId,
    this.companyId,
    this.createdAt,
  });

  TechniciansDetails copyWith({
    String? id,
    String? technicianId,
    String? description,
    String? formId,
    String? companyId,
    DateTime? createdAt,
  }) {
    return TechniciansDetails(
      id: id ?? this.id,
      technicianId: technicianId ?? this.technicianId,
      description: description ?? this.description,
      formId: formId ?? this.formId,
      companyId: companyId ?? this.companyId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'technicianId': technicianId,
      'description': description,
      'formId': formId,
      'companyId': companyId,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory TechniciansDetails.fromMap(Map<String, dynamic> map) {
    return TechniciansDetails(
      id: map['id'] != null ? map['id'] as String : null,
      technicianId: map['technicianId'] != null ? map['technicianId'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      formId: map['formId'] != null ? map['formId'] as String : null,
      companyId: map['companyId'] != null ? map['companyId'] as String : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TechniciansDetails.fromJson(String source) => TechniciansDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TechniciansDetails(id: $id, technicianId: $technicianId, description: $description, formId: $formId, companyId: $companyId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant TechniciansDetails other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.technicianId == technicianId &&
      other.description == description &&
      other.formId == formId &&
      other.companyId == companyId &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      technicianId.hashCode ^
      description.hashCode ^
      formId.hashCode ^
      companyId.hashCode ^
      createdAt.hashCode;
  }
}
