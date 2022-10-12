import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/core/constants/api_constants.dart';
import 'package:restaurants/core/logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

typedef EventHandler<T> = dynamic Function(T data);
typedef EventHandlerMap = dynamic Function(Map<String, dynamic> data);

final socketProvider = Provider<SocketIOHandler>((ref) {
  return SocketIOHandlerImpl();
});

abstract class SocketIOHandler {
  Future<void> connect();
  void on(String event, EventHandler callback);
  void onMap(String event, EventHandlerMap callback);
  void onConnect(EventHandler callback);
  void onDisconnect(EventHandler callback);
  void emit(String event, String data);
  void emitMap(String event, Map<String, dynamic> data);
  void disconnect();
  String serealize(Map<String, dynamic> data);
  Map<String, dynamic> deserialize(dynamic data);
}

class SocketIOHandlerImpl implements SocketIOHandler {
  io.Socket? socket;

  @override
  Future<void> connect() async {
    socket = io.io(
      ApiConstants.socketUrl,
      io.OptionBuilder().setTransports(['websocket']).build(),
    );
  }

  @override
  Map<String, dynamic> deserialize(dynamic data) => Map.from(data);

  @override
  String serealize(Map<String, dynamic> data) => json.encode(data);

  @override
  void disconnect() => socket!.disconnect();

  @override
  void emit(String event, String data) => socket!.emit(event, data);

  @override
  void emitMap(String event, Map<String, dynamic> data) {
    Logger.log('####### SOCKET EMITMAP #######');
    Logger.log('Emitting $event with data');
    Logger.log(data.toString());
    Logger.log('####### END SOCKET EMITMAP #######');
    socket!.emit(event, data);
  }

  @override
  void on(String event, EventHandler callback) => socket!.on(event, callback);

  @override
  void onMap(String event, EventHandlerMap callback) {
    socket!.on(event, (data) {
      Logger.log('####### SOCKET ONMAP #######');
      Logger.log('Receiving $event with data');
      Logger.log(data.toString());
      Logger.log('####### END SOCKET ONMAP #######');
      callback(deserialize(data));
    });
  }

  @override
  void onDisconnect(EventHandler callback) {
    socket!.onDisconnect((data) => callback(data));
  }

  @override
  void onConnect(EventHandler callback) {
    socket!.onConnect((data) => callback(data));
  }
}
