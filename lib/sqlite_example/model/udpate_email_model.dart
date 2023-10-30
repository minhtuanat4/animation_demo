// // To parse this JSON data, do
// //
// //     final updateEmailRequest = updateEmailRequestFromJson(jsonString);

// import 'dart:convert';

// import 'package:animation_demo/sqlite_example/sqlite_hepler.dart';
// import 'package:equatable/equatable.dart';

// UpdateEmailRequest updateEmailRequestFromJson(String str) =>
//     UpdateEmailRequest.fromJson(json.decode(str));

// String updateEmailRequestToJson(UpdateEmailRequest data) =>
//     json.encode(data.toJson());

// class UpdateEmailRequest extends Equatable {
//   UpdateEmailRequest({
//     this.email,
//     this.secureCode,
//     this.secureTypeId,
//     this.columnId,
//   });

//   String? email;
//   String? secureCode;
//   int? secureTypeId;
//   int? columnId;

//   factory UpdateEmailRequest.fromJson(Map<String, dynamic> json) =>
//       UpdateEmailRequest(
//         email: json[emailRaw],
//         secureCode: json[secureCodeRaw],
//         secureTypeId: json[secureTypeIdRaw],
//         columnId: json[columnIdRaw],
//       );

//   Map<String, dynamic> toJson() => {
//         emailRaw: email,
//         secureCodeRaw: secureCode,
//         secureTypeIdRaw: secureTypeId,
//         columnIdRaw: columnId,
//       };

//   @override
//   // TODO: implement props
//   List<Object?> get props => [email, secureCode, secureTypeId, columnId];
// }
