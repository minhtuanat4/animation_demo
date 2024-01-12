import 'package:flutter/material.dart';

enum TabMenuItem {
  HOME(
    title: 'Trang chủ',
    imageIcon: 'assets/images/bottom_tabbar/home.png',
    imageNameIsActivated: 'home',
    iconData: Icons.home_outlined,
  ),
  MGG(
    title: 'Ưu đãi',
    imageIcon: 'assets/images/bottom_tabbar/voucher.png',
    imageNameIsActivated: 'voucher',
  ),
  SCANQR(
    title: '',
    imageIcon: 'assets/images/bottom_tabbar/mess.png',
    imageNameIsActivated: 'mess',
  ),
  HISTORY(
    title: 'Lịch sử',
    imageIcon: 'assets/images/bottom_tabbar/time.png',
    imageNameIsActivated: 'time',
  ),

  USER(
    title: 'Tài khoản',
    imageIcon: 'assets/images/bottom_tabbar/user.png',
    imageNameIsActivated: 'user',
  );

  final String title;
  final dynamic imageIcon;
  final String imageNameIsActivated;
  final IconData? iconData;
  const TabMenuItem({
    required this.title,
    required this.imageIcon,
    required this.imageNameIsActivated,
    this.iconData,
  });
}
