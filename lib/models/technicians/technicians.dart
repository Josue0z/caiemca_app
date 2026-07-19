// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:caiemca_app/apis/api.caiemca.dart';
import 'package:caiemca_app/models/abstracts.dart';
import 'package:caiemca_app/models/users/user.dart';
import 'package:dio/dio.dart';

class TechnicianCaiemca implements CaiemcaItem<String> {
  @override
  String? id;
  @override
  String? name;
  String? phone;
  String? email;
  String? address;
  @override
  String? identification;
  String? companyId;
  DateTime? createdAt;
  
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

     static Future<List<TechnicianCaiemca>> get() async {
    try {
      await auth();
      var res = await apiCaiemca.get('/technicians/all');

      if (res.statusCode == 200) {
        var data = res.data;
        return List.from(
          (data as List<dynamic>).map((e) => TechnicianCaiemca.fromMap(e)).toList(),
        );
      }
      return [];
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }

    Future<TechnicianCaiemca?> create()async{
    try{
      await auth();
      var map = toMap();
      map.remove('id');
      map.remove('companyId');
      map.remove('createdAt');
      var res = await apiCaiemca.post('/technicians/create',data: map);
      if(res.statusCode == 200){
        return TechnicianCaiemca.fromMap(res.data);
      }
      return null;
    }on DioException catch(e){
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }

    Future<TechnicianCaiemca?> update()async{
    try{
      await auth();
      var map = toMap();
      map.remove('id');
      map.remove('companyId');
      map.remove('createdAt');
      var res = await apiCaiemca.put('/technicians/update/$id',data: map);
      if(res.statusCode == 200){
        return TechnicianCaiemca.fromMap(res.data);
      }
      return null;
    }on DioException catch(e){
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }
  TechnicianCaiemca({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.address,
    this.identification,
    this.companyId,
    this.createdAt,
    this.roleName,
    this.workerAddress,
    this.workerEmail,
    this.workerIdentification,
    this.workerName,
    this.workerPhone,
    this.workerRoleName,
  });

  TechnicianCaiemca copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    String? identification,
    String? companyId,
    DateTime? createdAt,
    String? roleName,
    String? workerAddress,
    String? workerEmail,
    String? workerIdentification,
    String? workerName,
    String? workerPhone,
    String? workerRoleName,
  }) {
    return TechnicianCaiemca(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      identification: identification ?? this.identification,
      companyId: companyId ?? this.companyId,
      createdAt: createdAt ?? this.createdAt,
      roleName: roleName ?? this.roleName,
      workerAddress: workerAddress ?? this.workerAddress,
      workerEmail: workerEmail ?? this.workerEmail,
      workerIdentification: workerIdentification ?? this.workerIdentification,
      workerName: workerName ?? this.workerName,
      workerPhone: workerPhone ?? this.workerPhone,
      workerRoleName: workerRoleName ?? this.workerRoleName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'identification': identification,
      'companyId': companyId,
      'createdAt': createdAt?.toIso8601String(),
      'roleName': roleName,
      'workerAddress': workerAddress,
      'workerEmail': workerEmail,
      'workerIdentification': workerIdentification,
      'workerName': workerName,
      'workerPhone': workerPhone,
      'workerRoleName': workerRoleName,
    };
  }

  factory TechnicianCaiemca.fromMap(Map<String, dynamic> map) {
    return TechnicianCaiemca(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      identification: map['identification'] != null ? map['identification'] as String : null,
      companyId: map['companyId'] != null ? map['companyId'] as String : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      roleName: map['roleName'] != null ? map['roleName'] as String : null,
      workerAddress: map['workerAddress'] != null ? map['workerAddress'] as String : null,
      workerEmail: map['workerEmail'] != null ? map['workerEmail'] as String : null,
      workerIdentification: map['workerIdentification'] != null ? map['workerIdentification'] as String : null,
      workerName: map['workerName'] != null ? map['workerName'] as String : null,
      workerPhone: map['workerPhone'] != null ? map['workerPhone'] as String : null,
      workerRoleName: map['workerRoleName'] != null ? map['workerRoleName'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TechnicianCaiemca.fromJson(String source) => TechnicianCaiemca.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TechnicianCaiemca(id: $id, name: $name, phone: $phone, email: $email, address: $address, identification: $identification, companyId: $companyId, createdAt: $createdAt, roleName: $roleName, workerAddress: $workerAddress, workerEmail: $workerEmail, workerIdentification: $workerIdentification, workerName: $workerName, workerPhone: $workerPhone, workerRoleName: $workerRoleName)';
  }

  @override
  bool operator ==(covariant TechnicianCaiemca other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.phone == phone &&
      other.email == email &&
      other.address == address &&
      other.identification == identification &&
      other.companyId == companyId &&
      other.createdAt == createdAt &&
      other.roleName == roleName &&
      other.workerAddress == workerAddress &&
      other.workerEmail == workerEmail &&
      other.workerIdentification == workerIdentification &&
      other.workerName == workerName &&
      other.workerPhone == workerPhone &&
      other.workerRoleName == workerRoleName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      phone.hashCode ^
      email.hashCode ^
      address.hashCode ^
      identification.hashCode ^
      companyId.hashCode ^
      createdAt.hashCode ^
      roleName.hashCode ^
      workerAddress.hashCode ^
      workerEmail.hashCode ^
      workerIdentification.hashCode ^
      workerName.hashCode ^
      workerPhone.hashCode ^
      workerRoleName.hashCode;
  }
}
