import 'dart:convert';

import 'package:animation_demo/common/user_management.dart';

class ServiceFirebase {
  Future<List<UserModel>> getUser() async {
    final result = await UserManagement().databaseRef.child('users/').get();
    var encodedString = jsonEncode(result.value);

    Map<String, dynamic> valueMap = json.decode(encodedString);
    final currentUid = UserManagement().userInfo?.user?.uid ?? '';
    final lstUser = <UserModel>[];
    if (currentUid.isNotEmpty) {
      valueMap.forEach((key, value) {
        if (!currentUid.contains(key)) {
          lstUser.add(UserModel.fromJson(value));
        }
      });
    }

    return lstUser;
  }

  Future<UserModel> getCurrentUser() async {
    final currentUid = UserManagement().userInfo?.user?.uid ?? '';
    final result =
        await UserManagement().databaseRef.child('users/$currentUid/').get();
    var encodedString = jsonEncode(result.value);

    Map<String, dynamic> valueMap = json.decode(encodedString);

    return UserModel.fromJson(valueMap);
  }
}

class UserModel {
  String? id;
  String? name;
  String? image;

  UserModel({this.id, this.name, this.image});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}
