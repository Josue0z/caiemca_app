// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:caiemca_app/apis/api.caiemca.dart';
import 'package:caiemca_app/models/abstracts.dart';
import 'package:caiemca_app/models/users/user.dart';
import 'package:dio/dio.dart';

class WorkerCaiemca implements CaiemcaItem<String> {
  @override
  String? id;
  int? workerRoleId;
   @override
  String? workerRoleName;
   @override
  String? workerName;
   @override
  String? workerIdentification;
   @override
  String? workerPhone;
   @override
  String? workerEmail;
   @override
  String? workerAddress;
  DateTime? createdAt;
  
  @override
  String? identification;
  
  @override
  String? name;
  WorkerCaiemca({
    this.id,
    this.workerRoleId,
    this.workerRoleName,
    this.workerName,
    this.workerIdentification,
    this.workerPhone,
    this.workerEmail,
    this.workerAddress,
    this.createdAt,
    this.identification,
    this.name,
  });

      static Future<List<WorkerCaiemca>> get() async {
    try {
      await auth();
      var res = await apiCaiemca.get('/workers/all');

      if (res.statusCode == 200) {
        var data = res.data;
        return List.from(
          (data as List<dynamic>).map((e) => WorkerCaiemca.fromMap(e)).toList(),
        );
      }
      return [];
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }

  WorkerCaiemca copyWith({
    String? id,
    int? workerRoleId,
    String? workerRoleName,
    String? workerName,
    String? workerIdentification,
    String? workerPhone,
    String? workerEmail,
    String? workerAddress,
    DateTime? createdAt,
    String? identification,
    String? name,
  }) {
    return WorkerCaiemca(
      id: id ?? this.id,
      workerRoleId: workerRoleId ?? this.workerRoleId,
      workerRoleName: workerRoleName ?? this.workerRoleName,
      workerName: workerName ?? this.workerName,
      workerIdentification: workerIdentification ?? this.workerIdentification,
      workerPhone: workerPhone ?? this.workerPhone,
      workerEmail: workerEmail ?? this.workerEmail,
      workerAddress: workerAddress ?? this.workerAddress,
      createdAt: createdAt ?? this.createdAt,
      identification: identification ?? this.identification,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'workerRoleId': workerRoleId,
      'workerRoleName': workerRoleName,
      'workerName': workerName,
      'workerIdentification': workerIdentification,
      'workerPhone': workerPhone,
      'workerEmail': workerEmail,
      'workerAddress': workerAddress,
      'createdAt': createdAt?.toIso8601String(),
      'identification': identification,
      'name': name,
    };
  }

  factory WorkerCaiemca.fromMap(Map<String, dynamic> map) {
    return WorkerCaiemca(
      id: map['id'] != null ? map['id'] as String : null,
      workerRoleId: map['workerRoleId'] != null ? map['workerRoleId'] as int : null,
      workerRoleName: map['workerRoleName'] != null ? map['workerRoleName'] as String : null,
      workerName: map['workerName'] != null ? map['workerName'] as String : null,
      workerIdentification: map['workerIdentification'] != null ? map['workerIdentification'] as String : null,
      workerPhone: map['workerPhone'] != null ? map['workerPhone'] as String : null,
      workerEmail: map['workerEmail'] != null ? map['workerEmail'] as String : null,
      workerAddress: map['workerAddress'] != null ? map['workerAddress'] as String : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      identification: map['identification'] != null ? map['identification'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkerCaiemca.fromJson(String source) => WorkerCaiemca.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WorkerCaiemca(id: $id, workerRoleId: $workerRoleId, workerRoleName: $workerRoleName, workerName: $workerName, workerIdentification: $workerIdentification, workerPhone: $workerPhone, workerEmail: $workerEmail, workerAddress: $workerAddress, createdAt: $createdAt, identification: $identification, name: $name)';
  }

  @override
  bool operator ==(covariant WorkerCaiemca other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.workerRoleId == workerRoleId &&
      other.workerRoleName == workerRoleName &&
      other.workerName == workerName &&
      other.workerIdentification == workerIdentification &&
      other.workerPhone == workerPhone &&
      other.workerEmail == workerEmail &&
      other.workerAddress == workerAddress &&
      other.createdAt == createdAt &&
      other.identification == identification &&
      other.name == name;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      workerRoleId.hashCode ^
      workerRoleName.hashCode ^
      workerName.hashCode ^
      workerIdentification.hashCode ^
      workerPhone.hashCode ^
      workerEmail.hashCode ^
      workerAddress.hashCode ^
      createdAt.hashCode ^
      identification.hashCode ^
      name.hashCode;
  }

  @override
  String? roleName;
}
