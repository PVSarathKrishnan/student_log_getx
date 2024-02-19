import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'student_model.g.dart';

@HiveType(typeId:1)
class StudentModel extends HiveObject{

  @HiveField(0)
  int? id; 

  @HiveField(1)
  String photo;

  @HiveField(2)
  String name;

  @HiveField(3)
  String gender;

  @HiveField(4)
  String domain;

  @HiveField(5)
  String dob;

  @HiveField(6)
  String mobile;

  @HiveField(7)
  String email;

  StudentModel({
    this.id,
    required this.photo,
    required this.name,
    required this.gender,
    required this.domain,
    required this.dob,
    required this.mobile,
    required this.email
  });
}