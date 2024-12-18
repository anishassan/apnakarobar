import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sales_management/bindings/routes.dart';
import 'package:sales_management/extensions/validation_extension.dart';
import 'package:sales_management/models/register_res_model.dart';
import 'package:sales_management/repositories/register/register_repo.dart';
import 'package:sales_management/repositories/storage/storage_repo.dart';
import 'package:sales_management/utils/toast.dart';

class RegisterProvider extends ChangeNotifier {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController category = TextEditingController();

  bool _loading = false;
  bool get loading => _loading;
  changeLoading(bool val) {
    _loading = val;
    notifyListeners();
  }
  bool _isCatAdded = true;
  bool get isCatAdded => _isCatAdded;
  changeCatAdded(bool val){
    _isCatAdded = val;
    notifyListeners();
  }

  Future register(
      {required BuildContext context,
      required RegisterRepo repo,
      required StorageRepo storage}) async {
    if (name.text.isEmpty) {
      toast(msg: 'Enter your name please', context: context);
    } else if (email.text.isEmpty) {
      toast(msg: 'Enter your email please', context: context);
    } else if (!email.text.emailValidator()) {
      toast(msg: 'Enter valid email please', context: context);
    } else if (contact.text.isEmpty) {
      toast(msg: 'Enter your phone number please', context: context);
    }else if(category.text.isEmpty){
      changeCatAdded(false);
      toast(msg: 'Please enter business category', context: context);
    } else {
      changeLoading(true);
      final data = await repo.register(
        category: category.text,
          context: context,
          name: name.text,
          email: email.text,
          address: address.text,
          contact: contact.text);
      if (data.success != null) {
        if(data.success == false){
          toast(msg: 'Email already exist please try again with new email.', context: context);
        }else{
        storage.setEmail(email.text);
        print(data.the0!.id);
        storage.setUid(data.the0!.id.toString() ?? '');
        storage.setName(data.the0!.title.toString() ?? '');
        storage.setNumber(data.the0!.contact.toString() ?? '');
        storage.setAddress(data.the0!.address.toString() ?? '');
        Navigator.pushReplacementNamed(context, Routes.dashboard);
        }
        changeLoading(false);
        
      } else {
        changeLoading(false);
      }
    }
  }

  List<String> categories = <String>[
    "Medical Store",
  "Dry Fruit Store",
  "Tailor Shop",
  "Fruit Shop",
  "Mobile easy load",
  "Mobile Repairing Shop",
  "Computer Shop",
  "Chicken Shop",
  "Restaurant",
  "Grocery Shop",
  ];

  bool _showList = false;
  bool get showList => _showList;
  changeShowlist(){
    _showList = !_showList;
    notifyListeners();
  }
}
