import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_drum_machine_demo/services/sampler.dart';
import 'package:flutter_drum_machine_demo/views/display.dart';
import 'package:flutter_drum_machine_demo/views/pad_bank.dart';
import 'package:flutter_drum_machine_demo/views/sequencer.dart';
import 'package:flutter_drum_machine_demo/views/transport.dart';

void main() async {

	WidgetsFlutterBinding.ensureInitialized();
	SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

	await Sampler.init();
	runApp(Game());
}

class Game extends StatelessWidget {

	final String _title = "Flutter Beat Machine Demo";

  const Game({super.key});

	@override
	Widget build(BuildContext context) {

		return MaterialApp(
			debugShowCheckedModeBanner: false,
			title: _title,
			theme: ThemeData.dark(),
			home: Scaffold(
				appBar: AppBar(title: Center(child: Text(_title))),
				body: Column(
					mainAxisAlignment: MainAxisAlignment.spaceBetween,
					children: [
						Display(),
						Sequencer(),
						Transport(),
						PadBank()
					]
				),
			)
		);
	}
}
