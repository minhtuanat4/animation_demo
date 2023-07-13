import 'package:animation_demo/animated_list/animated_list_page.dart';
import 'package:animation_demo/custom_progress_indicator/custom_progress_indicator.dart';
import 'package:animation_demo/flame_game/flip_flop_game/provider/pikachu_pr.dart';
import 'package:animation_demo/flutter_test/home_test_page.dart';
import 'package:animation_demo/go_router_page/account_info/account_detail_page.dart';
import 'package:animation_demo/go_router_page/account_info/account_info_page.dart';
import 'package:animation_demo/go_router_page/account_info/account_update_page.dart';
import 'package:animation_demo/go_router_page/secure_setups/secure_setups_page.dart';
import 'package:animation_demo/render_object_page/render_object_page.dart';
import 'package:animation_demo/tool_tip/tool_tip_demo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'carousel_slider_page/carousel_slider_page.dart';
import 'common/user_management.dart';
import 'cupertino_slide_segments_control/cupertino_slide_segments_control.dart';
import 'custom_package/home_packages.dart';
import 'draw_verticle/draw_verticle_page.dart';
import 'flame_game/flip_flop_game/intro_flip_flop_game.dart';
import 'flame_game/my_game.dart';
import 'flame_game/pikachu_flame_game/intro_pikachu_flame_game.dart';
import 'flame_game/pikachu_flame_game/provider/pikachu_pr.dart';
import 'flutter_slidable_page/flutter_slidable_page.dart';
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
  static const String homeTestPage = 'home-test';
  static const String flutterSlidale = 'flutter-slidable';
  static const String drawVerticePage = 'draw-vertice-page';
  static const String myGame = 'my_game';
  static const String customProgressIndicator = 'custom_progress_indicator';
  static const String flipFlopGame = 'flip-flop-game';
  static const String pikachuFlameGame = 'pikachu-flame-game';
  static const String animatedListPage = 'animated-list-page';
  static const String renderObjectPage = 'render-object-page';
  static const String cupertinoSlideSegmentsControl =
      'cupertino-slide-segments-control';
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
        GoRoute(
          path: RouteName.homeTestPage,
          name: RouteName.homeTestPage,
          builder: (context, state) {
            return const HomeTestPage();
          },
        ),
        GoRoute(
          path: RouteName.flutterSlidale,
          name: RouteName.flutterSlidale,
          builder: (context, state) {
            return const FlutterSlidablePage();
          },
        ),
        GoRoute(
          path: RouteName.drawVerticePage,
          name: RouteName.drawVerticePage,
          builder: (context, state) {
            return const DrawVerticePage();
          },
        ),
        GoRoute(
          path: RouteName.myGame,
          name: RouteName.myGame,
          builder: (context, state) {
            return const MyGame();
          },
        ),
        GoRoute(
          path: RouteName.customProgressIndicator,
          name: RouteName.customProgressIndicator,
          builder: (context, state) {
            return const CustomProgressIndicator();
          },
        ),
        GoRoute(
          path: RouteName.flipFlopGame,
          name: RouteName.flipFlopGame,
          builder: (context, state) {
            return MultiProvider(providers: [
              ChangeNotifierProvider(create: (context) => FlipFlopPR()),
            ], child: const FlipFlopGamePage());
          },
        ),
        GoRoute(
          path: RouteName.animatedListPage,
          name: RouteName.animatedListPage,
          builder: (context, state) {
            return const AnimatedListPage();
          },
        ),
        GoRoute(
          path: RouteName.pikachuFlameGame,
          name: RouteName.pikachuFlameGame,
          builder: (context, state) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (context) => PikachuPR()),
              ],
              builder: (context, child) {
                return const PikachuMap();
              },
            );
          },
        ),
        GoRoute(
          path: RouteName.renderObjectPage,
          name: RouteName.renderObjectPage,
          builder: (context, state) {
            return const RenderObjectPage();
          },
        ),
        GoRoute(
          path: RouteName.cupertinoSlideSegmentsControl,
          name: RouteName.cupertinoSlideSegmentsControl,
          builder: (context, state) {
            return const CupertinoSlideSegmentsControl();
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
