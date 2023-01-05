import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_wrapper/flutter_webrtc_wrapper.dart';
import 'package:text_webrtc/test_directory/models/meeting_detail.dart';
import 'package:text_webrtc/test_directory/utils/user_utils.dart';
import 'package:text_webrtc/test_directory/widgets/control_panel.dart';
import 'package:text_webrtc/test_directory/widgets/remote_connection.dart';

class MeetingPage extends StatefulWidget {
  final String? meetingId;
  final String? name;
  final MeetingDetail meetingDetail;

  const MeetingPage(
      {Key? key, this.meetingId, this.name, required this.meetingDetail})
      : super(key: key);

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  final _localRender = RTCVideoRenderer();
  final Map<String, dynamic> mediaConstraints = {'audio': true, 'video': true};
  bool isConnectionField = false;
  WebRTCMeetingHelper? meetingHelper;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: _buildMeetingRoom(),
      bottomNavigationBar: ControlPanel(
        onAudioToggle: onAudioToggle,
        onVideoToggle: onVideoToggle,
        videoEnabled: isVideoEnabled(),
        audioEnabled: isAudioEnabled(),
        isConnectionField: isConnectionField,
        onReconnect: handleReconnect,
        onMeetingEnd: onMeetingEnd,
      ),
    );
  }

  _buildMeetingRoom() {
    print('============ ${meetingHelper} =============== ');
    print('========///==== ${meetingHelper!.connections} =========///====== ');
    return Stack(
      children: [
        meetingHelper != null && meetingHelper!.connections.isNotEmpty
            ? GridView.count(
                crossAxisCount: meetingHelper!.connections.length < 3 ? 1 : 2,
                children: List.generate(
                  meetingHelper!.connections.length,
                  (index) {
                    return Padding(
                      padding: EdgeInsets.all(2),
                      child: RemoteConnection(
                          renderer: meetingHelper!.connections[index].renderer,
                          connection: meetingHelper!.connections[index]),
                    );
                  },
                ),
              )
            : const Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'waiting for participants to join the meeting',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 24),
                  ),
                ),
              ),
        Positioned(
          bottom: 10,
          right: 0,
          child: SizedBox(
            width: 150,
            height: 200,
            child: RTCVideoView(_localRender),
          ),
        )
      ],
    );
  }

  void startMeeting() async {
    final String userId = await loadUserId();
    print('////////////${widget.meetingDetail.id}//////////////');
    print('///${userId}////');
    print('//${widget.name}//');
    meetingHelper = WebRTCMeetingHelper(
        url: 'http://192.168.1.105:4000',
        meetingId: widget.meetingDetail.id,
        userId: userId,
        name: widget.name);
    MediaStream _localStream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _localRender.srcObject = _localStream;
    meetingHelper!.stream = _localStream;

    meetingHelper!.on('open', context, (ev, context) {
      setState(() {
        isConnectionField = false;
      });
    });
    meetingHelper!.on('connection', context, (ev, context) {
      setState(() {
        isConnectionField = false;
      });
    });
    meetingHelper!.on('user-left', context, (ev, context) {
      setState(() {
        isConnectionField = false;
      });
    });

    meetingHelper!.on('video-toggle', context, (ev, context) {
      setState(() {});
    });

    meetingHelper!.on('audio-toggle', context, (ev, context) {
      setState(() {});
    });

    meetingHelper!.on('meeting-ended', context, (ev, context) {
      onMeetingEnd();
    });

    meetingHelper!.on('connection-setting-changed', context, (ev, context) {
      setState(() {
        isConnectionField = false;
      });
    });

    meetingHelper!.on('stream-changed', context, (ev, context) {
      setState(() {
        isConnectionField = false;
      });
    });
    setState(() {});
  }

  initRenderers() async {
    await _localRender.initialize();
  }

  @override
  void initState() {
    super.initState();
    initRenderers();
    startMeeting();
  }

  @override
  void deactivate() {
    super.deactivate();
    _localRender.dispose();
    if (meetingHelper != null) {
      meetingHelper!.destroy();
      meetingHelper = null;
      goToHomePage();
    }
  }

  void onMeetingEnd() {
    if (meetingHelper != null) {
      meetingHelper!.endMeeting();
      meetingHelper = null;
    }
  }

  void onAudioToggle() {
    if (meetingHelper != null) {
      setState(() {
        meetingHelper!.toggleAudio();
      });
    }
  }

  void onVideoToggle() {
    if (meetingHelper != null) {
      setState(() {
        meetingHelper!.toggleVideo();
      });
    }
  }

  bool isVideoEnabled() {
    return meetingHelper != null ? meetingHelper!.videoEnabled! : false;
  }

  bool isAudioEnabled() {
    return meetingHelper != null ? meetingHelper!.audioEnabled! : false;
  }

  void handleReconnect() {
    if (meetingHelper != null) {
      meetingHelper!.reconnect();
    }
  }

  void goToHomePage() {
    Navigator.pop(context);
  }
}
