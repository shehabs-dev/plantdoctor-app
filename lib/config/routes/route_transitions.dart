import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteTransitions {
  static const _duration = Duration(milliseconds: 300);

  /// Fade — good for splash/onboarding → home
  static CustomTransitionPage fade(Widget child, GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
      transitionDuration: _duration,
      child: child,
      transitionsBuilder: (_, animation, _, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  /// Slide from right — standard forward navigation
  static CustomTransitionPage slideFromRight(
    Widget child,
    GoRouterState state,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      transitionDuration: _duration,
      child: child,
      transitionsBuilder: (_, animation, _, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(1, 0), end: Offset.zero).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: child,
        );
      },
    );
  }

  /// Slide from left — back navigation or RTL forward navigation
  static CustomTransitionPage slideFromLeft(Widget child, GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
      transitionDuration: _duration,
      child: child,
      transitionsBuilder: (_, animation, _, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(-1, 0), end: Offset.zero).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: child,
        );
      },
    );
  }

  /// Slide from bottom — modals, sheets, auth pages
  static CustomTransitionPage slideFromBottom(
    Widget child,
    GoRouterState state,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      transitionDuration: _duration,
      child: child,
      transitionsBuilder: (_, animation, _, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: Offset.zero).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: child,
        );
      },
    );
  }

  /// ✅ BEST for SignIn → Home: fade + scale gives a sense of "arriving"
  static CustomTransitionPage fadeScale(Widget child, GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
      transitionDuration: const Duration(milliseconds: 400),
      child: child,
      transitionsBuilder: (_, animation, _, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween(begin: 0.92, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
    );
  }

  /// Slide + fade — polished version of slideFromRight
  static CustomTransitionPage slideFade(Widget child, GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
      transitionDuration: _duration,
      child: child,
      transitionsBuilder: (_, animation, _, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween(begin: const Offset(0.05, 0), end: Offset.zero)
                .animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOut),
                ),
            child: child,
          ),
        );
      },
    );
  }

  /// No animation — instant replace (e.g. after logout)
  static CustomTransitionPage noTransition(Widget child, GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
      transitionDuration: Duration.zero,
      child: child,
      transitionsBuilder: (_, _, _, child) => child,
    );
  }

  /// Shared axis horizontal — Material 3 standard for sibling pages (e.g. tabs)
  static CustomTransitionPage sharedAxisHorizontal(
    Widget child,
    GoRouterState state,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      transitionDuration: _duration,
      child: child,
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: SlideTransition(
            position: Tween(begin: const Offset(0.05, 0), end: Offset.zero)
                .animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOut),
                ),
            child: child,
          ),
        );
      },
    );
  }

  /// Shared axis vertical — for hierarchical navigation (e.g. list → detail)
  static CustomTransitionPage sharedAxisVertical(
    Widget child,
    GoRouterState state,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      transitionDuration: _duration,
      child: child,
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: SlideTransition(
            position: Tween(begin: const Offset(0, 0.05), end: Offset.zero)
                .animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOut),
                ),
            child: child,
          ),
        );
      },
    );
  }
}
