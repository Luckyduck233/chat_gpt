import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class Loading extends StatefulWidget {
  @override
  State<Loading> createState() => _LoadingState();

  Loading({super.key});
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _currentIndex++;
        if (_currentIndex == 3) {
          _currentIndex = 0;
        }
        _animationController!.reset();
        _animationController!.forward();
      }
    });
    _animationController!.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (index) => Opacity(
              opacity: index == _currentIndex ? 1.0 : 0.2,
              child: ".".text.scale(5).make(),
            ),
          ),
        );
      },
    );
  }
}
