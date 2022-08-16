import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:volume/volume.dart';


class VolumeControlScreen extends StatefulWidget {
  const VolumeControlScreen({Key key}) : super(key: key);

  @override
  State<VolumeControlScreen> createState() => _VolumeControlScreenState();
}

class _VolumeControlScreenState extends State<VolumeControlScreen> {

  AudioManager audioManager;
  int maxVol, currentVol;
  // TODO Initializing an Instance of NetworkInfo
  final info = NetworkInfo();

  @override
  void initState() {
    super.initState();
    audioManager = AudioManager.STREAM_MUSIC;
    initPlatformState();
    updateVolumes();
    getWifiIPAddress();
    refreshList();
  }

  Future<void> initPlatformState() async {
    await Volume.controlVolume(AudioManager.STREAM_MUSIC);
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

  // TODO Get Wifi Ip Address
  void getWifiIPAddress() async{
    int currentSystemVolume = await Volume.getVol;
    var wifi = await info.getWifiIP();
    var wifiName = await info.getWifiName();
    print("Wifi Name is $wifiName");
    print("Wifi Ip Address is $wifi");
    if(wifi == "192.168.100.156"){
      print("Silent My Phone, Reached Office");
      currentSystemVolume = 0;
      await Volume.setVol(currentSystemVolume);

    }else if(wifi != "192.168.100.156"){
      await Volume.setVol(currentSystemVolume);
    }
    else{
      print("Don't silent my phone");
    }
  }

  // TODO Refresh List Function
  Future<void> refreshList() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      getWifiIPAddress();
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        title: const Text(
          'Control System Volume',
          style:
          TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ),
      body: RefreshIndicator(
        child: Center(
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
                onChanged: (AudioManager aM) async {
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
                value: currentVol / 1.0,
                divisions: maxVol,
                max: maxVol / 1.0,
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
        onRefresh: refreshList,
      ),
    );
  }
}
