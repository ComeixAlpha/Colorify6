import 'package:colorify/frontend/pages/block/block_arguments.dart';
import 'package:colorify/frontend/pages/block/block_palette.dart';
import 'package:colorify/ui/util/text_style.dart';
import 'package:flutter/material.dart';

class PageBlock extends StatefulWidget {
  final double width;
  final double height;
  const PageBlock({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  State<PageBlock> createState() => _PageBlockState();
}

class _PageBlockState extends State<PageBlock> {
  final PageController _pageController = PageController();

  int _selected = 0;

  void change(int v) {
    if (_selected == v) {
      return;
    } else {
      setState(() {
        _selected = v;
      });
    }
  }

  @override
  void initState() {
    _pageController.addListener(
      () {
        if (_pageController.offset > 203 && _selected == 0) {
          change(1);
        } else if (_pageController.offset < 203 && _selected == 1) {
          change(0);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: widget.width,
          height: 40,
          child: Stack(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(
                        0,
                        duration: const Duration(milliseconds: 120),
                        curve: Curves.ease,
                      );
                    },
                    child: SizedBox(
                      width: widget.width / 2,
                      height: 40,
                      child: Center(
                        child: Text(
                          'ARGUMENTS 参数表',
                          overflow: TextOverflow.ellipsis,
                          style: getStyle(
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 120),
                        curve: Curves.ease,
                      );
                    },
                    child: SizedBox(
                      width: widget.width / 2,
                      height: 40,
                      child: Center(
                        child: Text(
                          'PALETTE 调色板',
                          overflow: TextOverflow.ellipsis,
                          style: getStyle(
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              AnimatedPositioned(
                bottom: 0,
                left: (widget.width / 4 - 20) + (_selected == 0 ? 0 : widget.width / 2),
                curve: Curves.ease,
                duration: const Duration(milliseconds: 120),
                child: Container(
                  width: 40,
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: widget.width,
          height: widget.height - 40,
          child: PageView(
            allowImplicitScrolling: true,
            controller: _pageController,
            children: [
              BlockArguments(
                width: widget.width,
                height: widget.height - 40,
              ),
              BlockPalette(
                width: widget.width,
                height: widget.height - 40,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
