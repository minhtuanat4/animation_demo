// To parse this JSON data, do
//
//     final telCoPrepaidModel = telCoPrepaidModelFromJson(jsonString);

import 'dart:convert';

import 'telco_products_category_model.dart';

TelCoModel telCoPrepaidModelFromJson(String str) =>
    TelCoModel.fromJson(json.decode(str));

class TelCoModel extends TelcoProductCateModel {
  TelCoModel({
    List<ListTelco>? listTelco,
    List<ListProduct>? listProducts,
    List<ProductCategory>? listCategories,
    this.responseCode,
    this.description,
    this.extend,
    this.choosenProduct,
  }) : super(
          listProducts: listProducts,
          listCategories: listCategories,
          listTelco: listTelco,
        );

  int? responseCode;
  String? description;
  String? extend;
  ListProduct? choosenProduct;

  factory TelCoModel.fromJson(Map<String, dynamic> json) => TelCoModel(
        listTelco: json['ListTelco'] == null
            ? null
            : List<ListTelco>.from(
                json['ListTelco'].map((x) => ListTelco.fromJson(x))),
        listProducts: json['ListProducts'] == null
            ? null
            : List<ListProduct>.from(
                json['ListProducts'].map((x) => ListProduct.fromJson(x))),
        listCategories: json['ListCategories'] == null
            ? null
            : List<ProductCategory>.from(
                json['ListCategories'].map((x) => ProductCategory.fromJson(x))),
        responseCode: json['ResponseCode'],
        description: json['Description'],
        extend: json['Extend'],
      );
}
