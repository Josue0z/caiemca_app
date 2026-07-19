// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:caiemca_app/apis/api.caiemca.dart';
import 'package:caiemca_app/models/abstracts.dart';
import 'package:caiemca_app/models/users/user.dart';
import 'package:dio/dio.dart';

class Failures implements CaiemcaItem<int> {
  @override
  int? id;
  @override
  String? name;
  DateTime? createdAt;
  Failures({this.id, this.name, this.createdAt});
    static Future<List<Failures>> get() async {
    try {
      await auth();
      var res = await apiCaiemca.get('/failures/all');

      if (res.statusCode == 200) {
        var data = res.data;
        return List.from(
          (data as List<dynamic>).map((e) => Failures.fromMap(e)).toList(),
        );
      }
      return [];
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }

  Failures copyWith({int? id, String? name, DateTime? createdAt}) {
    return Failures(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory Failures.fromMap(Map<String, dynamic> map) {
    return Failures(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Failures.fromJson(String source) =>
      Failures.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Failures(id: $id, name: $name, createdAt: $createdAt)';

  @override
  bool operator ==(covariant Failures other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.createdAt == createdAt;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ createdAt.hashCode;

  @override
  String? identification;

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
