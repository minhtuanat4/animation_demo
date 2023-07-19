import 'package:animation_demo/model/person_model.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'grade_model.g.dart';

@JsonSerializable()
class GradeModel {
  final List<Person?>? students;
  final String nameGrade;
  final String idGrade;
  GradeModel(this.students, this.nameGrade, this.idGrade);

  factory GradeModel.fromJson(Map<String, dynamic> json) =>
      _$GradeModelFromJson(json);

  Map<String, dynamic> toJson() => _$GradeModelToJson(this);
}
