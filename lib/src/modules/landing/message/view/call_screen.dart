import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

const appId = "a9c58f65d09249ad8a537bd7d0061779"; // Replace with your Agora App ID
const token = "007eJxTYPCO5rlq0XP/1Wu9769NrZfIHF1WaLucP/9gQLbz1IhIdTYFhkTLZFOLNDPTFANLIxPLxBSLRFNj86QU8xQDAzNDc3PLFHbu9IZARoYfYkLMjAysDIwMTAwgPgMDADnCGxA="; // Replace with the Agora token if necessary

class CallScreen extends StatefulWidget {
  final String userId;
  final String otherUserId;
  final bool isVideoCall;

  const CallScreen({
    Key? key,
    required this.userId,
    required this.otherUserId,
    required this.isVideoCall,
  }) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    // Request permissions for microphone and camera
    await [Permission.microphone, Permission.camera].request();

    // Initialize Agora engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
    ));

    // Register event handlers
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("Local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("Remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          debugPrint("Remote user $remoteUid left the channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );

    if (widget.isVideoCall) {
      await _engine.enableVideo();
      await _engine.startPreview();
    }

    // Join the Agora channel
    await _engine.joinChannel(
      token: token,
      channelId: widget.userId + widget.otherUserId, // Unique channel for the two users
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isVideoCall ? 'Video Call' : 'Voice Call'),
      ),
      body: Stack(
        children: [
          widget.isVideoCall
              ? _remoteUid != null
                  ? AgoraVideoView(
                      controller: VideoViewController.remote(
                        rtcEngine: _engine,
                        canvas: VideoCanvas(uid: _remoteUid),
                        connection: RtcConnection(channelId: widget.userId + widget.otherUserId),
                      ),
                    )
                  : const Center(child: Text('Waiting for remote user to join...'))
              : const Center(child: Text('Voice call in progress...')),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: widget.isVideoCall
                  ? _localUserJoined
                      ? AgoraVideoView(
                          controller: VideoViewController(
                            rtcEngine: _engine,
                            canvas: const VideoCanvas(uid: 0), // Local user view
                          ),
                        )
                      : const CircularProgressIndicator()
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
