import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_management/db/database_helper.dart';
import 'package:sales_management/models/sales_model.dart';
import 'package:sales_management/provider/purchase_provider.dart';
import 'package:sales_management/provider/report_provider.dart';
import 'package:sales_management/provider/sales_provider.dart';
import 'package:sales_management/utils/toast.dart';

class DetailProvider extends ChangeNotifier {
  TextEditingController remainingBalance = TextEditingController();
  String _remaining = '';
  String get remaining => _remaining;
  changeRemaining(String v) {
    _remaining = v;
    notifyListeners();
  }

  updateRemaining(
      Datum model, BuildContext context, bool isSale, String soldDate) async {
    if (double.parse(model.remainigBalance ?? '0.0') <
        double.parse(remainingBalance.text)) {
      toast(
          msg:
              "Entered Amount must be less than and equal to remaining balance.",
          maxline: 2,
          context: context);
    } else {
      await DatabaseHelper().insertOrUpdateData(
          soldDate: soldDate,
          isFirstTime: false,
          Datum(
            name: model.name,
            customerId: model.customerId,
            contact: model.contact,
            paidBalance: (double.parse(remainingBalance.text)).toString(),
            remainigBalance: (double.parse(model.remainigBalance ?? '0.0') -
                    double.parse(remainingBalance.text))
                .toString(),
            soldProducts: model.soldProducts,
          ),
          isSale,
          _selectedDate.toString());
      bool check = await DatabaseHelper().updateRemainingBalance(
          name: model.name ?? '',
          contact: model.contact ?? '',
          paidNewBalance: remainingBalance.text,
          customerId: model.customerId ?? 0,
          newBalance: (double.parse(model.remainigBalance ?? '0.0') -
                  double.parse(remainingBalance.text))
              .toString(),
          isSales: isSale,
          soldDate: soldDate);
      if (check) {
        toast(msg: 'Remaining Balance Update Successfully.', context: context);
        if (isSale) {
          remainingBalance.clear();
          Provider.of<SalesProvider>(context, listen: false)
              .getSales(context: context)
              .then((v) {
            Provider.of<ReportProvider>(context, listen: false).getCustomer();
            Provider.of<ReportProvider>(context, listen: false).getSales();
            Navigator.of(context).pop();
          });
        } else {
          remainingBalance.clear();
          Provider.of<PurchaseProvider>(context, listen: false)
              .getPurchase(context: context)
              .then((v) {
            Provider.of<ReportProvider>(context, listen: false).getSuppler();
            Provider.of<ReportProvider>(context, listen: false).getPurchase();
            Navigator.of(context).pop();
          });
        }
      }
    }
  }

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;
  changeDate(DateTime d) {
    _selectedDate = d;
    print(d);
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
