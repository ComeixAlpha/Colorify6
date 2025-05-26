import 'dart:async';

import 'package:colorify/backend/extensions/on_double.dart';
import 'package:colorify/backend/providers/progress.prov.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

enum ProgressState {
  born,
  processing,
  success,
  error,
  disappear,
}

class ProgressData {
  String state;
  double progress;

  ProgressData({
    required this.state,
    required this.progress,
  });
}

class ProgressIndicator extends StatefulWidget {
  final void Function() onCallClose;
  const ProgressIndicator({
    super.key,
    required this.onCallClose,
  });

  @override
  State<ProgressIndicator> createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator> {
  ProgressState _state = ProgressState.born;

  bool get _visible => [
        ProgressState.processing,
        ProgressState.success,
        ProgressState.error,
      ].contains(_state);
  bool get _clickable => [
        ProgressState.success,
        ProgressState.error,
      ].contains(_state);

  Widget _getStateToDisplay(BuildContext ctx) {
    if (_state == ProgressState.born || _state == ProgressState.disappear) {
      return const SizedBox();
    } else if (_state == ProgressState.processing) {
      final progress = Provider.of<Progressprov>(context, listen: false);
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LayoutBuilder(
            builder: (_, __) {
              if (progress.progress == 2) {
                return Text(
                  progress.progressState,
                  style: getStyle(color: Colors.white, size: 28),
                );
              } else {
                return Text(
                  '${progress.progressState}\n${progress.progress.toPercentString()}',
                  style: getStyle(color: Colors.white, size: 22),
                );
              }
            },
          ),
          const SizedBox(width: 12.0),
          const Icon(Icons.bolt, color: Colors.white),
        ],
      );
    } else if (_state == ProgressState.success) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '生成完毕\nColorified',
            style: getStyle(color: Colors.white, size: 28),
          ),
          const SizedBox(width: 12.0),
          const Icon(Icons.done_all, color: Color(0xFFC5E1A5)),
        ],
      );
    } else if (_state == ProgressState.error) {
      final progress = Provider.of<Progressprov>(context, listen: false);
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '生成错误',
                style: getStyle(color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12.0),
              const Icon(Icons.error_outline, color: Color(0xFFE57373)),
            ],
          ),
          Text(
            progress.errorString,
            style: getStyle(color: Colors.grey, size: 22),
          ),
        ],
      );
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Born opacity animation
    if (_state == ProgressState.born) {
      Timer(
        const Duration(milliseconds: 10),
        () {
          setState(() {
            _state = ProgressState.processing;
          });
        },
      );
    }

    final progressprov = context.watch<Progressprov>();

    final s = 100.w * 0.8;

    /// Process ends with success
    if (progressprov.success && _state != ProgressState.disappear) {
      setState(() {
        _state = ProgressState.success;
      });
    }

    /// Process exits with error
    if (progressprov.onError && _state != ProgressState.disappear) {
      setState(() {
        _state = ProgressState.error;
      });
    }

    return AnimatedOpacity(
      opacity: !_visible ? 0 : 1,
      duration: const Duration(milliseconds: 240),
      curve: Curves.ease,
      child: GestureDetector(
        onTap: () {
          /// Can close when process ended
          if (_clickable) {
            setState(() {
              _state = ProgressState.disappear;
            });
            Timer(const Duration(milliseconds: 240), () {
              widget.onCallClose();
            });
          }
        },
        child: Container(
          width: 100.w,
          height: 100.h,
          color: Colors.black.withAlpha(51),
          child: Center(
            child: GestureDetector(
              onTap: () {},
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                curve: Curves.ease,
                width: _state == ProgressState.disappear ? 100.w : s,
                height: _state == ProgressState.disappear ? 100.h : s,
                decoration: BoxDecoration(
                  color: const Color(0xFF2d2a31).withAlpha(223),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: SizedBox(
                    width: s - 24,
                    height: s - 24,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        /// Progress Circular Indicator
                        AnimatedOpacity(
                          opacity: _state == ProgressState.disappear ? 0 : 1,
                          duration: const Duration(milliseconds: 240),
                          curve: Curves.ease,
                          child: Center(
                            child: SizedBox(
                              width: s * 0.7,
                              height: s * 0.7,
                              child: Visibility(
                                /// Invisible when on error
                                visible: _state != ProgressState.error,
                                child: CircularProgressIndicator(
                                  value:
                                      progressprov.onUnknown ? 0 : progressprov.progress,
                                  strokeWidth: 8,
                                  color: const Color(0xFF2d2a31),
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                      Color.fromARGB(255, 203, 243, 157)),
                                ),
                              ),
                            ),
                          ),
                        ),

                        /// Display Texts & Icon, changes when state changes
                        _getStateToDisplay(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
