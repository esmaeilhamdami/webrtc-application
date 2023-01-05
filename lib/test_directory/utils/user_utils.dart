import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

var uUid = const Uuid();

Future<String> loadUserId() async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  
  String userId;
  if(sharedPreferences.containsKey('userId')){
    userId = sharedPreferences.getString('userId')!;
  }else {
    userId = uUid.v4();
    sharedPreferences.setString('userId', userId);
  }
  return userId;
}