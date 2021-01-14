import 'dart:isolate';

import 'dart:ui';

///untuk melakukan komunikasi dari isolasi background ke isolasi UI
final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService _instance;

  ///key yang terkait dengan isolasi UI
  static String _isolateName = 'isolate';

  static SendPort _uiSendPort;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  ///untuk melakukan inisiasi ketika kita akan menjalankan tugas isolate.
  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  ///fungsi callback akan dijalankan ketika aplikasi sedang ditutup, dibuka, dan juga di-minimize
  static Future<void> callback() async {
    print('Alarm fired!');
    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }

  ///fungsi someTask akan dijalankan ketika aplikasi sedang dibuka dan di-minimize saja
  ///Fungsi someTask dijalankan hanya untuk melakukan perubahan terhadap UI.
  Future<void> someTask() async {
    print('Updated data from the background isolate');
  }
}
