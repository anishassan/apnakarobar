import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sales_management/models/inventory_model.dart';
import 'package:sales_management/models/report_model.dart';
import 'package:sales_management/models/sales_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sales_management/models/item_model.dart';

class DatabaseHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _inventory = 'inventory';
  static const String _datesTable = 'dates';
  static const String _sales = 'sales';
  static const _customer = 'customer';
  static const String _purchase = 'purchase';
  static const String _customerReport = 'customerreport';
  static const String _supplierReport = 'supplierreport';
  static const String _path = 'aaaaa.db';
  static const String _soldProducts = 'soldProducts';

// static Future<String> saveDatabaseToDownloads(String dbName) async {
//   try {
//     // Request storage permission
//     var status = await Permission.storage.request();
//     if (!status.isGranted) {
//       print("Storage permission denied.");
//       return '';
//     }

//     // Get the path of the Downloads directory
//     final downloadsDir = await getDownloadsDirectory();
//     if (downloadsDir == null) {
//       print("Downloads directory is not available.");
//       return '';
//     }

//     // Define source path (app data directory) and destination path (Downloads folder)
//     final appDir = await getApplicationDocumentsDirectory();
//     final sourcePath = '${appDir.path}/$dbName';
//     final destinationPath = '${downloadsDir.path}/$dbName';

//     // Copy the database file to the Downloads directory
//     final sourceFile = File(sourcePath);
//     final destinationFile = File(destinationPath);

//     if (await sourceFile.exists()) {
//       await sourceFile.copy(destinationFile.path);
//       print("Database file saved to Downloads: $destinationPath");
//       return destinationPath; // Return the destination path
//     } else {
//       print("Database file not found at: $sourcePath");
//       return ''; // Return null if source file doesn't exist
//     }
//   } catch (e) {
//     print("Error saving database file: $e");
//     return ''; // Return null if an error occurs
//   }
// }
  // Initialize the database
  static Future<void> initDb() async {
    if (_db != null) return; // Prevent reinitialization if already initialized

    try {
      String path = join(await getDatabasesPath(), _path);
      // String path = await saveDatabaseToDownloads(_path);
      print("Database Path $path");
      _db = await openDatabase(path, version: _version,
          onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_datesTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            addingDate TEXT NOT NULL UNIQUE
          )
        ''');
        await db.execute('''
          CREATE TABLE $_inventory(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            totalprice TEXT NOT NULL,
            lastSale TEXT NOT NULL,
            lastPurchase TEXT NOT NULL,
            desc TEXT NOT NULL,
            productprice TEXT NOT NULL,
            type TEXT NOT NULL,
            quantity TEXT NOT NULL,
            stock TEXT NOT NULL,
            date TEXT NOT NULL,
            dateId INTEGER,
            FOREIGN KEY(dateId) REFERENCES $_datesTable(id) ON DELETE CASCADE
          )
        ''');
        await db.execute('''
          CREATE TABLE $_sales(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            soldDate TEXT,
            data TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE $_customer(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            salesId INTEGER,  -- Foreign Key Reference to sales
            name TEXT,
            contact TEXT,
            remainigBalance TEXT,
            paidBalance TEXT,
            FOREIGN KEY (salesId) REFERENCES $_sales (id)
          )
        ''');
        await db.execute('''
          CREATE TABLE $_soldProducts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            customerId INTEGER,  -- Reference to customerData
            title TEXT,
            stock TEXT,
            lastSale TEXT,
            lastPurchase TEXT,
            buySaleQ TEXT,
            desc TEXT,
            totalprice TEXT NOT NULL,
            productprice TEXT NOT NULL,
            quantity TEXT,
            date TEXT,
            dateId TEXT,
            FOREIGN KEY (customerId) REFERENCES $_customer(id)
          )
        ''');

        await db.execute('''CREATE TABLE $_customerReport(
          id INTEGER,
          name TEXT,
          contact TEXT,
          data TEXT
          )''');
        await db.execute('''CREATE TABLE $_supplierReport(
          id INTEGER,
          name TEXT,
          contact TEXT,
          data TEXT
          )''');
        await db.execute('''
          CREATE TABLE $_purchase(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            soldDate TEXT,
            data TEXT
          )
        ''');
      });
    } catch (e) {
      throw Exception("Database initialization failed: $e");
    }
  }

  // Add inventory items
  static Future<bool> addInventory(List<ItemModel> data) async {
    bool isSuccess = false;
    if (_db == null) throw Exception("Database is not initialized");

    final now = DateFormat('yyyy-MM-dd').format(DateTime.now());
    print(data.length);
    // Check if an exact matching date exists
    final existingDate = await _db!.query(
      _datesTable,
      where: 'addingDate = ?',
      whereArgs: [now],
    );

    int dateId;
    if (existingDate.isNotEmpty) {
      // Use the existing date's ID
      dateId = existingDate.first['id'] as int;
    } else {
      // Insert a new date and get the inserted ID
      dateId = await _db!.insert(_datesTable, {'addingDate': now});
    }

    // Start a batch operation for inserting items
    final batch = _db!.batch();

    for (var item in data) {
      // Debug: Print item before insertion
      final mappedItem = item.copyWith(dateId: dateId);
      print('Inserting Item: ${mappedItem.toJson()}');
      batch.insert(_inventory, mappedItem.toJson());
    }

    await batch.commit(noResult: true).whenComplete(() {
      isSuccess = true;
    });
    return isSuccess;
  }

  // Get inventory data
  static Future<List<Map<String, dynamic>>> getInventory() async {
    final inventory = await _db?.query(_inventory);
    print(inventory);
    if (_db == null) return [];

    final result = await _db!.rawQuery('''
      SELECT d.addingDate, i.id AS dataId, i.title, i.date, i.lastPurchase, i.lastSale, i.desc,
             i.totalprice, i.productprice, i.quantity, i.stock, i.type
      FROM $_datesTable d
      LEFT JOIN $_inventory i ON d.id = i.dateId
    ''');

    // Group results by addingDate
    final groupedData = <String, List<Map<String, dynamic>>>{};

    for (final row in result) {
      final addingDate = row['addingDate'] as String;
      groupedData.putIfAbsent(addingDate, () => []);

      if (row['dataId'] != null) {
        groupedData[addingDate]!.add({
          'id': row['dataId'],
          'title': row['title'],
          'date': row['date'],
          'totalprice': row['totalprice'],
          'productprice': row['productprice'],
          'quantity': row['quantity'],
          'lastSale': row['lastSale'],
          'lastPurchase': row['lastPurchase'],
          'desc': row['desc'],
          'type':row['type'],
          'stock': row['stock'],
        });
      }
    }

    // Convert the grouped data into the desired format
    return groupedData.entries.map((entry) {
      return {
        'addingDate': entry.key,
        'data': entry.value,
      };
    }).toList();
  }

  // Delete an inventory item by ID
  static Future<int> deleteInventoryItem(int id) async {
    if (_db == null) throw Exception("Database is not initialized");
    return await _db!.delete(_inventory, where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> updateRemainingBalance(
      {required int customerId,
      required String soldDate,
      required String newBalance,
      required String paidNewBalance,
      bool isSales = false,
      required String name,
      required String contact}) async {
    bool isSuccess = false;
    // Update query
    List<Map<String, dynamic>> result = await _db!.query(
      isSales ? _sales : _purchase,
      where: 'soldDate = ?',
      whereArgs: [soldDate],
    );

    if (result.isNotEmpty) {
      // Parse the data field (JSON string)
      String jsonData = result.first['data'];
      List<dynamic> dataList = jsonDecode(jsonData);

      // Find the matching customer and update remainigBalance
      for (var customer in dataList) {
        print(double.parse(newBalance).toString());
        if (customer['id'] == customerId &&
            customer['name'] == name &&
            customer['contact'] == contact) {
          customer['remainigBalance'] = newBalance;
          customer['paidBalance'] = (double.parse(customer['paidBalance']) +
                  double.parse(paidNewBalance))
              .toString();
          print(
              'Updated balance for customer: $name ,${customer['remainigBalance']}');
        }
      }

      // Convert the updated list back to JSON
      String updatedJson = jsonEncode(dataList);

      // Update the database
      int count = await _db!.update(
        isSales ? _sales : _purchase,
        {'data': updatedJson},
        where: 'soldDate = ?',
        whereArgs: [soldDate],
      );

      if (count > 0) {
        isSuccess = true;
        print('Database updated successfully');
      } else {
        print('Failed to update the database');
      }
    } else {
      print('No record found for soldDate: $soldDate');
    }
    return isSuccess;
  }

  Future<bool> addSalesData(SalesModel salesData) async {
    try {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final soldDate =
          salesData.soldDate.isNotEmpty ? salesData.soldDate : today;

      // Query the _sales table for a record matching the provided soldDate
      final salesResult = await _db!.query(
        _sales,
        where: 'soldDate = ?',
        whereArgs: [soldDate],
      );

      if (salesResult.isEmpty) {
        // No record with matching soldDate, create new entry
        await _db!.insert(
          _sales,
          {
            'soldDate': soldDate,
            'data': jsonEncode(salesData.data.map((c) => c.toJson()).toList()),
          },
        );
      } else {
        // Record with matching soldDate exists, update the existing record
        final salesId = salesResult.first['id'] as int;
        final existingDataJson = salesResult.first['data'] as String?;
        List<dynamic> existingData =
            existingDataJson != null ? jsonDecode(existingDataJson) : [];

        final existingCustomers = existingData
            .map((e) => Datum.fromJson(e as Map<String, dynamic>))
            .toList();

        for (var customer in salesData.data) {
          final existingCustomerIndex = existingCustomers.indexWhere(
            (c) => c.customerId == customer.customerId,
          );

          if (existingCustomerIndex != -1) {
            final existingCustomer = existingCustomers[existingCustomerIndex];

            existingCustomer.remainigBalance =
                (double.parse(existingCustomer.remainigBalance ?? '0.0') +
                        double.parse(customer.remainigBalance ?? '0.0'))
                    .toString();
            existingCustomer.paidBalance =
                (double.parse(existingCustomer.paidBalance ?? '0.0') +
                        double.parse(customer.paidBalance ?? '0.0'))
                    .toString();

            for (var product in customer.soldProducts!) {
              final existingProductIndex = existingCustomer.soldProducts!
                  .indexWhere((p) => p.id == product.id);

              if (existingProductIndex != -1) {
                final existingProduct =
                    existingCustomer.soldProducts![existingProductIndex];
                existingProduct.quantity =
                    (double.parse(existingProduct.quantity) +
                            double.parse(product.quantity))
                        .toStringAsFixed(1);
              } else {
                existingCustomer.soldProducts!.add(product);
              }
            }
          } else {
            existingCustomers.add(customer);
          }
        }

        // Update the sales record
        await _db!.update(
          _sales,
          {
            'data':
                jsonEncode(existingCustomers.map((c) => c.toJson()).toList()),
          },
          where: 'id = ?',
          whereArgs: [salesId],
        );
      }

      // Update inventory quantities
      for (var customer in salesData.data) {
        for (var product in customer.soldProducts!) {
          final inventoryResult = await _db!.query(
            _inventory,
            where: 'id = ?',
            whereArgs: [product.id],
          );

          if (inventoryResult.isNotEmpty) {
            final inventoryItem = inventoryResult.first;
            final currentStock =
                double.parse(inventoryItem['quantity']?.toString() ?? '0');
            final newStock = currentStock - double.parse(product.quantity??'0.0');

            await _db!.update(
              _inventory,
              {'quantity': newStock.toString()},
              where: 'id = ?',
              whereArgs: [product.id],
            );
          }
        }
      }

      return true;
    } catch (e) {
      print("Error in addSalesData: $e");
      return false;
    }
  }

  Future<bool> addPurchaseData(SalesModel salesData) async {
    try {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Query the _purchase table for a record matching the provided soldDate
      final salesResult = await _db!.query(
        _purchase,
        where: 'soldDate = ?',
        whereArgs: [salesData.soldDate.isNotEmpty ? salesData.soldDate : today],
      );

      int salesId;
      if (salesResult.isEmpty) {
        // No matching record found, create a new purchase record
        salesId = await _db!.insert(
          _purchase,
          {
            'soldDate':
                salesData.soldDate.isNotEmpty ? salesData.soldDate : today,
            'data': jsonEncode(salesData.data.map((c) => c.toJson()).toList()),
          },
        );
      } else {
        // Matching record found, get the salesId and update the existing record
        salesId = salesResult.first['id'] as int;

        // Decode existing data to merge with new data
        final existingDataJson = salesResult.first['data'] as String?;
        List<dynamic> existingData =
            existingDataJson != null ? jsonDecode(existingDataJson) : [];

        final existingCustomers = existingData
            .map((e) => Datum.fromJson(e as Map<String, dynamic>))
            .toList();

        // Update or add customers
        for (var customer in salesData.data) {
          final existingCustomerIndex = existingCustomers.indexWhere(
            (c) => c.customerId == customer.customerId,
          );

          if (existingCustomerIndex != -1) {
            // Existing customer found, update their data
            final existingCustomer = existingCustomers[existingCustomerIndex];

            // Update customer balances
            existingCustomer.remainigBalance =
                (double.parse(existingCustomer.remainigBalance ?? '0.0') +
                        double.parse(customer.remainigBalance ?? '0.0'))
                    .toString();
            existingCustomer.paidBalance =
                (double.parse(existingCustomer.paidBalance ?? '0.0') +
                        double.parse(customer.paidBalance ?? '0.0'))
                    .toString();

            // Merge sold products
            for (var product in customer.soldProducts!) {
              final existingProductIndex = existingCustomer.soldProducts!
                  .indexWhere((p) => p.id == product.id);

              if (existingProductIndex != -1) {
                // Update existing product quantity
                final existingProduct =
                    existingCustomer.soldProducts![existingProductIndex];
                existingProduct.quantity =
                    (double.parse(existingProduct.quantity) +
                            double.parse(product.quantity))
                        .toStringAsFixed(1);
              } else {
                // Add new product
                existingCustomer.soldProducts!.add(product);
              }
            }
          } else {
            // Add new customer
            existingCustomers.add(customer);
          }
        }

        // Update the _purchase table with the merged data
        await _db!.update(
          _purchase,
          {
            'data':
                jsonEncode(existingCustomers.map((c) => c.toJson()).toList()),
          },
          where: 'id = ?',
          whereArgs: [salesId],
        );
      }

      // Update inventory quantities and other fields for all sold products
      for (var customer in salesData.data) {
        for (var product in customer.soldProducts!) {
          final inventoryResult = await _db!.query(
            _inventory,
            where: 'id = ?',
            whereArgs: [product.id],
          );

          if (inventoryResult.isNotEmpty) {
            final invv = inventoryResult.first;
            final inventoryItem = InventoryItem.fromJson(invv);
            // final currentStock = inventoryItem.quantity == ""
            //     ? 0
            //     : int.parse(inventoryItem.quantity ?? '0');
            final newStock = double.parse(product.quantity ?? '0.0');

            // Update inventory quantity and additional fields
            await _db!.update(
              _inventory,
              {
                'quantity': newStock.toString(),
                'lastPurchase':
                    product.lastPurchase ?? inventoryItem.lastPurchase,
                'lastSale': product.lastSale ?? inventoryItem.lastSale,
                'productprice':
                    product.productprice ?? inventoryItem.productprice,
              },
              where: 'id = ?',
              whereArgs: [product.id],
            );
          }
        }
      }

      return true;
    } catch (e) {
      print("Error in addPurchaseData: $e");
      return false;
    }
  }

  static Future<List<SalesModel>> getAllSalesData() async {
    final result = await _db!.query(_sales);
    print("Sales Daata $result");

    return result
        .map((data) {
          // Decode the 'data' field from JSON string to List<dynamic>
          final decodedData =
              jsonDecode(data['data'].toString()) as List<dynamic>;

          // Convert the decoded data to a list of Datum objects
          return SalesModel.fromJson({
            'soldDate': data['soldDate'],
            'id': data['id'],
            'data': decodedData.map((e) => Datum.fromJson(e)).toList(),
          });
        })
        .toList()
        .reversed
        .toList();
  }

  static Future<List<SalesModel>> getAllPurchaseData() async {
    final result = await _db!.query(_purchase);

    return result
        .map((data) {
          // Decode the 'data' field from JSON string to List<dynamic>
          final decodedData =
              jsonDecode(data['data'].toString()) as List<dynamic>;
          print("Purchase Data $decodedData");
          // Convert the decoded data to a list of Datum objects
          return SalesModel.fromJson({
            'soldDate': data['soldDate'],
            'id': data['id'],
            'data': decodedData.map((e) => Datum.fromJson(e)).toList(),
          });
        })
        .toList()
        .reversed
        .toList();
  }

  Future<void> insertOrUpdateData(
    Datum newData,
    bool isSale,
    String pickedDate, {
    bool isFirstTime = true,
    required String soldDate,
  }) async {
    String name = newData.name ?? '';
    int id = newData.customerId ?? 0;
    print("CUSTOMER ID +++++++++++++++++++++++++++++++++++++ $id");
    String contact = newData.contact ?? '';

    // Query to find existing record
    List<Map<String, dynamic>> result = await _db!.query(
      isSale ? _customerReport : _supplierReport,
      where: 'name = ? AND contact = ? AND id = ?',
      whereArgs: [name, contact, id],
    );

    double totalSales = 0.0;

    // Calculate total sales from sold products
    for (InventoryItem item in newData.soldProducts ?? []) {
      totalSales += (double.parse(item.buySaleQuantity ?? '0') *
          double.parse(item.productprice ?? '0.0'));
    }

    try {
      if (result.isNotEmpty) {
        // Update existing record
        Map<String, dynamic> existingRecord = result.first;
        List<dynamic> existingData = jsonDecode(existingRecord['data']);

        existingData.add(ReportModel(
            sales: isFirstTime ? totalSales.toString() : "0.0",
            remainingBalance: newData.remainigBalance ?? '0.0',
            paidBalance: newData.paidBalance ?? '0.0',
            date: pickedDate,
            soldDate: soldDate));

        // Update record in database
        await _db!.update(
          isSale ? _customerReport : _supplierReport,
          {'data': jsonEncode(existingData)},
          where: 'id = ?',
          whereArgs: [existingRecord['id']],
        );
      } else {
        // Insert new record if no match is found
        List<Map<String, dynamic>> newEntry = [
          ReportModel(
            soldDate: soldDate,
            sales: isFirstTime ? totalSales.toString() : "0.0",
            remainingBalance: newData.remainigBalance,
            paidBalance: newData.paidBalance,
            date: pickedDate,
          ).toJson()
        ];

        await _db!.insert(
          isSale ? _customerReport : _supplierReport,
          {
            'id': id,
            'name': name,
            'contact': contact,
            'data': jsonEncode(newEntry),
          },
        );
      }
    } catch (e) {
      print("Error during data insertion/update: $e");
    }
  }

  Future<List<ReportData>> getCustomerReport() async {
    // Query the database
    final result = await _db!.query(_customerReport);
    print(result);
    List<ReportData> dataList = [];

    if (result.isNotEmpty) {
      for (var record in result) {
        // Decode the JSON string from the database
        var decodedData = jsonDecode(record['data'].toString());

        // If data is a List (array), process it as such
        List<ReportModel> reportModels = [];
        if (decodedData is List) {
          reportModels =
              decodedData.map((data) => ReportModel.fromJson(data)).toList();
        }
        // If data is a single object (not an array), wrap it in a list
        else if (decodedData is Map<String, dynamic>) {
          reportModels.add(ReportModel.fromJson(decodedData));
        }

        // Add the parsed ReportData to the dataList
        dataList.add(ReportData(
          id: record['id'] as int,
          name: record['name'] as String,
          contact: record['contact'] as String,
          data: reportModels,
        ));
      }
    }

    // Return the parsed list of ReportData
    return dataList;
  }

  Future<List<ReportData>> getSupplierReport() async {
    // Query the database
    final result = await _db!.query(_supplierReport);
    print(result);
    List<ReportData> dataList = [];

    if (result.isNotEmpty) {
      for (var record in result) {
        // Decode the JSON string from the database
        var decodedData = jsonDecode(record['data'].toString());

        // If data is a List (array), process it as such
        List<ReportModel> reportModels = [];
        if (decodedData is List) {
          reportModels =
              decodedData.map((data) => ReportModel.fromJson(data)).toList();
        }
        // If data is a single object (not an array), wrap it in a list
        else if (decodedData is Map<String, dynamic>) {
          reportModels.add(ReportModel.fromJson(decodedData));
        }

        // Add the parsed ReportData to the dataList
        dataList.add(ReportData(
          id: record['id'] as int,
          name: record['name'] as String,
          contact: record['contact'] as String,
          data: reportModels,
        ));
      }
    }

    // Return the parsed list of ReportData
    return dataList;
  }

  Future<List<ReportData>> parseReportData(String jsonString) async {
    // Decode the JSON string into a list
    List<dynamic> decodedJson = jsonDecode(jsonString);

    // Convert the decoded JSON into a list of ReportData
    List<ReportData> reportDataList =
        decodedJson.map((item) => ReportData.fromJson(item)).toList();

    return reportDataList;
  }

  Future<void> deleteDatabaseFile() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, _path);

    // Delete the database file
    await deleteDatabase(dbPath);
    print('Database deleted successfully');
  }
}
