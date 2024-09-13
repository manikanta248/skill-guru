import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:pages/utils/settings.dart';

class CallPage extends StatefulWidget {
  final String? channelName;
  final ClientRole? role;

  const CallPage({super.key, required this.channelName, required this.role});

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool viewPanel = false;
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    _users.clear();
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  Future<void> initialize() async {
    if (appId.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    _engine = await RtcEngine.create(appId);
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);

    if (widget.role != null) {
      await _engine.setClientRole(widget.role!);
    } else {
      _infoStrings.add('Client role is missing.');
    }

    _addAgoraEventHandler(); // Call the event handler setup method

    // Set video configuration
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = const VideoDimensions(width: 1920, height: 1000);
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel(token, widget.channelName!, null, 0);
    print(widget.channelName);
  }

  void _addAgoraEventHandler() {
    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          setState(() {
            _infoStrings.add('onJoinChannel: $channel, uid: $uid');
          });
        },
        leaveChannel: (RtcStats stats) {
          setState(() {
            _infoStrings.add('onLeaveChannel');
            _users.clear();
          });
        },
        userJoined: (int uid, int elapsed) {
          setState(() {
            _infoStrings.add('userJoined: $uid');
            _users.add(uid);
          });
        },
        userOffline: (int uid, UserOfflineReason reason) {
          setState(() {
            _infoStrings.add('userOffline: $uid');
            _users.remove(uid);
          });
        },
        firstRemoteVideoFrame: (int uid, int width, int height, int elapsed) {
          setState(() {
            final info = 'First Remote Video: $uid ${width}x${height}';
            _infoStrings.add(info);
          });
        },
      ),
    );
  }

  Widget _viewRows() {
    final List<Widget> list = [];
    print('Token: $token');
    print('Channel Name: ${widget.channelName}');

    // Ensure the local video view is added when the role is Broadcaster
    if (widget.role == ClientRole.Broadcaster) {
      list.add(
        Expanded(
          child: rtc_local_view.SurfaceView(),
        ),
      );
    }

    // Add remote video views for users in the channel
    for (var uid in _users) {
      list.add(
        Expanded(
          child: rtc_remote_view.SurfaceView(
            uid: uid,
            channelId: widget.channelName!,
          ),
        ),
      );
    }

    return Column(
      children: list,
    );
  }

  Widget _toolbar() {
    if (widget.role == ClientRole.Audience) return const SizedBox();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(onPressed: () {
            setState(() {
              muted = !muted;
            });
          })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Agora Video Call'), // Placeholder for your video call UI
      ),
    );
  }
}
