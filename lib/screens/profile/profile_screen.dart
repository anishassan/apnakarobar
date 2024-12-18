import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:sales_management/constant/color.dart';
import 'package:sales_management/extensions/height_width_extension.dart';
import 'package:sales_management/extensions/size_extension.dart';
import 'package:sales_management/main.dart';
import 'package:sales_management/provider/localization_provider.dart';

import 'package:sales_management/repositories/storage/storage_repo.dart';
import 'package:sales_management/utils/app_text.dart';
import 'package:sales_management/utils/text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController address = TextEditingController();
  @override
  void initState() {
    getData(getIt());
    // TODO: implement initState
    super.initState();
  }

  getData(StorageRepo repo) async {
    name.text = await repo.getName();
    email.text = await repo.getEmail();
    contact.text = await repo.getNumber();

    address.text = await repo.getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(builder: (context, provider, __) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            context.heightBox(0.1),
            appText(
                context: context,
                title: "PROFILE",
                fontSize: 32,
                fontWeight: FontWeight.bold,
                textColor: ColorPalette.green),
            context.heightBox(0.1),
            textField(
              suffixIcon: GestureDetector(
                child: const Icon(Icons.person, color: ColorPalette.green),
              ),
              context: context,
              controller: name,
              hintText: 'Name',
            ),
            context.heightBox(0.01),
            textField(
              suffixIcon: GestureDetector(
                child: const Icon(Icons.email, color: ColorPalette.green),
              ),
              context: context,
              controller: email,
              hintText: 'Email',
            ),
            context.heightBox(0.01),
            textField(
              suffixIcon: GestureDetector(
                child:
                    const Icon(Icons.contact_phone, color: ColorPalette.green),
              ),
              context: context,
              controller: contact,
              hintText: 'Contact',
            ),
            context.heightBox(0.01),
            textField(
              suffixIcon: GestureDetector(
                child:
                    const Icon(Icons.location_city, color: ColorPalette.green),
              ),
              context: context,
              controller: address,
              hintText: 'Address',
            ),
            context.heightBox(0.02),
            Row(
              children: List.generate(provider.langauge.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: GestureDetector(
                    onTap: () {
                      provider.changeIndex(index,getIt());
                    },
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.green,
                              )),
                          child: Container(
                            height: context.getSize.height * 0.05,
                            width: context.getSize.width * 0.05,
                            decoration: BoxDecoration(
                                color: provider.selectedIndex == index
                                    ? ColorPalette.green
                                    : ColorPalette.transparent,
                                shape: BoxShape.circle),
                          ),
                        ),
                        context.widthBox(0.01),
                        appText(
                            context: context,
                            title: provider.langauge[index],
                            textColor: ColorPalette.green)
                      ],
                    ),
                  ),
                );
              }),
            )
          ],
        ),
      );
    });
  }
}
