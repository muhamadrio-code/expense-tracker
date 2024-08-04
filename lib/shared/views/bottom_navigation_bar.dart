import 'package:expense_tracker/router/router.dart';
import 'package:expense_tracker/shared/extentions.dart';
import 'package:flutter/material.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar(
      {required this.destinations,
      required this.selectedIndex,
      required this.onDestinationSelected,
      super.key});
  final List<Destination> destinations;
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return _AppNavigationDestinationBuilder(
        destinations: destinations,
        builder: (context, destination, index) => _SelectableAnimationBuilder(
              duration: const Duration(milliseconds: 100),
              selected: index == selectedIndex,
              builder: (context, animation) => _BottomNavigationInfo(
                index: index,
                selectedIndex: selectedIndex,
                onTap: () => onDestinationSelected(index),
                selectedAnimation: animation,
                child: BottomAppBarDestination(child: destination.icon),
              ),
            ));
  }
}

class _AppNavigationDestinationBuilder extends StatelessWidget {
  final Widget Function(BuildContext, Destination, int) builder;
  final List<Destination> destinations;

  const _AppNavigationDestinationBuilder(
      {required this.builder, required this.destinations});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: const Color.fromARGB(41, 0, 0, 0),
                    blurRadius: 5,
                    offset: Offset.fromDirection(90, 5)),
              ],
            ),
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
            child: _AppNavigationDestinationLayout(
                children: destinations.indexed
                    .map((d) => builder(context, d.$2, d.$1))
                    .toList()
                  ..insert(2, const SizedBox()))));
  }
}

class _AppNavigationDestinationLayout extends StatelessWidget {
  final List<Widget> children;
  const _AppNavigationDestinationLayout({required this.children});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        height: 64,
        decoration: BoxDecoration(
          color: context.colors.primary,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32)),
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BottomAppBar(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: children,
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}

class _BottomNavigationInfo extends InheritedWidget {
  final int index;
  final int selectedIndex;
  final VoidCallback onTap;
  final Animation<double> selectedAnimation;

  const _BottomNavigationInfo(
      {required this.index,
      required this.selectedIndex,
      required this.onTap,
      required this.selectedAnimation,
      required super.child});

  @override
  bool updateShouldNotify(covariant _BottomNavigationInfo oldWidget) {
    return index != oldWidget.index ||
        selectedIndex != oldWidget.selectedIndex ||
        onTap != oldWidget.onTap ||
        selectedAnimation != oldWidget.selectedAnimation;
  }

  static _BottomNavigationInfo of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_BottomNavigationInfo>()!;
  }
}

class BottomAppBarDestination extends StatelessWidget {
  final Icon child;

  const BottomAppBarDestination({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final _BottomNavigationInfo info = _BottomNavigationInfo.of(context);
    final Animation<double> animation = info.selectedAnimation;
    final isSelected = info.selectedIndex == info.index;
    final Widget selectedIcon = IconTheme.merge(
        data: IconThemeData(color: context.colors.primary), child: child);

    return AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          return GestureDetector(
            onTap: info.onTap,
            child: isSelected ? selectedIcon : child,
          );
        });
  }
}

class _SelectableAnimationBuilder extends StatefulWidget {
  const _SelectableAnimationBuilder({
    required this.selected,
    required this.duration,
    required this.builder,
  });

  final Duration? duration;
  final bool selected;
  final Widget Function(BuildContext, Animation<double>) builder;

  @override
  State<_SelectableAnimationBuilder> createState() =>
      _SelectableAnimationBuilderState();
}

class _SelectableAnimationBuilderState
    extends State<_SelectableAnimationBuilder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.duration = widget.duration;
    _controller.value = widget.selected ? 1.0 : 0.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _SelectableAnimationBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      if (widget.selected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      _controller,
    );
  }
}
