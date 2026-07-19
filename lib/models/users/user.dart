// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:caiemca_app/apis/api.caiemca.dart';
import 'package:caiemca_app/pages/auth/login_page.dart';
import 'package:caiemca_app/settings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:caiemca_app/models/abstracts.dart';
import 'package:caiemca_app/models/companies/company.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

const String kSecretId =
    'bFBPidaerRmZlD2wg4cnkZI6jaJfdKXfnvqiI65t8lMEmrdFkpHNVdYoARbJ1mwfgqJi+VxpZBdyX60adDrJLOWNX92glFL1PITmK8chKD6AN4sppDdUMdV3';

const String kClientId =
    'C/LwyMWHPRyi/5MqsNLlsBmsluISrrN7SSla9u6OJ0/iwvfq6hMwqFcsRlmVRP9SgVcZIZZrSp/SfeX4taz8RhRMFk6aj0xe49J/FJhVzitdN5mqbf+2chXj';
Future<dynamic> requestAuth() async {
  try {
    final res = await apiCaiemca.post(
      '/auth/oauth2',
      options: Options(
        headers: {'client-id': kClientId, 'secret-id': kSecretId},
      ),
    );
    return res; // devuelve el Response completo
  } on DioException catch (e) {
    throw e.response?.data['message'] ?? e.error.toString();
  }
}

Future<void> auth() async {
  try {
    var now = DateTime.now().toUtc();
    DateTime? expiredAt;
    String? token;

    dynamic res;
    var infoAuth = localStorage.getItem('authData');

 
    if (infoAuth != null) {
      final json = jsonDecode(infoAuth);
      token = json['token'];
      expiredAt = DateTime.parse(json['expiredAt']);

  

      if (now.isAfter(expiredAt)) {
        res = await requestAuth();
      }else{
        print('no ha vencido el token');
      }
    } else {
      res = await requestAuth();
    }

    if (res != null && res.statusCode == 200) {
      final data = res.data;
      token = data['token'];
      localStorage.setItem('authData', jsonEncode(data));
    }

    if (token != null && token.isNotEmpty) {
      apiCaiemca.options.headers['Authorization'] = 'Bearer $token';
    }
  } on DioException catch (e) {
    throw e.response?.data['message'] ?? e.error.toString();
  }
}

class UserCaiemca implements CaiemcaItem<String> {
  @override
  String? id;
  String? username;
  String? password;
  @override
  String? name;
  @override
  String? identification;
  String? phone;
  String? email;
  String? address;
  int? roleId;
  List<String>? permissions;
  String? companyId;
  String? companyRnc;
  String? companyPhone1;
  String? companyPhone2;
  String? companyEmail;
  String? companyAddress;
  String? companyLogo;
  String? companyStamp;
  int? roleRef;
  @override
  String? roleName;
  Company? company;
  DateTime? createdAt;
  UserCaiemca({
    this.id,
    this.username,
    this.password,
    this.name,
    this.identification,
    this.phone,
    this.email,
    this.address,
    this.roleId,
    this.permissions,
    this.companyId,
    this.companyRnc,
    this.companyPhone1,
    this.companyPhone2,
    this.companyEmail,
    this.companyAddress,
    this.companyLogo,
    this.companyStamp,
    this.roleRef,
    this.roleName,
    this.company,
    this.createdAt,
  });


  bool get isSuperUser {
    return roleId == 1;
  }

  bool get isAdmin {
    return roleId == 2;
  }

  bool get isWorker {
    return isSuperUser == false && isAdmin == false;
  }


  static Future<List<UserCaiemca>> get() async {
    try {
      await auth();
      var res = await apiCaiemca.get('/users/all');

      if (res.statusCode == 200) {
        var data = res.data;
        return List.from(
          (data as List<dynamic>).map((e) => UserCaiemca.fromMap(e)).toList(),
        );
      }
      return [];
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }

  static Future<UserCaiemca?> login({
    required String username,
    required String password,
  }) async {
    try {
      await auth();
      var res = await apiCaiemca.post(
        '/auth/sign-in',
        data: {'username': username, 'password': password},
      );

      if (res.statusCode == 200) {
        return UserCaiemca.fromMap(res.data['user']);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }
  
      Future<UserCaiemca?> create()async{
    try{
      await auth();
      var map = toMap();
      map.remove('id');
      map.remove('companyId');
      map.remove('createdAt');
      map.remove('companyRnc');
      map.remove('companyPhone1');
      map.remove('companyPhone2');
      map.remove('companyEmail');
      map.remove('companyAddress');
      map.remove('companyLogo');
      map.remove('companyStamp');
      map.remove('roleRef');
      map.remove('roleName');
      map.remove('company');
      var res = await apiCaiemca.post('/users/create',data: map);
      if(res.statusCode == 200){
        return UserCaiemca.fromMap(res.data);
      }
      return null;
    }on DioException catch(e){
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }

    Future<UserCaiemca?> update()async{
    try{
      await auth();
      var map = toMap();
      map.remove('id');
      map.remove('companyId');
      map.remove('createdAt');
      map.remove('companyRnc');
      map.remove('companyPhone1');
      map.remove('companyPhone2');
      map.remove('companyEmail');
      map.remove('companyAddress');
      map.remove('companyLogo');
      map.remove('companyStamp');
      map.remove('roleRef');
      map.remove('roleName');
      map.remove('company');
      var res = await apiCaiemca.put('/users/update/$id',data: map);
      if(res.statusCode == 200){
        return UserCaiemca.fromMap(res.data);
      }
      return null;
    }on DioException catch(e){
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }
  static Future<void> loggout({required BuildContext context}) async {
    currentUser = null;
    await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (ctx) => LoginPage()),
      (_) => false,
    );
  }


  UserCaiemca copyWith({
    String? id,
    String? username,
    String? password,
    String? name,
    String? identification,
    String? phone,
    String? email,
    String? address,
    int? roleId,
    List<String>? permissions,
    String? companyId,
    String? companyRnc,
    String? companyPhone1,
    String? companyPhone2,
    String? companyEmail,
    String? companyAddress,
    String? companyLogo,
    String? companyStamp,
    int? roleRef,
    String? roleName,
    Company? company,
    DateTime? createdAt,
  }) {
    return UserCaiemca(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      name: name ?? this.name,
      identification: identification ?? this.identification,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      roleId: roleId ?? this.roleId,
      permissions: permissions ?? this.permissions,
      companyId: companyId ?? this.companyId,
      companyRnc: companyRnc ?? this.companyRnc,
      companyPhone1: companyPhone1 ?? this.companyPhone1,
      companyPhone2: companyPhone2 ?? this.companyPhone2,
      companyEmail: companyEmail ?? this.companyEmail,
      companyAddress: companyAddress ?? this.companyAddress,
      companyLogo: companyLogo ?? this.companyLogo,
      companyStamp: companyStamp ?? this.companyStamp,
      roleRef: roleRef ?? this.roleRef,
      roleName: roleName ?? this.roleName,
      company: company ?? this.company,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'password': password,
      'name': name,
      'identification': identification,
      'phone': phone,
      'email': email,
      'address': address,
      'roleId': roleId,
      'permissions': permissions,
      'companyId': companyId,
      'companyRnc': companyRnc,
      'companyPhone1': companyPhone1,
      'companyPhone2': companyPhone2,
      'companyEmail': companyEmail,
      'companyAddress': companyAddress,
      'companyLogo': companyLogo,
      'companyStamp': companyStamp,
      'roleRef': roleRef,
      'roleName': roleName,
      'company': company?.toMap(),
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory UserCaiemca.fromMap(Map<String, dynamic> map) {
    return UserCaiemca(
      id: map['id'] != null ? map['id'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      identification: map['identification'] != null
          ? map['identification'] as String
          : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      roleId: map['roleId'] != null ? map['roleId'] as int : null,
      permissions: map['permissions'] != null
          ? List<String>.from(
              ((map['permissions'] as List).map((e) => e).toList()),
            )
          : null,
      companyId: map['companyId'] != null ? map['companyId'] as String : null,
      companyRnc: map['companyRnc'] != null
          ? map['companyRnc'] as String
          : null,
      companyPhone1: map['companyPhone1'] != null
          ? map['companyPhone1'] as String
          : null,
      companyPhone2: map['companyPhone2'] != null
          ? map['companyPhone2'] as String
          : null,
      companyEmail: map['companyEmail'] != null
          ? map['companyEmail'] as String
          : null,
      companyAddress: map['companyAddress'] != null
          ? map['companyAddress'] as String
          : null,
      companyLogo: map['companyLogo'] != null
          ? map['companyLogo'] as String
          : null,
      companyStamp: map['companyStamp'] != null
          ? map['companyStamp'] as String
          : null,
      roleRef: map['roleRef'] != null ? map['roleRef'] as int : null,
      roleName: map['roleName'] != null ? map['roleName'] as String : null,
      company: map['company'] != null ? Company.fromMap(map['company']) : null,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserCaiemca.fromJson(String source) =>
      UserCaiemca.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserCaiemca(id: $id, username: $username, password: $password, name: $name, identification: $identification, phone: $phone, email: $email, address: $address, roleId: $roleId, permissions: $permissions, companyId: $companyId, companyRnc: $companyRnc, companyPhone1: $companyPhone1, companyPhone2: $companyPhone2, companyEmail: $companyEmail, companyAddress: $companyAddress, companyLogo: $companyLogo, companyStamp: $companyStamp, roleRef: $roleRef, roleName: $roleName, company: $company, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant UserCaiemca other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.username == username &&
        other.password == password &&
        other.name == name &&
        other.identification == identification &&
        other.phone == phone &&
        other.email == email &&
        other.address == address &&
        other.roleId == roleId &&
        listEquals(other.permissions, permissions) &&
        other.companyId == companyId &&
        other.companyRnc == companyRnc &&
        other.companyPhone1 == companyPhone1 &&
        other.companyPhone2 == companyPhone2 &&
        other.companyEmail == companyEmail &&
        other.companyAddress == companyAddress &&
        other.companyLogo == companyLogo &&
        other.companyStamp == companyStamp &&
        other.roleRef == roleRef &&
        other.roleName == roleName &&
        other.company == company &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        password.hashCode ^
        name.hashCode ^
        identification.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        address.hashCode ^
        roleId.hashCode ^
        permissions.hashCode ^
        companyId.hashCode ^
        companyRnc.hashCode ^
        companyPhone1.hashCode ^
        companyPhone2.hashCode ^
        companyEmail.hashCode ^
        companyAddress.hashCode ^
        companyLogo.hashCode ^
        companyStamp.hashCode ^
        roleRef.hashCode ^
        roleName.hashCode ^
        company.hashCode ^
        createdAt.hashCode;
  }

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
