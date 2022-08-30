import 'dart:convert';
import 'package:restaurants/core/external/socket_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/core/constants/db_constants.dart';
import 'package:restaurants/core/external/api_handler.dart';
import 'package:restaurants/core/external/api_response.dart';
import 'package:restaurants/core/external/db_handler.dart';

class OnBoarding extends ConsumerStatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  static const route = '/';

  @override
  createState() => _OnBoardingState();
}

class _OnBoardingState extends ConsumerState<OnBoarding> {
  ApiResponse? response;
  String? token;

  @override
  void initState() {
    super.initState();
    socketInit();
  }

  // Future<void> socketInit() async {
  //   print('Starting socket');
  //   final socket = io.io(
  //     ApiConstants.baseUrl,
  //     io.OptionBuilder().setTransports(['websocket']).build(),
  //   );
  //   socket.connect();
  //   socket.onConnect((_) {
  //     print('connect');
  //     socket.emit('msg', 'test');
  //   });
  //   socket.on('event', (data) => print(data));

  //   socket.onDisconnect((_) => print('disconnect'));
  //   socket.on('fromServer', (_) => print(_));
  //   socket.emit('join_to_restaurant_table', json.encode({"table_id": "1234"}));
  //   socket.on('new_user_joined', (data) => print(data));
  // }

  void socketInit() {
    final socket = ref.read(socketProvider);
    socket.connect();
    socket.onConnect((_) {
      print('connect');
      socket.emit('msg', 'test');
    });
    socket.onMap('new_user_joined', (data) => print(data));
    socket.onDisconnect((_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));
    socket.emit('join_to_restaurant_table', json.encode({"table_id": "1234"}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OnBoarding'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              response = await ref
                  .read(apiHandlerProvider)
                  .post('/api/auth/login', {"email": "test@test.com", "password": "3213123123"});
              print(response?.responseMap.toString());
              setState(() {});
            },
            child: const Text('Make petition'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(dbProvider).put(
                    DbConstants.authBox,
                    response?.responseMap?['token'] ?? '',
                    DbConstants.bearerTokenKey,
                  );
            },
            child: const Text('Save token'),
          ),
          ElevatedButton(
            onPressed: () async {
              token =
                  await ref.read(dbProvider).get(DbConstants.authBox, DbConstants.bearerTokenKey);
              setState(() {});
            },
            child: const Text('Get token'),
          ),
          if (token != null) Text(token!),
        ],
      ),
    );
  }
}
