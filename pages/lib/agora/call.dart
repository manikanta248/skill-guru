import 'package:flutter/material.dart';

class CallPage extends StatefulWidget {
  final String? channelName;
  final ClientRole;

  const CallPage({super.key, this.channelName, this.ClientRole});

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agore'),
        centerTitle: true,
      ),
    );
  }
}
