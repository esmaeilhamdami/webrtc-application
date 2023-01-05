import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc_wrapper/webrtc_meeting_helper.dart';
import 'package:http/http.dart';
import 'package:text_webrtc/test_directory/api/meeting_api.dart';
import 'package:text_webrtc/test_directory/models/meeting_detail.dart';
import 'package:text_webrtc/test_directory/pages/join_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String meetingId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meeting App'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Form(
        key: globalKey,
        child: fromUi(context),
      ),
    );
  }

  fromUi(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to WebRTC Meeting app',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 26),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: (value) {
                meetingId = value;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: MaterialButton(
                    onPressed: () {
                      if (validateAndSave()) {
                        validateMeeting(meetingId);
                      }
                    },
                    child: const Text('Join Meeting'),
                  ),
                ),
                Flexible(
                  child: MaterialButton(
                    onPressed: () async {
                      var response = await startMeeting();
                      final body = json.decode(response!.body);

                      final meetId = body['data'];

                      validateMeeting(meetId);
                    },
                    child: const Text('Start Meeting'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void validateMeeting(String meetingId) async {
    try {
      Response? response = await joinMeeting(meetingId);
      var data = json.decode(response!.body);

      final meetingDetails = MeetingDetail.fromJson(data['data']);
      goToJoinScreen(meetingDetails);
    } catch (e) {
      print(e);
    }
  }

  goToJoinScreen(MeetingDetail meetingDetail) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JoinScreen(meetingDetail: meetingDetail),
        ));
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
