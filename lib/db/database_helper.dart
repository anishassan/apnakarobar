import 'dart:convert';
import 'dart:math';

import 'package:intl/intl.dart';
import 'package:sales_management/models/inventory_model.dart';
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
  static const String _path = 'kk.db';
  static const String _soldProducts = 'soldProducts';

  // Initialize the database
  static Future<void> initDb() async {
    if (_db != null) return; // Prevent reinitialization if already initialized

    try {
      String path = join(await getDatabasesPath(), _path);
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
        //     await db.execute('''
        //   CREATE TABLE $_purchase(
        //     id INTEGER PRIMARY KEY AUTOINCREMENT,
        //     name TEXT,
        //     remainigBalance TEXT,
        //     paidBalance TEXT,
        //     contact TEXT,
        //    soldDate TEXT,
        //    soldProducts TEXT
        //   )
        // ''');
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

    final now =
        DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 1)));
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
    final inventory = await _db!.query(_inventory);
    print(inventory);
    if (_db == null) return [];

    final result = await _db!.rawQuery('''
      SELECT d.addingDate, i.id AS dataId, i.title, i.date, i.lastPurchase, i.lastSale, i.desc,
             i.totalprice, i.productprice, i.quantity, i.stock
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

  Future<bool> addSalesData(SalesModel salesData) async {
    try {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Query the _sales table for a record matching the provided soldDate
      final salesResult = await _db!.query(
        _sales,
        where: 'soldDate = ?',
        whereArgs: [salesData.soldDate.isNotEmpty ? salesData.soldDate : today],
      );

      int salesId;
      if (salesResult.isEmpty ||
          salesResult.first['soldDate'] != salesData.soldDate) {
        // No matching record found or soldDate doesn't match, create a new sales record
        salesId = await _db!.insert(
          _sales,
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
            existingCustomer.remainigBalance = customer.remainigBalance;
            existingCustomer.paidBalance = customer.paidBalance;

            // Merge sold products
            for (var product in customer.soldProducts!) {
              final existingProductIndex = existingCustomer.soldProducts!
                  .indexWhere((p) => p.id == product.id);

              if (existingProductIndex != -1) {
                // Update existing product quantity
                final existingProduct =
                    existingCustomer.soldProducts![existingProductIndex];
                existingProduct.quantity =
                    (int.parse(existingProduct.quantity!) +
                            int.parse(product.quantity!))
                        .toString();
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

        // Update the _sales table with the merged data
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

      // Update inventory quantities for all sold products
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
                int.parse(inventoryItem['quantity']?.toString() ?? '0');
            final newStock = currentStock - int.parse(product.quantity!);

            // Update inventory quantity
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
            existingCustomer.remainigBalance = customer.remainigBalance;
            existingCustomer.paidBalance = customer.paidBalance;

            // Merge sold products
            for (var product in customer.soldProducts!) {
              final existingProductIndex = existingCustomer.soldProducts!
                  .indexWhere((p) => p.id == product.id);

              if (existingProductIndex != -1) {
                // Update existing product quantity
                final existingProduct =
                    existingCustomer.soldProducts![existingProductIndex];
                existingProduct.quantity =
                    (int.parse(existingProduct.quantity) +
                            int.parse(product.quantity))
                        .toString();
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
            final currentStock =inventoryItem.quantity =="" ? 0:
                int.parse(inventoryItem.quantity ?? '0');
            final newStock = currentStock + int.parse(product.quantity ?? '0');

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

    return result.map((data) {
      // Decode the 'data' field from JSON string to List<dynamic>
      final decodedData = jsonDecode(data['data'].toString()) as List<dynamic>;

      // Convert the decoded data to a list of Datum objects
      return SalesModel.fromJson({
        'soldDate': data['soldDate'],
        'data': decodedData.map((e) => Datum.fromJson(e)).toList(),
      });
    }).toList();
  }

  static Future<List<SalesModel>> getAllPurchaseData() async {
    final result = await _db!.query(_purchase);

    return result.map((data) {
      // Decode the 'data' field from JSON string to List<dynamic>
      final decodedData = jsonDecode(data['data'].toString()) as List<dynamic>;

      // Convert the decoded data to a list of Datum objects
      return SalesModel.fromJson({
        'soldDate': data['soldDate'],
        'data': decodedData.map((e) => Datum.fromJson(e)).toList(),
      });
    }).toList();
  }
}
