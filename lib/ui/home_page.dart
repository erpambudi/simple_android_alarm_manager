import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:simple_android_alarm_manager/utils/background_service.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BackgroundService _service = BackgroundService();

  @override
  void initState() {
    super.initState();
    port.listen((_) async => await _service.someTask());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RaisedButton(
              child: Text(
                'Alarm with Delayed (Once)',
              ),
              onPressed: () async {
                ///Gunanya untuk menjalankan proses di background hanya sekali saja.
                ///Fungsi ini akan dijalankan ketika proses delay selama 5 detik sudah berakhir.
                ///1 merupakan Id pada fungsi yang sedang dijalankan
                await AndroidAlarmManager.oneShot(
                  Duration(seconds: 5),
                  1,
                  BackgroundService.callback,
                  exact: true,
                  wakeup: true,
                );
              },
            ),
            SizedBox(height: 20),
            RaisedButton(
              child: Text(
                'Alarm with Date Time (Once)',
              ),
              onPressed: () async {
                ///Gunanya untuk menjalankan proses di background secara terjadwal.
                ///Kita bisa mengatur kapan akan menjalankan proses di background dengan menambahkan inputan tanggal dan waktu.
                await AndroidAlarmManager.oneShotAt(
                  DateTime.now().add(Duration(seconds: 5)),
                  2,
                  BackgroundService.callback,
                  exact: true,
                  wakeup: true,
                );
              },
            ),
            SizedBox(height: 20),
            RaisedButton(
              child: Text(
                'Alarm with Periodic',
              ),
              onPressed: () async {
                ///Gunanya untuk menjalankan proses di background secara berkala.
                ///startAt berfungsi untuk kapan sebuah proses akan mulai dijalankan
                ///ketika fungsi periodic pertama kali dijalankan
                ///dan selanjutnya akan dijalankan berulang berdasarkan nilai dari parameter duration.
                ///(akan dijalankan berulang (kira-kira) setiap menitnya)
                await AndroidAlarmManager.periodic(
                  Duration(minutes: 1),
                  3,
                  BackgroundService.callback,
                  startAt: DateTime.now(),
                  exact: true,
                  wakeup: true,
                );
              },
            ),
            SizedBox(height: 20),
            RaisedButton(
              child: Text(
                'Cancel Alarm by Id',
              ),
              onPressed: () async {
                ///Terakhir, fungsi ini digunakan untuk membatalkan proses di background
                ///dengan menginputkan ID dari masing-masing proses tersebut.
                await AndroidAlarmManager.cancel(3);
              },
            ),
          ],
        ),
      ),
    );
  }
}
