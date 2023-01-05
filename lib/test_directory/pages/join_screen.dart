import 'package:flutter/material.dart';
import 'package:text_webrtc/test_directory/models/meeting_detail.dart';
import 'package:text_webrtc/test_directory/pages/meeting_page.dart';

class JoinScreen extends StatefulWidget {
  final MeetingDetail? meetingDetail;

  const JoinScreen({Key? key, this.meetingDetail}) : super(key: key);

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  String userName = '';

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
            const SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: (value) {
                userName = value;
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MeetingPage(
                                  meetingDetail: widget.meetingDetail!,
                                  name: userName,
                                  meetingId: widget.meetingDetail!.id),
                            ));
                      }
                    },
                    child: const Text('Join'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
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
