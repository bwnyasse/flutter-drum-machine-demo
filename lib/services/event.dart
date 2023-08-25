import 'package:flutter_drum_machine_demo/services/sampler.dart';
import 'package:flutter_drum_machine_demo/services/state.dart';

class Event {
  const Event();
}

class TickEvent extends Event {}

class ControlEvent extends Event {
  const ControlEvent(this.state);
  final ControlState state;
}

class PadEvent extends Event {
  const PadEvent(this.sample);
  final DrumSample sample;
}

class EditEvent extends Event {
  const EditEvent(this.sample, this.position);
  final DrumSample sample;
  final int position;
}