import 'package:flutter/material.dart';

class LogoAnimation extends StatefulWidget {
  const LogoAnimation({Key? key}) : super(key: key);

  @override
  State<LogoAnimation> createState() => _LogoAnimationState();
}

class _LogoAnimationState extends State<LogoAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 2))
        ..repeat(reverse: true);
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
          begin: Offset.zero, end: const Offset(0, -0.5))
      .animate(_controller);
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: const Padding(
        padding: EdgeInsets.all(8),
        child: FlutterLogo(size: 100),
      ),
    );
  }
}
