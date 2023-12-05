import 'package:flutter/material.dart';
import 'sqlite_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class bmi_lab{

  static const String _tblName = "bmi";

  String username;
  double height;
  double weight;
  String gender;
  String status;

  bmi_lab(this.username, this.height, this.weight, this.gender, this.status);

  bmi_lab.fromJson(Map<String, dynamic> json)
      : username = json['username'] as String,
        height = json['height'] as double,
        weight = json['weight'] as double,
        gender = json['gender'] as String,
        status = json['status'] as String;

  Map<String, dynamic> toJson() => {'username': username, 'height': height, 'weight': weight, 'gender': gender, 'status': status};

  Future<bool> save() async {
    return await BmiDB().insert(_tblName, toJson()) != 0;
  }

  static Future<List<bmi_lab>> loadAll() async {
    List<bmi_lab> result = [];

    List<Map<String, dynamic>> localResult = await BmiDB().queryAll(_tblName);
    for (var item in localResult) {
      result.add(bmi_lab.fromJson(item));
    }

    return result;
   }
}