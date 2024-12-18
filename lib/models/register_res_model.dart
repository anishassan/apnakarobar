
import 'dart:convert';

RegisterResModel registerResModelFromJson(String str) => RegisterResModel.fromJson(json.decode(str));

String registerResModelToJson(RegisterResModel data) => json.encode(data.toJson());

class RegisterResModel {
    The0? the0;
    bool? success;

    RegisterResModel({
        this.the0,
        this.success,
    });

    factory RegisterResModel.fromJson(Map<String, dynamic> json) => RegisterResModel(
        the0: json["0"] == null ? null : The0.fromJson(json["0"]),
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "0": the0?.toJson(),
        "success": success,
    };
}

class The0 {
    String? title;
    String? slug;
    String? email;
    String? contact;
    String? address;
    DateTime? updatedAt;
    DateTime? createdAt;
    int? id;

    The0({
        this.title,
        this.slug,
        this.email,
        this.contact,
        this.address,
        this.updatedAt,
        this.createdAt,
        this.id,
    });

    factory The0.fromJson(Map<String, dynamic> json) => The0(
        title: json["title"],
        slug: json["slug"],
        email: json["email"],
        contact: json["contact"],
        address: json["address"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "slug": slug,
        "email": email,
        "contact": contact,
        "address": address,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
    };
}
