import 'package:animation_demo/go_router_page/account_info/account_detail_page.dart';
import 'package:animation_demo/go_router_page/account_info/account_info_page.dart';
import 'package:animation_demo/go_router_page/account_info/account_update_page.dart';
import 'package:animation_demo/go_router_page/secure_setups/secure_setups_page.dart';
import 'package:animation_demo/tool_tip/tool_tip_demo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'carousel_slider_page/carousel_slider_page.dart';
import 'common/user_management.dart';
import 'custom_package/home_packages.dart';
import 'go_router_page/go_router_page.dart';
import 'lifecycle_state/lifecycle_state_page.dart';
import 'main.dart';
import 'navigation_bar/navigation_bar_page.dart';
import 'page_view/page_view.dart';
import 'roll_paper_roll.dart/main_holiday.dart';
import 'validation_textfield/validation_textfield_page.dart';

class RouteName {
  static const String carouselSliderPage = 'carousel-slider';
  static const String navigationBarPage = 'navigation-bar';
}

final GoRouter router = GoRouter(
  navigatorKey: UserManagement().navigatorKey,
  initialLocation: "/",
  errorBuilder: (context, state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error Page')),
      body: Center(
          child: GestureDetector(
              onTap: () {
                context.pop();
              },
              child: const Text('Go Back'))),
    );
  },
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) =>
          const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: [
        GoRoute(
          path: "animation-page",
          name: "animation-page",
          builder: (context, state) => const MyPageView(),
        ),
        GoRoute(
          path: "holiday-game",
          name: "holiday-game",
          builder: (context, state) => const GameHolidays(),
        ),
        GoRoute(
            path: "lifecycle-state/:id/:name",
            name: "lifecycle-state",
            builder: (context, state) {
              final id = state.params["id"] ?? '0';
              final name = state.params["name"] ?? '';
              return LifecyleStatePage(
                id: id,
                name: name,
              );
            }),
        GoRoute(
          path: "custom-package",
          name: "custom-package",
          builder: (context, state) => const HomePackages(),
        ),
        GoRoute(
          path: "demo-tooltip",
          name: "demo-tooltip",
          builder: (context, state) => const TooltipDemo(),
        ),
        GoRoute(
            path: "validated-textfield",
            name: "validated-textfield",
            builder: (context, state) {
              final argument = state.extra as ArgumentObject;
              return ValidationTextFieldPage(
                argumentObject: argument,
              );
            }),
        GoRoute(
            path: "go-router",
            name: "go-router",
            builder: (context, state) => const GoRouterPage(),
            routes: subGoRouter),
        GoRoute(
          path: "carousel-slider",
          name: RouteName.carouselSliderPage,
          builder: (context, state) {
            final argumentExtra = state.extra as Map<String, String>;
            return CarouselSliderPage(
              argument: argumentExtra,
            );
          },
        ),
        GoRoute(
          path: "navigation-bar",
          name: RouteName.navigationBarPage,
          builder: (context, state) {
            return const NavigationBarPage();
          },
        ),
      ],
    ),
  ],
);
final subGoRouter = [
  GoRoute(
      path: "account-info",
      name: "account-info",
      builder: (context, state) => const AccountInfoPage(),
      routes: [
        GoRoute(
          path: "account-detail",
          name: "account-detail",
          builder: (context, state) => const AccountDetailPage(),
          routes: [
            GoRoute(
              path: "account-update",
              name: "account-update",
              builder: (context, state) => const AccountUpdatePage(),
            ),
          ],
        ),
        GoRoute(
          name: "secure-setups",
          path: "secure-setups",
          builder: (context, state) => const SecureSetupsPage(),
        ),
      ]),
];
