import 'dart:async';
import '../utils/settings.dart';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

const appId = AppId;
const token = Token;
const channel = "fluttermap";

class VideoCall extends StatefulWidget {
  const VideoCall({super.key});

  @override
  State<VideoCall> createState() => _MyAppState();
}

class _MyAppState extends State<VideoCall> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool _muted = false;
  final bool _canSwitchCamera = false;

  // Local video position
  Offset _localVideoPosition =
      const Offset(20, 50); // Initial position of local video

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    // Request microphone and camera permissions
    await [Permission.microphone, Permission.camera].request();

    // Create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      const RtcEngineContext(
          appId: appId,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting),
    );

    // Check if more than one camera is available

    // Register event handlers
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    // Join the channel
    await _engine.joinChannel(
      token: token,
      channelId: channel,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  // Toggle mute state
  void _onToggleMute() {
    setState(() {
      _muted = !_muted;
    });
    _engine.muteLocalAudioStream(_muted);
  }

  // Switch the camera
  void _onSwitchCamera() {
    if (_canSwitchCamera) {
      _engine.switchCamera();
    }
  }

  // Leave the channel
  void _onLeaveChannel() async {
    await _engine.leaveChannel();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
      ),
      body: Stack(
        children: [
          Center(
            child: _remoteVideo(),
          ),
          _draggableLocalVideo(), // Draggable local video
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _onToggleMute,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: _muted ? Colors.red : Colors.blue,
                      padding: const EdgeInsets.all(20),
                    ),
                    child: Icon(
                      _muted ? Icons.mic_off : Icons.mic,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _canSwitchCamera ? _onSwitchCamera : null,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor:
                          _canSwitchCamera ? Colors.blue : Colors.grey,
                      padding: const EdgeInsets.all(20),
                    ),
                    child: const Icon(
                      Icons.switch_camera,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _onLeaveChannel,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.all(20),
                    ),
                    child: const Icon(
                      Icons.call_end,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20), // Add border radius
        child: AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: _engine,
            canvas: VideoCanvas(uid: _remoteUid),
            connection: const RtcConnection(channelId: channel),
          ),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }

  // Draggable local video
  Widget _draggableLocalVideo() {
    return Positioned(
      left: _localVideoPosition.dx,
      top: _localVideoPosition.dy,
      child: Draggable(
        feedback: _localVideoWidget(),
        childWhenDragging: Container(), // Empty when dragging
        onDragEnd: (dragDetails) {
          setState(() {
            _localVideoPosition = dragDetails.offset;
          });
        },
        child: _localVideoWidget(),
      ),
    );
  }

  // Local video widget with border radius
  Widget _localVideoWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20), // Add border radius
      child: SizedBox(
        width: 100,
        height: 150,
        child: Center(
          child: _localUserJoined
              ? AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: _engine,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
