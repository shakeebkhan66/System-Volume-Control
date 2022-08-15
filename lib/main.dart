import 'package:flutter/material.dart';
import 'dart:async';

import 'package:volume/volume.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AudioManager? audioManager;
  int? maxVol, currentVol;

  @override
  void initState() {
    super.initState();
    audioManager = AudioManager.STREAM_SYSTEM;
    initPlatformState();
    updateVolumes();
  }

  Future<void> initPlatformState() async {
    await Volume.controlVolume(AudioManager.STREAM_SYSTEM);
  }

  updateVolumes() async {
    // get Max Volume
    maxVol = await Volume.getMaxVol;
    // get Current Volume
    currentVol = await Volume.getVol;
    setState(() {});
  }

  setVol(int i) async {
    await Volume.setVol(i);
  }

  // TODO Increase Volume With Button
  increaseVolume() async {
    int mVol = await Volume.getMaxVol;
    int cVol = await Volume.getVol;
    if (cVol <= mVol) {
      cVol = cVol + 1;
    }
    await Volume.setVol(cVol);
  }

  // TODO Decrease Volume With Button
  decreaseVolume() async {
    int cVol = await Volume.getVol;
    if (cVol > 0) {
      cVol = cVol - 1;
    }
    await Volume.setVol(cVol);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[200],
          title: const Text(
            'Control System Volume',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20,),
              DropdownButton(
                value: audioManager,
                items: const [
                  DropdownMenuItem(
                    child: Text("In Call Volume"),
                    value: AudioManager.STREAM_VOICE_CALL,
                  ),
                  DropdownMenuItem(
                    child: Text("System Volume"),
                    value: AudioManager.STREAM_SYSTEM,
                  ),
                  DropdownMenuItem(
                    child: Text("Ring Volume"),
                    value: AudioManager.STREAM_RING,
                  ),
                  DropdownMenuItem(
                    child: Text("Media Volume"),
                    value: AudioManager.STREAM_MUSIC,
                  ),
                  DropdownMenuItem(
                    child: Text("Alarm volume"),
                    value: AudioManager.STREAM_ALARM,
                  ),
                  DropdownMenuItem(
                    child: Text("Notifications Volume"),
                    value: AudioManager.STREAM_NOTIFICATION,
                  ),
                ],
                isDense: true,
                onChanged: (AudioManager? aM) async {
                  print(aM.toString());
                  setState(() {
                    audioManager = aM;
                  });
                  await Volume.controlVolume(aM);
                },
              ),
              (currentVol != null || maxVol != null)
                  ? Slider(
                      activeColor: Colors.green[200],
                      value: currentVol! / 1.0,
                      divisions: maxVol,
                      max: maxVol! / 1.0,
                      min: 0,
                      onChanged: (double d) {
                        setVol(d.toInt());
                        updateVolumes();
                      },
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: Colors.green[200],
                      child: const Text(
                        "Vol Up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        increaseVolume();
                        updateVolumes();
                      },
                    ),
                    MaterialButton(
                      color: Colors.red[200],
                      child: const Text(
                        "Vol Down",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        decreaseVolume();
                        updateVolumes();
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
