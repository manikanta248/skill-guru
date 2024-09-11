import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import './call.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final _channelController = TextEditingController();
  bool _validateError = false;
  ClientRoleType? _role = ClientRoleType.clientRoleBroadcaster; // Updated class

  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _channelController,
              decoration: InputDecoration(
                errorText: _validateError ? 'channel name is mandatory' : null,
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(width: 1),
                ),
                hintText: 'channel name',
              ),
            ),
            RadioListTile<ClientRoleType>(
              title: const Text('Broadcaster'),
              onChanged: (ClientRoleType? value) {
                setState(() {
                  _role = value;
                });
              },
              value: ClientRoleType.clientRoleBroadcaster, // Updated value
              groupValue: _role,
            ),
            RadioListTile<ClientRoleType>(
              title: const Text('Audience'),
              onChanged: (ClientRoleType? value) {
                setState(() {
                  _role = value;
                });
              },
              value: ClientRoleType.clientRoleAudience, // Updated value
              groupValue: _role,
            ),
            ElevatedButton(
                onPressed: onJoin,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                ),
                child: const Text('Join')),
          ],
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (_channelController.text.isNotEmpty) {
      await handleCameraAndMic(Permission.camera);
      await handleCameraAndMic(Permission.microphone);
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CallPage(
                    channelName: _channelController.text,
                  )));
    }
  }

  Future<void> handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    log(status.toString());
  }
}
