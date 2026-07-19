// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


class Company {
  String? id;
  String? rncOrId;
  String? name;
  String? address;
  String? phone1;
  String? phone2;
  String? email;
  String? logo;
  String? stamp;
  DateTime? createdAt;
  Company({
    this.id,
    this.rncOrId,
    this.name,
    this.address,
    this.phone1,
    this.phone2,
    this.email,
    this.logo,
    this.stamp,
    this.createdAt,
  });

  Company copyWith({
    String? id,
    String? rncOrId,
    String? name,
    String? address,
    String? phone1,
    String? phone2,
    String? email,
    String? logo,
    String? stamp,
    DateTime? createdAt,
  }) {
    return Company(
      id: id ?? this.id,
      rncOrId: rncOrId ?? this.rncOrId,
      name: name ?? this.name,
      address: address ?? this.address,
      phone1: phone1 ?? this.phone1,
      phone2: phone2 ?? this.phone2,
      email: email ?? this.email,
      logo: logo ?? this.logo,
      stamp: stamp ?? this.stamp,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'rncOrId': rncOrId,
      'name': name,
      'address': address,
      'phone1': phone1,
      'phone2': phone2,
      'email': email,
      'logo': logo,
      'stamp': stamp,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      id: map['id'] != null ? map['id'] as String : null,
      rncOrId: map['rncOrId'] != null ? map['rncOrId'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      phone1: map['phone1'] != null ? map['phone1'] as String : null,
      phone2: map['phone2'] != null ? map['phone2'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      logo: map['logo'] != null ? map['logo'] as String : null,
      stamp: map['stamp'] != null ? map['stamp'] as String : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']).toLocal() : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Company.fromJson(String source) => Company.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Company(id: $id, rncOrId: $rncOrId, name: $name, address: $address, phone1: $phone1, phone2: $phone2, email: $email, logo: $logo, stamp: $stamp, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant Company other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.rncOrId == rncOrId &&
      other.name == name &&
      other.address == address &&
      other.phone1 == phone1 &&
      other.phone2 == phone2 &&
      other.email == email &&
      other.logo == logo &&
      other.stamp == stamp &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      rncOrId.hashCode ^
      name.hashCode ^
      address.hashCode ^
      phone1.hashCode ^
      phone2.hashCode ^
      email.hashCode ^
      logo.hashCode ^
      stamp.hashCode ^
      createdAt.hashCode;
  }
}
