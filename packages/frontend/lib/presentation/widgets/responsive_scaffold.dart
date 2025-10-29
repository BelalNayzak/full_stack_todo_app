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
    if (context.isDesktop && sidebar != null) {
      return Row(
        children: [
          SizedBox(
            width: 280,
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              elevation: 0,
              child: sidebar,
            ),
          ),
          const VerticalDivider(width: 1),
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
