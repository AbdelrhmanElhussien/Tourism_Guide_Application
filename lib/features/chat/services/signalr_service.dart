import 'dart:convert';

import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'dart:async';
import 'package:tourist_app/core/utils/cache_helper.dart';
import 'package:tourist_app/features/chat/data/models/chat_message_model.dart';

class SignalRService {
  HubConnection? _connection;
  final _messageStreamController =
      StreamController<ChatMessageModel>.broadcast();
  final _connectionStateStreamController =
      StreamController<HubConnectionState>.broadcast();

  Stream<ChatMessageModel> get messageStream => _messageStreamController.stream;
  Stream<HubConnectionState> get connectionStateStream =>
      _connectionStateStreamController.stream;

  HubConnectionState get currentState =>
      _connection?.state ?? HubConnectionState.Disconnected;

  Future<void> connect() async {
    if (_connection != null &&
        _connection!.state != HubConnectionState.Disconnected) {
      print(
        'SignalR: Already connected or connecting (State: ${_connection!.state})',
      );
      return;
    }

    const hubUrl = 'https://tourismapi.runasp.net/hubs/chat';

    final httpOptions = HttpConnectionOptions(
      accessTokenFactory: () async {
        final token = CacheHelper.getData(key: 'token') as String?;
        print('accessTokenFactory token length: ${token?.length ?? 0}');
        return token ?? '';
      },
    );

    _connection = HubConnectionBuilder()
        .withUrl(hubUrl, options: httpOptions)
        .withAutomaticReconnect()
        .build();

    // Set up state change listeners
    _connection!.onclose(({error}) {
      print('SignalR: Connection closed. Error: $error');
      _connectionStateStreamController.add(HubConnectionState.Disconnected);
    });

    _connection!.onreconnecting(({error}) {
      print('SignalR: Reconnecting. Error: $error');
      _connectionStateStreamController.add(HubConnectionState.Reconnecting);
    });

    _connection!.onreconnected(({connectionId}) {
      print('SignalR: Reconnected. Connection ID: $connectionId');
      _connectionStateStreamController.add(HubConnectionState.Connected);
    });

    // Listen to ReceiveMessage event
    _connection!.on('ReceiveMessage', (List<Object?>? arguments) {
      print('SignalR: Received ReceiveMessage with args: $arguments');
      if (arguments == null || arguments.isEmpty) return;

      try {
        ChatMessageModel messageModel;

        // Handle different formats: [senderId, messageText], [messageText, senderId] or a single JSON object/string
        if (arguments.length >= 2) {
          final arg0 = arguments[0]?.toString() ?? '';
          final arg1 = arguments[1]?.toString() ?? '';

          final guidRegex = RegExp(
            r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
          );
          String senderId = '';
          String text = '';

          if (guidRegex.hasMatch(arg0)) {
            senderId = arg0;
            text = arg1;
          } else if (guidRegex.hasMatch(arg1)) {
            senderId = arg1;
            text = arg0;
          } else {
            // Fallback: assume arg0 is senderId and arg1 is text
            senderId = arg0;
            text = arg1;
          }

          messageModel = ChatMessageModel(
            text: text,
            sentAt: DateTime.now(),
            senderId: senderId,
          );
        } else if (arguments.length == 1) {
          final arg = arguments[0];
          if (arg is Map<String, dynamic>) {
            messageModel = ChatMessageModel.fromJson(arg);
          } else if (arg is String) {
            try {
              final decoded = jsonDecode(arg);
              if (decoded is Map<String, dynamic>) {
                messageModel = ChatMessageModel.fromJson(decoded);
              } else {
                messageModel = ChatMessageModel(
                  text: arg,
                  sentAt: DateTime.now(),
                  senderId: '',
                );
              }
            } catch (_) {
              messageModel = ChatMessageModel(
                text: arg,
                sentAt: DateTime.now(),
                senderId: '',
              );
            }
          } else {
            messageModel = ChatMessageModel(
              text: arg?.toString() ?? '',
              sentAt: DateTime.now(),
              senderId: '',
            );
          }
        } else {
          return;
        }

        _messageStreamController.add(messageModel);
      } catch (e) {
        print('SignalR: Error parsing received message: $e');
      }
    });

    try {
      print('SignalR: Starting connection...');
      _connectionStateStreamController.add(HubConnectionState.Connecting);
      await _connection!.start();
      print('SignalR Connected');
      print('Connection State: ${_connection?.state}');
      print('Connection Id: ${_connection?.connectionId}');
      _connectionStateStreamController.add(HubConnectionState.Connected);
    } catch (e, stackTrace) {
      print('SignalR: Error starting connection: $e');
      print('Stack Trace: $stackTrace');
      _connectionStateStreamController.add(HubConnectionState.Disconnected);
      rethrow;
    }
  }

  Future<void> sendMessage(
    String targetUserId,
    String message, {
    String? conversationKey,
  }) async {
    if (_connection == null ||
        _connection!.state != HubConnectionState.Connected) {
      throw Exception('SignalR is not connected. Current state: $currentState');
    }

    try {
      print('Before invoke');
      print('Target User Id: $targetUserId');
      print('Message: $message');
      print('Conversation Key: $conversationKey');
      final List<Object> argsList = [
        targetUserId,
        {'text': message},
      ];
      if (conversationKey != null) {
        argsList.add(conversationKey);
      }

      await _connection!.invoke(
        'SendMessageToUser',
        args: argsList,
      );
      print('After invoke');
    } catch (e, stackTrace) {
      print('SignalR: Error sending message: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> disconnect() async {
    if (_connection != null &&
        _connection!.state != HubConnectionState.Disconnected) {
      print('SignalR: Disconnecting...');
      await _connection!.stop();
      _connectionStateStreamController.add(HubConnectionState.Disconnected);
    }
  }

  void dispose() {
    disconnect();
    _messageStreamController.close();
    _connectionStateStreamController.close();
  }
}
