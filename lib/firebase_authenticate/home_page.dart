import 'package:animation_demo/common/user_management.dart';
import 'package:animation_demo/define_go_router.dart';
import 'package:animation_demo/firebase_authenticate/bloc/bloc/auth_bloc.dart';
import 'package:animation_demo/firebase_authenticate/service_firebase.dart';
import 'package:animation_demo/resource/definition_button.dart';
import 'package:animation_demo/resource/definition_color.dart';
import 'package:animation_demo/resource/definition_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ServiceFirebase {
  List<UserModel> users = [];
  UserModel? currentUser;
  final queryStringController = TextEditingController();
  final isSearchWorking = ValueNotifier<bool>(false);

  final focusSearchNotifier = ValueNotifier<bool>(false);
  @override
  void dispose() {
    queryStringController.dispose();
    isSearchWorking.dispose();
    super.dispose();
  }

  @override
  void initState() {
    BlocProvider.of<AuthBloc>(context).add(GetUserEvent());
    BlocProvider.of<AuthBloc>(context).add(GetCurrentUserEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
        ),
        body: Padding(
          padding:
              const EdgeInsets.only(top: 0, bottom: 16, left: 16, right: 16),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is GetUserState) {
                users = state.response;
              }
              if (state is GetCurrentUserState) {
                currentUser = state.response;
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  buildSearch(),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    height: 76,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        currentUser != null
                            ? SizedBox(
                                width: 66,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: 40,
                                        child:
                                            avatar(currentUser!.image ?? '')),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      currentUser!.name ?? '',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.all(0),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (_, index) {
                              return SizedBox(
                                width: 66,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(width: 40, child: avatar('')),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      users[index].name ?? '',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (_, __) {
                              return SizedBox(
                                width: 8,
                              );
                            },
                            itemCount: users.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (_, index) {
                        return ListTile(
                          onTap: () {},
                          contentPadding: EdgeInsets.all(0),
                          leading: SizedBox(
                            width: 64,
                            child: CachedNetworkImage(
                              imageUrl: users[index].image ?? '',
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 2,
                                      offset: Offset(0, 0),
                                    ),
                                  ],
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => const Image(
                                image: AssetImage(
                                  'assets/images/bottom_tabbar/bg_scan.png',
                                ),
                              ),
                            ),
                          ),
                          title: Text(users[index].name ?? ''),
                          trailing: EposButton(
                            width: 100,
                            onOK: () async {
                              BlocProvider.of<AuthBloc>(context)
                                  .add(GetUserEvent());
                            },
                            title: 'Kết bạn',
                            textColor: colorBlackPos,
                            height: 42,
                            backgroundColor: colorYellowAccent,
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                      itemCount: users.length,
                    ),
                  ),
                  EposButton(
                    onOK: () async {
                      BlocProvider.of<AuthBloc>(context).add(GetUserEvent());
                    },
                    title: 'Get User',
                    textColor: colorBlackPos,
                    height: 42,
                    backgroundColor: colorYellowAccent,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  EposButton(
                    onOK: () async {
                      final uuid = UserManagement().userInfo?.user?.uid ?? '';
                      await FirebaseAuth.instance.signOut();
                      UserManagement().statusUser(uuid, false);
                      context.pushReplacementNamed(RouteName.loginFirebasePage);
                    },
                    title: 'Sign Out',
                    textColor: colorBlackPos,
                    height: 42,
                    backgroundColor: colorYellowAccent,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget avatar(String image) {
    return CachedNetworkImage(
      imageUrl: image,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2,
              offset: Offset(0, 0),
            ),
          ],
          shape: BoxShape.circle,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => const Image(
        image: AssetImage(
          'assets/images/bottom_tabbar/bg_scan.png',
        ),
      ),
    );
  }

  Widget buildSearch() {
    return SizedBox(
      height: 40,
      child: FocusScope(
        onFocusChange: (value) {},
        child: TextField(
          onChanged: (value) {
            if (value.trim().isEmpty) {
              isSearchWorking.value = false;
            }
          },
          controller: queryStringController,
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              if (!isSearchWorking.value) {
                isSearchWorking.value = true;
              }
            }
          },
          decoration: InputDecoration(
            hintText: 'Nhập từ khóa',
            suffixIcon: IconButton(
              onPressed: () {
                queryStringController.text = '';
                isSearchWorking.value = false;
              },
              icon: const Icon(
                Icons.close,
                color: colorPayGrey,
                size: 20,
              ),
            ),
            prefixIcon: GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: ValueListenableBuilder<bool>(
                    valueListenable: focusSearchNotifier,
                    builder: (_, focus, __) {
                      return Icon(
                        Icons.search,
                        color: focus ? colorPayBlue : colorPayGrey,
                        size: 24,
                      );
                    }),
              ),
            ),

            prefixIconConstraints:
                const BoxConstraints(maxWidth: 48, minWidth: 40),
            // prefixIcon: Icon(Icons.search),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(22)),
              borderSide: BorderSide(
                color: Colors.blue,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(22)),
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
          ),
        ),
      ),
    );
  }
}
