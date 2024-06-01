import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goevent2/spleshscreen.dart';
import 'package:provider/provider.dart';

import 'utils/colornotifire.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ColorNotifire()),
      ],
      child: const GetMaterialApp(
          home: Spleshscreen(), debugShowCheckedModeBanner: false),
    ),
  );
}
