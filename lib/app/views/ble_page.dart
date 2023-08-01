import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

class FileSharingScreen extends StatefulWidget {
  @override
  _FileSharingScreenState createState() => _FileSharingScreenState();
}

class _FileSharingScreenState extends State<FileSharingScreen> {
  final _ble = FlutterReactiveBle();
  StreamSubscription<DiscoveredDevice>? scanStream;

  void requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();
    // İzinleri kontrol edin ve uygun işlemi yapın
  }

  String _receivedData = '';

  @override
  void initState() {
    super.initState();
    requestPermissions();
    _startListening();
  }

  @override
  void dispose() {
    super.dispose();
    scanStream?.cancel();
  }

  _getConnectedDevices() async {
    _ble.connectedDeviceStream.listen((event) {
      debugPrint("connected devices = ${event.connectionState.toString()}");
    });
  }

  sendFile() async {
    _ble.writeCharacteristicWithoutResponse(
        QualifiedCharacteristic(
          characteristicId: Uuid([2,3,4,5]),
          serviceId: Uuid([1,2,3,4]),
          deviceId: "4D:82:A9:1B:DB:F6",
        ),
        value: [5, 5, 1, 2, 3, 5]);
  }

  _startListening() async {
    // Reklamın başlaması ve cihazdan veri alınması
    _ble.statusStream.listen((status) {
      print("bluetoooth status = ${status}");
      if (status == BleStatus.ready) {
        debugPrint("readyy");
      }
    });

    _ble.connectedDeviceStream.listen((event) {
      debugPrint("event = ${event.deviceId}");
      debugPrint("event = ${event.toString()}");
    });
    _getConnectedDevices();
    sendFile();

    scanStream = _ble.scanForDevices(
      withServices: [],
      // Örnek servis UUID'si,
      requireLocationServicesEnabled: false,
      scanMode: ScanMode.lowPower,
    ).listen((scanData) {
      if (scanData.connectable == Connectable.available) {
        debugPrint("scandata name= ${scanData.toString()}");
        debugPrint("scandata id= ${scanData.id}");
        debugPrint("scandata serviceData= ${scanData.serviceData}");
      }
      //_connectToDevice(scanData.id);
    });
  }

  _connectToDevice(String peripheralId) async {
    final device = await _ble.connectToDevice(id: peripheralId).first;
    // Cihaza bağlandıktan sonra veri gönderme ve alınması işlemleri burada yapılır.
    // Veri alımı için subscription oluşturabilir ve setState kullanarak _receivedData'ya atayabilirsiniz.
    // Veri göndermek için device.writeCharacteristic() veya benzeri bir işlev kullanılabilir.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Sharing'),
      ),
      body: Center(
        child: Text('Received Data: $_receivedData'),
      ),
    );
  }
}
