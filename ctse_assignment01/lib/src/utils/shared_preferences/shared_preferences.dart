import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences{

  static late final SharedPreferences _preferences;
  static const OnBoardKey = "OnBoard";


  static Future init () async => _preferences = await SharedPreferences.getInstance();

  static Future setonBoardingState(bool state) async => await _preferences.setBool(OnBoardKey, state);
  static bool? GetonBoardingState() => _preferences.getBool(OnBoardKey);
  static Future removeOnBoardingState() async => await _preferences.remove(OnBoardKey);


}