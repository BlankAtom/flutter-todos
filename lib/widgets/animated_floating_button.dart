import 'dart:math';

import 'package:flutter/material.dart';
import 'package:todo_list/utils/full_screen_dialog_util.dart';
import 'package:todo_list/utils/icon_list_util.dart';
import 'package:todo_list/widgets/bottom_show_widget.dart';

class AnimatedFloatingButton extends StatefulWidget {
  final Color? bgColor;

  const AnimatedFloatingButton({required Key key, this.bgColor})
      : super(key: key);

  @override
  _AnimatedFloatingButtonState createState() => _AnimatedFloatingButtonState();
}

class _AnimatedFloatingButtonState extends State<AnimatedFloatingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = new Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "Color: ${widget.bgColor}, PrimaryColor: ${Theme.of(context).primaryColor}");
    return AnimatedBuilder(
      animation: _animation,
      builder: (ctx, child) {
        return Transform.translate(
          offset: Offset(0, (_animation.value) * 56),
          child: Transform.scale(
              scale: (1 - _animation.value) as double, child: child),
        );
      },
      child: Transform.rotate(
        angle: -pi / 2,
        child: FloatingActionButton(
          onPressed: () async {
            FullScreenDialog.getInstance().showDialog(
                context,
                BottomShowWidget(
                  onExit: () {
                    _controller.reverse();
                  },
                  taskIconBeans: await IconListUtil.getInstance()
                      .getIconWithCache(context),
                ));
            _controller.forward();
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(
              Icons.add,
              size: 25,
              color: Colors.white,
            ),
          ),
          backgroundColor: widget.bgColor == Colors.transparent
              ? Theme.of(context).primaryColor
              : widget.bgColor,
          // shape: FloatingBorder(),
        ),
      ),
    );
  }
}
