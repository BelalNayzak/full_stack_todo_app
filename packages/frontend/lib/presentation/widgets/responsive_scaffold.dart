import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:frontend_flutter/frontend.dart';

class ResponsiveScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? sidebar; // optional desktop sidebar

  const ResponsiveScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.actions,
    this.leading,
    this.sidebar,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop =
        MediaQuery.sizeOf(context).width >= 1200 ||
        kIsWeb && MediaQuery.sizeOf(context).width >= 900;

    if (isDesktop && sidebar != null) {
      return Row(
        children: [
          SizedBox(
            width: 280,
            child: ClipRRect(
              borderRadius: BorderRadius.zero,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surface.withValues(alpha: 0.6),
                    border: Border(
                      right: BorderSide(
                        color: Theme.of(
                          context,
                        ).dividerColor.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                  child: Material(
                    type: MaterialType.transparency,
                    child: sidebar,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Scaffold(
              appBar: appBar,
              body: body,
              floatingActionButton: floatingActionButton,
            ),
          ),
        ],
      );
    }

    // Tablet/Mobile or no sidebar provided
    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
