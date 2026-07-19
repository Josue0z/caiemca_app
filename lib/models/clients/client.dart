// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:caiemca_app/apis/api.caiemca.dart';
import 'package:caiemca_app/models/abstracts.dart';
import 'package:caiemca_app/models/users/user.dart';
import 'package:dio/dio.dart';

class Client implements CaiemcaItem<String> {
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
  Client({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.address,
    this.identification,
    this.companyId,
    this.createdAt,
  });

  static Future<List<Client>> get() async {
    try {
      await auth();
      var res = await apiCaiemca.get('/clients/all');

      if (res.statusCode == 200) {
        var data = res.data;
        return List.from(
          (data as List<dynamic>).map((e) => Client.fromMap(e)).toList(),
        );
      }
      return [];
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }

  Future<Client?> create() async {
    try {
      await auth();
      var map = toMap();
      map.remove('id');
      map.remove('companyId');
      map.remove('createdAt');
      var res = await apiCaiemca.post('/clients/create', data: map);
      if (res.statusCode == 200) {
        return Client.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }

  Future<Client?> update() async {
    try {
      await auth();
      var map = toMap();
      map.remove('id');
      map.remove('companyId');
      map.remove('createdAt');
      var res = await apiCaiemca.put('/clients/update/$id', data: map);
      if (res.statusCode == 200) {
        return Client.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }

  Client copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    String? identification,
    String? companyId,
    DateTime? createdAt,
  }) {
    return Client(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      identification: identification ?? this.identification,
      companyId: companyId ?? this.companyId,
      createdAt: createdAt ?? this.createdAt,
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
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      identification: map['identification'] != null
          ? map['identification'] as String
          : null,
      companyId: map['companyId'] != null ? map['companyId'] as String : null,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt']).toLocal()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Client.fromJson(String source) =>
      Client.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Client(id: $id, name: $name, phone: $phone, email: $email, address: $address, identification: $identification, companyId: $companyId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant Client other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.email == email &&
        other.address == address &&
        other.identification == identification &&
        other.companyId == companyId &&
        other.createdAt == createdAt;
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

  @override
  String? roleName;
}
