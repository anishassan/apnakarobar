import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:sales_management/bindings/routes.dart';
import 'package:sales_management/constant/color.dart';
import 'package:sales_management/extensions/height_width_extension.dart';
import 'package:sales_management/extensions/locale_extension.dart';
import 'package:sales_management/extensions/size_extension.dart';
import 'package:sales_management/gen/assets.gen.dart';
import 'package:sales_management/main.dart';
import 'package:sales_management/network/connectivity.dart';
import 'package:sales_management/provider/register_provider.dart';
import 'package:sales_management/repositories/storage/storage_repo.dart';
import 'package:sales_management/utils/app_text.dart';
import 'package:sales_management/utils/expanded_tile.dart';
import 'package:sales_management/utils/loading.dart';
import 'package:sales_management/utils/text_button.dart';
import 'package:sales_management/utils/text_field.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late Timer timer;
  @override
  void initState() {
    autoLogin(context: context, storage: getIt()).whenComplete(() {
      if (_isLoggedIn == false) {
        timer = Timer.periodic(const Duration(seconds: 1), (t) {
          checkInternetConnectivity();
        });
      }
    });

    // TODO: implement initState
    super.initState();
  }

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  checkLogin(bool val) {
    setState(() {
      _isLoggedIn = val;
    });
  }

  Future autoLogin(
      {required BuildContext context, required StorageRepo storage}) async {
    checkLogin(true);
    final email = await storage.getEmail();
    final uid = await storage.getUid();
    print('$email, $uid');
    if (email != '' && uid != '') {
      checkLogin(false);
      Navigator.pushReplacementNamed(context, Routes.dashboard);
    } else {
      checkLogin(false);
      checkInternetConnectivity();
    }
  }

  bool isConnected = true;

  Future<void> checkInternetConnectivity() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      print("Moble");
      setState(() {
        isConnected = true;
      });
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      print('Wifi');
      setState(() {
        isConnected = true;
      });
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      setState(() {
        isConnected = true;
      });
    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      print('VPN');
      setState(() {
        isConnected = true;
      });
    } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
      print('Bluetooth');
      setState(() {
        isConnected = true;
      });
    } else if (connectivityResult.contains(ConnectivityResult.other)) {
      print('other');
      setState(() {
        isConnected = true;
      });
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
      setState(() {
        isConnected = false;
      });
    }
  }

  @override
  void dispose() {
    timer.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.green,
      // appBar: AppBar(
      //   title: appText(
      //     context: context,
      //     title: "Register Your Business",
      //     textColor: ColorPalette.green,
      //   ),
      // ),
      body: Consumer<RegisterProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              Column(
                children: [
                  Assets.images.login.image(
                      width: context.getSize.width * 0.5,
                      height: context.getSize.height * 0.2),
                  context.heightBox(0.01),
                  appText(
                    context: context,
                    title: "Register Your Business",
                    textColor: ColorPalette.white,
                  ),
                  context.heightBox(0.01),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: const BoxDecoration(
                          color: ColorPalette.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                      child: ListView(
                        padding: const EdgeInsets.all(0),
                        children: [
                          context.heightBox(0.1),
                          textField(
                            context: context,
                            controller: provider.name,
                            hintText: 'Business Title',
                          ),
                          context.heightBox(0.01),
                          textField(
                            context: context,
                            controller: provider.email,
                            hintText: 'Email',
                          ),
                          context.heightBox(0.01),
                          phoneField(
                            onChangePhone: (val) {
                              provider.contact.text = val!.phoneNumber!;
                              print(provider.contact.text);
                            },
                            textInputType: TextInputType.number,
                            context: context,
                            controller: TextEditingController(),
                            hintText: '',
                            initialValue: PhoneNumber(isoCode: 'PK'),
                          ),
                          context.heightBox(0.01),
                          textField(
                            context: context,
                            controller: provider.address,
                            hintText: 'Address',
                          ),
                          context.heightBox(0.01),
                          catTextField(
                            onChange: (val) {
                              if (val != null) {
                                provider.changeCatAdded(true);
                              }
                            },
                            isCatAdded:
                                provider.isCatAdded == false ? false : true,
                            // readOnly: true,
                            // onTap: () {
                            //   provider.changeShowlist();
                            // },
                            context: context,
                            controller: provider.category,
                            hintText: 'Category',
                          ),
                          // if (provider.showList) context.heightBox(0.005),
                          // if (provider.showList)
                          //   expandedTile(
                          //       context: context,
                          //       dataList: provider.categories,
                          //       onTap: (val) {
                          //         print(val);

                          //         provider.category.text = val;
                          //         provider.changeShowlist();
                          //       }),
                          context.heightBox(0.03),
                          provider.loading
                              ? Center(
                                  child: SizedBox(
                                      width: context.getSize.width * 0.3,
                                      child: loading()),
                                )
                              : Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: context.getSize.width * 0.25),
                                  child: textButton(
                                    bgColor: ColorPalette.green,
                                    context: context,
                                    onTap: () {
                                      provider.register(
                                        context: context,
                                        repo: getIt(),
                                        storage: getIt(),
                                      );
                                    },
                                    title: 'Register',
                                    radius: 4,
                                  ),
                                ),

                          context.heightBox(0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(3, (index) {
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                height: context.getSize.height * 0.05,
                                width: context.getSize.width * 0.05,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index == 0
                                      ? ColorPalette.pink
                                      : index == 1
                                          ? ColorPalette.blue
                                          : ColorPalette.green,
                                ),
                              );
                            }),
                          )
                        ],
                      ),
                    ),
                  ),
                  if (isLoggedIn)
                    Container(
                      color: ColorPalette.black.withOpacity(0.3),
                      height: context.getSize.height,
                      width: context.getSize.width,
                      child: loading(),
                    ),
                ],
              ),
              if (!isConnected)
                Container(
                  alignment: Alignment.center,
                  width: context.getSize.width,
                  height: context.getSize.height,
                  decoration:
                      BoxDecoration(color: ColorPalette.black.withOpacity(0.2)),
                  child: Container(
                    height: context.getSize.height * 0.2,
                    width: context.getSize.width * 0.8,
                    decoration: BoxDecoration(
                        color: ColorPalette.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: ColorPalette.green)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Ionicons.close_circle,
                          color: ColorPalette.green,
                          size: 50,
                        ),
                        context.heightBox(0.01),
                        appText(
                            context: context,
                            title: 'No Internet Connection!',
                            textColor: ColorPalette.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ],
                    ),
                  ),
                ),
              Positioned(
                  bottom: -context.getSize.height * 0.08,
                  left: -context.getSize.width * 0.05,
                  child: Container(
                    height: context.getSize.height * 0.2,
                    width: context.getSize.width * 0.2,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: ColorPalette.blue),
                  )),
              Positioned(
                  bottom: context.getSize.height * 0.15,
                  right: -context.getSize.width * 0.05,
                  child: Container(
                    height: context.getSize.height * 0.15,
                    width: context.getSize.width * 0.15,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: ColorPalette.pink),
                  )),
            ],
          );
        },
      ),
    );
  }
}
