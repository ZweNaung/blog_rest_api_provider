import 'package:blog_rest_api_provider/data/service/blog_api_service.dart';
import 'package:blog_rest_api_provider/provider/get_all_post/get_all_provider.dart';
import 'package:blog_rest_api_provider/provider/get_complete_post/get_complete_provider.dart';
import 'package:blog_rest_api_provider/provider/upload_post/blog_upload_provider.dart';
import 'package:blog_rest_api_provider/ui/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
       ChangeNotifierProvider(create: (e)=>GetAllNotifier()),
       ChangeNotifierProvider(create: (e)=>GetCompleteNotifier()),
       ChangeNotifierProvider(create: (e)=>BlogUploadNotifier()),
      ],
      child: const MaterialApp(
        home: Home(),
      ),
    );
  }
}
