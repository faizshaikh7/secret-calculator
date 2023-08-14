import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketClient {
  IO.Socket? socket;
  static SocketClient? _instance;

  SocketClient._internal() {
    socket = IO.io('http://192.168.0.105:3000/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket!.connect();
    socket!.onConnect((_) {
      log('Connection established');
    });

    socket!.onDisconnect((_) => log('Connection Disconnection'));
    socket!.onConnectError((err) => log(err.toString()));
    socket!.onError((err) => log(err.toString()));
  }

  static SocketClient get instance {
    _instance ??= SocketClient._internal();
    return _instance!;
  }
}
