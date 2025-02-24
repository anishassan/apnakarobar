import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:sales_management/bindings/pages.dart';
import 'package:sales_management/bindings/routes.dart';
import 'package:sales_management/constant/color.dart';
import 'package:sales_management/db/database_helper.dart';
import 'package:sales_management/network/connectivity.dart';
import 'package:sales_management/provider/add_product_provider.dart';
import 'package:sales_management/provider/dashboard_provider.dart';
import 'package:sales_management/provider/detail_provider.dart';
import 'package:sales_management/provider/inventory_provider.dart';
import 'package:sales_management/provider/localization_provider.dart';
import 'package:sales_management/provider/purchase_provider.dart';
import 'package:sales_management/provider/register_provider.dart';
import 'package:sales_management/provider/report_provider.dart';
import 'package:sales_management/provider/sales_provider.dart';
import 'package:sales_management/repositories/customer/customer_repo.dart';
import 'package:sales_management/repositories/customer/dio_customer_repo.dart';
import 'package:sales_management/repositories/inventory/dio_inventory_repo.dart';
import 'package:sales_management/repositories/inventory/inventory_repo.dart';
import 'package:sales_management/repositories/register/dio_register_repo.dart';
import 'package:sales_management/repositories/register/register_repo.dart';
import 'package:sales_management/repositories/storage/pref_storage_repo.dart';
import 'package:sales_management/repositories/storage/storage_repo.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sales_management/repositories/supplier/dio_supplier_repo.dart';
import 'package:sales_management/repositories/supplier/supplier_repo.dart';

GetIt getIt = GetIt.instance;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  serviceLocator();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => SalesProvider()),
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
        ChangeNotifierProvider(create: (_) => PurchaseProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => AddProductProvider()),
        ChangeNotifierProvider(create: (_) => LocalizationProvider()),
        ChangeNotifierProvider(create: (_) => DetailProvider()),
      ],
      child: Consumer<LocalizationProvider>(
        builder: (context, provider, __) {
          getLang(getIt(), provider);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            locale: provider.locale,
            supportedLocales: const [
              Locale('en'),
              Locale('ur'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              scaffoldBackgroundColor: ColorPalette.white,
              colorScheme: ColorScheme.fromSeed(
                  seedColor: ColorPalette.green.withOpacity(0.1)),
              useMaterial3: true,
            ),
            initialRoute: Routes.splash,
            onGenerateRoute: Pages.onGenerateRoute,
          );
        },
      ),
    );
  }

  getLang(StorageRepo repo, LocalizationProvider pv) async {
    final lang = await repo.getLang();
    if (lang != '') {
      pv.setLocale(Locale(lang));
      
      if (lang == 'ur') {
        pv.changeIndex(1, getIt());
      } else {
        pv.changeIndex(0, getIt());
      }
    }else{
       pv.changeIndex(0, getIt());
    }
  }
}

void serviceLocator() {
  getIt.registerLazySingleton<RegisterRepo>(() => DioRegisterRepo());
  getIt.registerLazySingleton<StorageRepo>(() => PrefStorageRepo());
  getIt.registerLazySingleton<InventoryRepo>(() => DioInventoryRepo());
  getIt.registerLazySingleton<SupplierRepo>(() => DioSupplierRepo());
  getIt.registerLazySingleton<CustomerRepo>(() => DioCustomerRepo());
}
