import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:sales_management/models/post_purchase_model.dart';
import 'package:sales_management/models/post_sale_model.dart';
import 'package:sales_management/models/sales_model.dart';
import 'package:sales_management/network/api_services.dart';
import 'package:sales_management/network/api_url.dart';
import 'package:sales_management/repositories/customer/customer_repo.dart';

class DioCustomerRepo implements CustomerRepo {
  @override
  Future uploadCustomer(
      {required BuildContext context,
      required int currentUserId,
      required Datum customer}) async {
    try {
      final data = {
        "customer_id": customer.customerId,
        "business_id": currentUserId,
        "name": customer.name,
        "contact": customer.contact,
        "balance": double.parse(customer.remainigBalance ?? '0.0')
      };
      print("Customer Data JSON ++++++++++++++ $data");
      final response =
          await API().postRequest(context, ApiUrl.customerInsert, data);
      if (response.statusCode == 200) {
        print('Customer Upload Successfully ${response.data}');
        print(response.data);
      } else {
        print('Customer Upload Error');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Future uploadSales(
      {required BuildContext context,
      required String date,
      required int saleId,
      required int currentUserId,
      required List<SalesModel> salesData,
      required List<Datum> customer}) async {
    try {
      final  model = PostSaleModel(
        businessId: currentUserId,
        data: customer
            .map((e) => PostCustomer(
                  discount: int.tryParse(e.discount ?? '0') ?? 0,
                  customerId: e.customerId,
                  soldDate: date,
                  paidAmount: int.tryParse(e.paidBalance ?? '0') ?? 0,
                  soldProducts: e.soldProducts!
                          .map((s) => PostSoldProduct(
                                title: s.title,
                                price:
                                    (double.tryParse(s.productprice ?? '0.0') ??
                                            0.0)
                                        .toInt(),
                                id: s.id,
                                quantity:
                                    int.tryParse(s.buySaleQuantity ?? '0') ?? 0,
                              ))
                          .toList() ??
                      [],
                ))
            .toList(),
      );
      print("Current User ID $currentUserId");
//       List<Map<String, dynamic>> data =
//           salesData.map((e) => PostSaleModel(
// businessId: currentUserId,
// data: e.data.map((x)=> PostCustomer(
//   discount: int.tryParse(x.discount ?? '0') ?? 0,
//                   customerId: x.customerId,
//                   soldDate: e.soldDate,
//                     paidAmount: int.tryParse(x.paidBalance ?? '0') ?? 0,
//                     soldProducts: x.soldProducts!
//                           .map((s) => PostSoldProduct(
//                                 title: s.title,
//                                 price:
//                                     (double.tryParse(s.productprice ?? '0.0') ??
//                                             0.0)
//                                         .toInt(),
//                                 id: s.id,
//                                 quantity:
//                                     int.tryParse(s.buySaleQuantity ?? '0') ?? 0,
//                               ))
//                           .toList() ??
//                       [],
// )).toList()
//           ).toJson()).toList();
//       print("SALES MODEL DATA *************** ${model.toJson()}");
      final response = await API()
          .postRequest(context, ApiUrl.salesInsert, jsonEncode(model.toJson()));
      if (response.data['success'] == true) {
        print('Sales Upload Successfully');
        print(response.data);
      } else {
        print('Sales Upload Error: ${response.data}');
      }
    } catch (e) {
      print(e);
    }
  }
}
