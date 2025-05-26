import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:colorify/backend/providers/socket.prov.dart';
import 'package:colorify/backend/utils/minecraft/websocket.dart';
import 'package:colorify/frontend/components/websocket/wstile.dart';
import 'package:colorify/frontend/pages/socket/messages.dart';
import 'package:colorify/frontend/pages/socket/process_line_indicator.dart';
import 'package:colorify/ui/basic/xbutton.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SocketPage extends StatefulWidget {
  const SocketPage({super.key});

  @override
  State<SocketPage> createState() => _SocketPageState();
}

class _SocketPageState extends State<SocketPage> {
  @override
  Widget build(BuildContext context) {
    final socketprov = context.watch<Socketprov>();

    if (socketprov.unactivated || socketprov.activating) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              socketprov.unactivated ? '服务器未启动' : '启动中...',
              style: getStyle(
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (_, __) {
                if (socketprov.unactivated) {
                  return XButton(
                    width: 140,
                    height: 50,
                    backgroundColor: const Color(0xFF2d2a31),
                    hoverColor: const Color(0xFF2d2a31),
                    padding: const EdgeInsets.all(12),
                    onTap: () async {
                      socketprov.updateState(WebSocketState.activating);
                      WebSocket().initCallbacks(
                        onJoin: (v) {
                          socketprov.updateState(WebSocketState.connected);
                        },
                        onMessage: (v) {
                          final json = jsonDecode(v);

                          final statusCode = json['body']['statusCode'] as int;

                          if (statusCode == 0) {
                            socketprov.appendLog(v);
                          } else {
                            socketprov.appendLog(v, logHead: 'ERROR');
                          }

                          if (json['body']['position'] != null) {
                            final value = json['body']['position'];
                            socketprov.recordExeLoc(
                              [
                                value['x'],
                                value['y'],
                                value['z'],
                              ],
                            );
                          }
                        },
                        onDone: () {},
                        onError: () {},
                      );
                      await WebSocket().launch();
                      socketprov.updateState(WebSocketState.unconnected);
                    },
                    child: Center(
                      child: AutoSizeText(
                        '启动',
                        style: getStyle(
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      );
    } else if (socketprov.unconnected) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '服务器正在运行',
              style: getStyle(
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '等待设备连接',
              style: getStyle(
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '在 Minecraft 中使用',
              style: getStyle(
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(77),
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.all(12),
              child: SelectableText(
                '/connect 127.0.0.1:8080',
                style: getStyle(
                  color: Colors.grey,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '命令来连接',
              style: getStyle(
                color: Colors.white,
                size: 22,
              ),
            ),
          ],
        ),
      );
    } else if (socketprov.connected || socketprov.pausing) {
      return ListView(
        padding: const EdgeInsets.all(0),
        children: [
          Container(
            width: 100.w - 40,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text(
              'Tip: 在使用此功能时请在游戏设置 -> 通用\n开启此选项: 已启用WebSocket\n关闭此选项: 需要加密的WebSocket',
              style: getStyle(
                color: Colors.grey,
                size: 16,
              ),
            ),
          ),
          Wstile(
            width: 100.w - 40,
            height: 110,
            title: '速度',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  socketprov.speed.toString(),
                  style: getStyle(
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                Text(
                  'bps (block per second)',
                  style: getStyle(
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          Wstile(
            width: 100.w - 40,
            height: 110,
            title: '进度',
            child: ProcessLineIndicator(
              width: 100.w - 64,
              height: 40,
              progress: socketprov.progress,
            ),
          ),
          Wstile(
            width: 100.w - 40,
            height: 400,
            title: '日志（最近20条）',
            child: SocketMessages(
              width: 100.w - 64,
              height: 340,
              logs: socketprov.logs,
            ),
          ),
          LayoutBuilder(
            builder: (_, __) {
              if (socketprov.onTask || socketprov.pausing) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    XButton(
                      width: 140,
                      height: 50,
                      backgroundColor: const Color(0xFF2d2a31),
                      hoverColor: const Color(0xFF2d2a31),
                      onTap: () {
                        if (socketprov.connected) {
                          socketprov.stopTask();
                        } else {
                          socketprov.continueTask();
                        }
                      },
                      child: Center(
                        child: AutoSizeText(
                          socketprov.connected ? '暂停' : '继续',
                          style: getStyle(
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Visibility(
                      visible: socketprov.pausing,
                      child: Row(
                        children: [
                          XButton(
                            width: 140,
                            height: 50,
                            backgroundColor: const Color(0xFF2d2a31),
                            hoverColor: const Color(0xFF2d2a31),
                            onTap: () {
                              socketprov.killTask();
                            },
                            child: Center(
                              child: AutoSizeText(
                                '终止此任务',
                                style: getStyle(
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          const SizedBox(height: 300),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}
