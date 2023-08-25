import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

enum DrumSample { kick, snare, hat, tom1, tom2, crash }

abstract class Sampler {
  static const String _ext = '.wav';

  static Map<DrumSample, String> samples = const {
    DrumSample.kick: 'kick',
    DrumSample.snare: 'snare',
    DrumSample.hat: 'hat',
    DrumSample.tom1: 'tom1',
    DrumSample.tom2: 'tom2',
    DrumSample.crash: 'crash'
  };

  static List<Color> colors = [
    Colors.red,
    Colors.amber,
    Colors.purple,
    Colors.blue,
    Colors.cyan,
    Colors.pink,
  ];

  static final List<String> _files = List.generate(
      samples.length, (i) => samples[DrumSample.values[i]]! + _ext);

  static final _cache = AudioCache();
  static final _player = AudioPlayer();
  static Future<void> init() => _cache.loadAll(_files);

  static Future<void> play(DrumSample sample) async {
    Uri fetchToMemory = await _cache.fetchToMemory('${samples[sample]!}$_ext');
    return _player.play(
      UrlSource(fetchToMemory.toFilePath()),
      mode: PlayerMode.lowLatency,
    );
  }
}
