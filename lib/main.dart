import 'package:browser_app/component/network/provider/network_provider.dart';
import 'package:browser_app/screen/home/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utile/app_routes.dart';
void main()
{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider.value(value: NetworkProvider()),
        ChangeNotifierProvider.value(value: HomeProvider()),
      ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: app_routes,
        ),),
  );
}