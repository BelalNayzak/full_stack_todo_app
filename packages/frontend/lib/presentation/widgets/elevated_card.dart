import 'package:frontend_flutter/frontend.dart';

class ElevatedHoverCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const ElevatedHoverCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  State<ElevatedHoverCard> createState() => _ElevatedHoverCardState();
}

class _ElevatedHoverCardState extends State<ElevatedHoverCard> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final baseElevation = 1.0;
    final hoverElevation = 6.0;
    final pressElevation = 2.0;

    final elevation = _pressed
        ? pressElevation
        : _hovered
        ? hoverElevation
        : baseElevation;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.01 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Card(
          elevation: elevation,
          clipBehavior: Clip.antiAlias,
          shadowColor: scheme.shadow.withValues(alpha: 0.25),
          child: InkWell(
            onTap: widget.onTap,
            onHighlightChanged: (v) => setState(() => _pressed = v),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: widget.padding,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [scheme.surface, scheme.surfaceContainerHighest],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
