// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:caiemca_app/apis/api.caiemca.dart';
import 'package:caiemca_app/models/users/user.dart';
import 'package:dio/dio.dart';


class Role {
  int? id;
  String? name;
  DateTime? createdAt;
  Role({
    this.id,
    this.name,
    this.createdAt,
  });
  static Future<List<Role>> get() async {
    try {
      await auth();
      var res = await apiCaiemca.get('/roles/all');

      if (res.statusCode == 200) {
        var data = res.data;
        return List.from(
          (data as List<dynamic>).map((e) => Role.fromMap(e)).toList(),
        );
      }
      return [];
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }
  Role copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
  }) {
    return Role(
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

  factory Role.fromMap(Map<String, dynamic> map) {
    return Role(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Role.fromJson(String source) => Role.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Role(id: $id, name: $name, createdAt: $createdAt)';

  @override
  bool operator ==(covariant Role other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ createdAt.hashCode;
}
