import 'package:ctse_assignment01/src/screens/auth_screen/signin_screen/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  testWidgets("Testing sign form render TextFormFields",(WidgetTester tester) async {
    await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(360, 812),
      builder: (context, child) => GetMaterialApp(
      home: SignIn(),
    ),)
    );
    var textFiled = find.byType(TextFormField);
    expect(textFiled,findsOneWidget);
  });


}