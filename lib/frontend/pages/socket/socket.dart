import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:colorify/backend/providers/socket.prov.dart';
import 'package:colorify/backend/utils/websocket.dart';
import 'package:colorify/frontend/components/websocket/wstile.dart';
import 'package:colorify/frontend/pages/socket/messages.dart';
import 'package:colorify/frontend/pages/socket/process_line_indicator.dart';
import 'package:colorify/ui/basic/xbutton.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SocketPage extends StatefulWidget {
  const SocketPage({super.key});

  @override
  State<SocketPage> createState() => _SocketPageState();
}

class _SocketPageState extends State<SocketPage> {
  @override
  Widget build(BuildContext context) {
    final socketprov = context.watch<Socketprov>();
    final mqs = MediaQuery.of(context).size;

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
                          socketprov.appendLog(v);

                          final json = jsonDecode(v);
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
                color: Colors.black.withOpacity(0.3),
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
        padding: const EdgeInsets.only(top: 20),
        children: [
          Wstile(
            width: mqs.width - 40,
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
            width: mqs.width - 40,
            height: 110,
            title: '进度',
            child: ProcessLineIndicator(
              width: mqs.width - 64,
              height: 40,
              progress: socketprov.progress,
            ),
          ),
          Wstile(
            width: mqs.width - 40,
            height: 300,
            title: '日志（最近20条）',
            child: SocketMessages(
              width: mqs.width - 64,
              height: 240,
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
