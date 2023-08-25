import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_drum_machine_demo/services/audio_engine.dart';

class BaseWidget extends StatefulWidget {
  const BaseWidget({super.key});

  @override
  BaseState createState() => BaseState();
}

class BaseState<T extends BaseWidget> extends State<T> {
  late StreamSubscription<Signal> _stream;

  void on<Signal>(Signal s) => setState(() => null);

  @override
  void initState() {
    _stream = AudioEngine.listen(on);
    super.initState();
  }

  @override
  void dispose() {
    if (_stream != null) {
      _stream.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container();
}
