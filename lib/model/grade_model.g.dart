// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GradeModel _$GradeModelFromJson(Map<String, dynamic> json) => GradeModel(
      (json['students'] as List<dynamic>?)
          ?.map((e) =>
              e == null ? null : Person.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['nameGrade'] as String,
      json['idGrade'] as String,
    );

Map<String, dynamic> _$GradeModelToJson(GradeModel instance) =>
    <String, dynamic>{
      'students': instance.students,
      'nameGrade': instance.nameGrade,
      'idGrade': instance.idGrade,
    };
