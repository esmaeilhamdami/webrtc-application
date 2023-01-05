import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/user_utils.dart';

String meetingApiUrl = 'http://192.168.1.105:4000/api/meeting';
var client = http.Client();

Future<http.Response?> startMeeting() async {
  var userId = await loadUserId();
  print('read');
  var response = await client.post(Uri.parse('$meetingApiUrl/start'),
      headers: {'Content-Type': 'application/json'},body: jsonEncode({'hostId': userId , 'hostName': ''}));

  print('read');
  print(response);

  if(response.statusCode == 200){
    return response;
  }else{
    return null;
  }
}

Future<http.Response?> joinMeeting(String meetingId) async {
  print(meetingId);
  var response = await http.get(Uri.parse('$meetingApiUrl/join?meetingId=$meetingId'));

  print('============== ${response.body}');
  if(response.statusCode >= 200 && response.statusCode < 400){
    return response;
  }
  throw UnimplementedError('Not a valid Meeting');
}


