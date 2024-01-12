import 'dart:convert';

TelcoProductCateModel listCategoryModelFromJson(String str) =>
    TelcoProductCateModel.fromJson(json.decode(str));

class TelcoProductCateModel {
  TelcoProductCateModel({
    this.listTelco,
    this.listProducts,
    this.listCategories,
    this.cateParent,
  });

  List<ListTelco>? listTelco;
  List<ListProduct>? listProducts;
  List<ProductCategory>? listCategories;
  ProductCategory? cateParent;

  factory TelcoProductCateModel.fromJson(Map<String, dynamic> json) =>
      TelcoProductCateModel(
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
        cateParent: ProductCategory.fromJson(json['CateParent']),
      );
}

class ProductCategory {
  ProductCategory({
    this.categoryId,
    this.categoryCode,
    this.categoryName,
    this.parentCategoryId,
    this.parentCategoryCode,
    this.categoryType,
    this.providerId,
    this.display,
    this.displayOrder,
    this.status,
    this.isHot,
    this.isNew,
    this.isSale,
    this.refValue,
    this.logo,
    this.description,
    this.detail,
    this.link,
    this.serviceType,
    this.reportType,
    this.discountRate,
    this.maxDiscountRate,
    this.minDiscountRate,
    this.bannerTop,
    this.linkFacebook,
    this.linkAppIos,
    this.linkAppAndroid,
    this.releaseForm,
    this.guidImg,
    this.listProducts,
    this.noInvoice,
  });

  int? categoryId;
  String? categoryCode;
  String? categoryName;
  int? parentCategoryId;
  String? parentCategoryCode;
  int? categoryType;
  int? providerId;
  int? display;
  int? displayOrder;
  int? status;
  int? isHot;
  int? isNew;
  int? isSale;
  String? refValue;
  String? logo;
  String? description;
  String? detail;
  String? link;
  int? serviceType;
  int? reportType;
  double? discountRate;
  double? maxDiscountRate;
  double? minDiscountRate;
  String? bannerTop;
  String? linkFacebook;
  String? linkAppIos;
  String? linkAppAndroid;
  int? releaseForm;
  String? guidImg;
  List<ListProduct>? listProducts;
  bool? noInvoice;

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      ProductCategory(
        categoryId: json['CategoryID'],
        categoryCode: json['CategoryCode'],
        categoryName: json['CategoryName'],
        parentCategoryId: json['ParentCategoryID'],
        parentCategoryCode: json['ParentCategoryCode'],
        categoryType: json['CategoryType'],
        providerId: json['ProviderID'],
        display: json['Display'],
        displayOrder: json['DisplayOrder'],
        status: json['Status'],
        isHot: json['IsHot'],
        isNew: json['IsNew'],
        isSale: json['IsSale'],
        refValue: json['RefValue'],
        logo: json['Logo'],
        description: json['Description'],
        detail: json['Detail'],
        link: json['Link'],
        serviceType: json['ServiceType'],
        reportType: json['ReportType'],
        discountRate: json['DiscountRate'] == null
            ? null
            : (json['DiscountRate'] as num).toDouble(),
        maxDiscountRate: json['MaxDiscountRate'] == null
            ? null
            : (json['MaxDiscountRate'] as num).toDouble(),
        minDiscountRate: json['MinDiscountRate'] == null
            ? null
            : (json['MinDiscountRate'] as num).toDouble(),
        bannerTop: json['BannerTop'],
        linkFacebook: json['LinkFacebook'],
        linkAppIos: json['LinkAppIOS'],
        linkAppAndroid: json['LinkAppAndroid'],
        releaseForm: json['ReleaseForm'],
        guidImg: json['GuidImg'],
        listProducts: json['ListProducts'] == null
            ? null
            : List<ListProduct>.from(
                json['ListProducts'].map((x) => ListProduct.fromJson(x))),
        noInvoice: json['NoInvoice'],
      );
}

class ListProduct {
  ListProduct({
    this.productId,
    this.categoryId,
    this.productCode,
    this.productName,
    this.value,
    this.partnerValue,
    this.partnerCurency,
    this.enableCustomer,
    this.disabled,
    this.hasItems,
    this.warningQuantity,
    this.description,
    this.display,
    this.price,
    this.discountRate,
    this.enableKyc,
    this.productImage,
    this.salesPrice,
    this.productDiscount,
    this.detail,
    this.image,
    this.isCurrentColor = false,
  });

  int? productId;
  int? categoryId;
  String? productCode;
  String? productName;
  int? value;
  int? partnerValue;
  String? partnerCurency;
  String? enableCustomer;
  bool? disabled;
  bool? hasItems;
  int? warningQuantity;
  String? description;
  int? display;
  int? price;
  double? discountRate;
  String? enableKyc;
  String? productImage;
  int? salesPrice;
  dynamic productDiscount;
  String? detail;
  String? image;
  bool isCurrentColor;

  factory ListProduct.fromJson(Map<String, dynamic> json) => ListProduct(
        productId: json['ProductID'],
        categoryId: json['CategoryID'],
        productCode: json['ProductCode'],
        productName: json['ProductName'],
        value: json['Value'],
        partnerValue: json['PartnerValue'],
        partnerCurency: json['PartnerCurency'],
        enableCustomer: json['EnableCustomer'],
        disabled: json['Disabled'],
        hasItems: json['HasItems'],
        warningQuantity: json['WarningQuantity'],
        description: json['Description'],
        display: json['Display'],
        price: json['Price'],
        discountRate: json['DiscountRate'] == null
            ? null
            : (json['DiscountRate'] as num).toDouble(),
        enableKyc: json['EnableKYC'],
        productImage: json['ProductImage'],
        salesPrice: json['SalesPrice'],
        productDiscount: json['ProductDiscount'],
        detail: json['Detail'],
        image: json['Image'],
      );
}

class ListTelco {
  ListTelco({
    this.code,
    this.name,
    this.prefix,
  });

  String? code;
  String? name;
  String? prefix;

  factory ListTelco.fromJson(Map<String, dynamic> json) => ListTelco(
        code: json['Code'],
        name: json['Name'],
        prefix: json['Prefix'],
      );
}
