import 'package:flutter/material.dart';

class ShapeAnimation extends StatefulWidget {
  const ShapeAnimation({super.key});
  @override
  State<ShapeAnimation> createState() => _ShapeAnimationState();
}

class _ShapeAnimationState extends State<ShapeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  //1
  //late Animation<double> animation;
  //double pos = 0;

  //2
  late Animation<double> animationLeft;
  late Animation<double> animationTop;
  double posLeft = 0;
  double posTop = 0;

  //3
  double maxTop = 0;
  double maxLeft = 0;
  late Animation<double> animation;
  final int ballSize = 100;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    //optimized
    )..repeat(reverse: true);

    //1
    //animation = Tween<double>(begin: 0, end: 200).animate(controller)
    //  ..addListener(() {
    //    moveBall();
    //  });

    //2
    //animationLeft = Tween<double>(begin: 0, end: 150).animate(controller);
    //animationTop = Tween<double>(begin: 0, end: 300).animate(controller)
    //  ..addListener(() {
    //    moveBall();
    //  });

    //3
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    animation.addListener(() {
      moveBall();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Controller'),

        //1 2 3
        //actions: [
        //  IconButton(
        //    onPressed: () {
        //      controller.reset();
        //      controller.forward();
        //    },
        //    icon: const Icon(Icons.run_circle),
        //  ),
        //],
      ),
      body:
          //optimized
          SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                maxLeft = constraints.maxWidth - ballSize;
                maxTop = constraints.maxHeight - ballSize;
                return Stack(
                  children: [
                    AnimatedBuilder(
                      animation: controller,
                      child: const Ball(),
                      builder: (context, child) {
                        return Positioned(
                          left: animation.value * maxLeft,
                          top: animation.value * maxTop,
                          child: child!,
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),

      //3
      //SafeArea(
      //  child: LayoutBuilder(
      //    builder: (BuildContext context, BoxConstraints constraints) {
      //      maxLeft = constraints.maxWidth - ballSize;
      //      maxTop = constraints.maxHeight - ballSize;
      //      return Stack(
      //        children: [
      //          Positioned(left: posLeft, top: posTop, child: const Ball()),
      //        ],
      //      );
      //    },
      //  ),
      //),
      //1 2
      //Stack(
      //  children: [
      //    //1
      //    //Positioned(left: pos, top: pos, child: const Ball())
      //    //2
      //    Positioned(left: posLeft, top: posTop, child: Ball()),
      //  ],
      //),
    );
  }

  // 1 2 3
  //void moveBall() {
  //  setState(() {
  //    //1
  //    //pos = animation.value;

  //    //2
  //    //posTop = animationTop.value;
  //    //posLeft = animationLeft.value;

  //    //3
  //    posTop = animation.value * maxTop;
  //    posLeft = animation.value * maxLeft;
  //  });
  //}

  //optimized
  void moveBall() {
    posTop = animation.value * maxTop;
    posLeft = animation.value * maxLeft;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class Ball extends StatelessWidget {
  const Ball({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: const BoxDecoration(
        color: Colors.orange,
        shape: BoxShape.circle,
      ),
    );
  }
}
