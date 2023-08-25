import 'package:flutter/material.dart';
import 'package:flutter_drum_machine_demo/services/audio_engine.dart';
import 'package:flutter_drum_machine_demo/services/event.dart';
import 'package:flutter_drum_machine_demo/services/state.dart';
import 'package:flutter_drum_machine_demo/views/base_widget.dart';

class Transport extends BaseWidget {
  const Transport({super.key});

  @override
  TransportState createState() => TransportState();
}

class TransportState extends BaseState<Transport> {
  ControlState get state => AudioEngine.state;

  Map<ControlState, Icon> get _icons => {
        ControlState.ready: Icon(Icons.stop,
            color: (state == ControlState.ready) ? Colors.blue : Colors.white),
        ControlState.play: Icon(Icons.play_arrow,
            color: (state == ControlState.play) ? Colors.green : Colors.white),
        ControlState.record: Icon(Icons.fiber_manual_record,
            color: (state == ControlState.record) ? Colors.red : Colors.white)
      };

  final BoxDecoration _decoration = BoxDecoration(
      color: Colors.black54,
      border:
          Border(bottom: BorderSide(color: Colors.blueGrey.withOpacity(0.6))));

  void onTap(ControlState state) =>
      AudioEngine.on<ControlEvent>(ControlEvent(state));

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: _decoration,
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
            children: List<Widget>.generate(
                ControlState.values.length,
                (i) => Expanded(
                    child: SizedBox.expand(
                        child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: MaterialButton(
                                disabledColor: Colors.black54,
                                onPressed: (state == ControlState.values[i])
                                    ? null
                                    : () => onTap(ControlState.values[i]),
                                child: _icons[ControlState.values[i]])))))));
  }
}
