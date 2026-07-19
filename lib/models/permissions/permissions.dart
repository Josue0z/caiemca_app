// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:caiemca_app/apis/api.caiemca.dart';
import 'package:caiemca_app/models/users/user.dart';
import 'package:dio/dio.dart';


class PermissionCaiemca {
  int? id;
  String? name;
  String? description;
  DateTime? createdAt;
  PermissionCaiemca({
    this.id,
    this.name,
    this.description,
    this.createdAt,
  });
  static Future<List<PermissionCaiemca>> get() async {
    try {
      await auth();
      var res = await apiCaiemca.get('/permissions/all');

      if (res.statusCode == 200) {
        var data = res.data;
        return List.from(
          (data as List<dynamic>).map((e) => PermissionCaiemca.fromMap(e)).toList(),
        );
      }
      return [];
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? e.error.toString();
    }
  }
  PermissionCaiemca copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? createdAt,
  }) {
    return PermissionCaiemca(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory PermissionCaiemca.fromMap(Map<String, dynamic> map) {
    return PermissionCaiemca(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PermissionCaiemca.fromJson(String source) => PermissionCaiemca.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PermissionCaiemca(id: $id, name: $name, description: $description, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant PermissionCaiemca other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      createdAt.hashCode;
  }
}
