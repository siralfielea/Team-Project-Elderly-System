import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'services/auth_service.dart';

void main(){
runApp( 
MultiProvider( 
providers: [
ChangeNotifierProvider(create: (_) => AuthService()),
],
child: const MyApp(),
),
);
}
