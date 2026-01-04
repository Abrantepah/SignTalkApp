import 'package:flutter/material.dart';
import 'package:signtalk/utils/page_transition_direction.dart';

class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final PageTransitionDirection direction;
  final Duration duration;

  SlidePageRoute({
    required this.page,
    this.direction = PageTransitionDirection.right,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         pageBuilder: (context, animation, secondaryAnimation) => page,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           Offset begin;

           switch (direction) {
             case PageTransitionDirection.left:
               begin = const Offset(-1.0, 0.0);
               break;
             case PageTransitionDirection.right:
               begin = const Offset(1.0, 0.0);
               break;
             case PageTransitionDirection.up:
               begin = const Offset(0.0, -1.0);
               break;
             case PageTransitionDirection.down:
               begin = const Offset(0.0, 1.0);
               break;
           }

           const end = Offset.zero;
           const curve = Curves.easeInOut;

           final tween = Tween(
             begin: begin,
             end: end,
           ).chain(CurveTween(curve: curve));

           return SlideTransition(
             position: animation.drive(tween),
             child: child,
           );
         },
       );
}
