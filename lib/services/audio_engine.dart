import 'dart:async';

import 'package:flutter_drum_machine_demo/services/event.dart';
import 'package:flutter_drum_machine_demo/services/sampler.dart';
import 'package:flutter_drum_machine_demo/services/state.dart';

class Signal {}

abstract class AudioEngine {
  // Each pattern has eight steps
  static const int _resolution = 8;
  static int step = 0;

  // Engine control current state
  static ControlState _state = ControlState.ready;
  static get state => _state;

  // Beats per minute
  static int _bpm = 120;
  static int get bpm => _bpm;
  static set bpm(int x) {
    _bpm = x;
    if (_state != ControlState.ready) {
      synchronize();
    }
    _signal.add(Signal());
  }

  // Generates a new blank track data structure
  static Map<DrumSample, List<bool>> get _blanktape =>
      {for (var k in DrumSample.values) k: List.generate(8, (i) => false)};

  // Track note on/off data
  static Map<DrumSample, List<bool>> _trackdata = _blanktape;
  static Map<DrumSample, List<bool>> get trackdata => _trackdata;

  // Timer tick duration
  static Duration get _tick =>
      Duration(milliseconds: (60000 / bpm / 2).round());
  static Stopwatch _watch = Stopwatch();
  static Timer _timer = Timer.periodic(_tick, (t) => on<TickEvent>(TickEvent()));

  // Outbound signal driver - allows widgets to listen for signals from audio engine
  static StreamController<Signal> _signal =
      StreamController<Signal>.broadcast();
  static Future<void> close() =>
      _signal.close(); // Not used but required by SDK
  static StreamSubscription<Signal> listen(Function(Signal) onData) =>
      _signal.stream.listen(onData);

  // Incoming event handler
  static void on<T extends Event>(Event event) {
    switch (T) {
      case PadEvent:
        if (state == ControlState.record) {
          return processInput(event as PadEvent);
        }
        Sampler.play((event as PadEvent).sample);
        return;

      case TickEvent:
        if (state == ControlState.ready) {
          return;
        }
        return next();

      case EditEvent:
        return edit(event as EditEvent);

      case ControlEvent:
        return control(event as ControlEvent);
    }
  }

  // Controller state change handler
  static control(ControlEvent event) {
    switch (event.state) {
      case ControlState.play:
      case ControlState.record:
        if (state == ControlState.ready) {
          start();
        }
        break;

      case ControlState.ready:
      default:
        reset();
    }

    _state = event.state;
    _signal.add(Signal());
  }

  // Note block edit event handler
  static void edit(EditEvent event) {
    trackdata[event.sample]![event.position] =
        !trackdata[event.sample]![event.position];
    if (trackdata[event.sample]![event.position]) {
      Sampler.play(event.sample);
    }
    _signal.add(Signal());
  }

  // Quantize input using the stopwatch
  static void processInput(PadEvent event) {
    int position = (_watch.elapsedMilliseconds < 900)
        ? step
        : (step != 7)
            ? step + 1
            : 0;
    edit(EditEvent(event.sample, position));
  }

  // Reset the engine
  static void reset() {
    step = 0;
    _watch.reset();
    _timer.cancel();
  }

  // Start the sequencer
  static void start() {
    reset();
    _watch.start();
    _timer = Timer.periodic(_tick, (t) => on<TickEvent>(TickEvent()));
  }

  // Process the next step
  static void next() {
    step = (step == 7) ? 0 : step + 1;
    _watch.reset();

    trackdata.forEach((DrumSample sample, List<bool> track) {
      if (track[step]) {
        Sampler.play(sample);
      }
    });

    _watch.start();
    _signal.add(Signal());
  }

  static void synchronize() {
    _watch.stop();
    _timer.cancel();

    _watch.start();
    _timer = Timer.periodic(_tick, (t) => on<TickEvent>(TickEvent()));
  }
}
