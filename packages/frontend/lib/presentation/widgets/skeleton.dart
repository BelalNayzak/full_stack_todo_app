import 'package:frontend_flutter/frontend.dart';

class SkeletonBox extends StatefulWidget {
  final double height;
  final double width;
  final BorderRadius borderRadius;
  const SkeletonBox({
    super.key,
    this.height = 16,
    this.width = double.infinity,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        final t = _c.value;
        final base = scheme.surfaceContainerHighest;
        final hi = scheme.surface;
        return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              begin: Alignment(-1 + t * 2, 0),
              end: Alignment(1 + t * 2, 0),
              colors: [base, hi, base],
              stops: const [0.1, 0.3, 0.6],
            ),
          ),
        );
      },
    );
  }
}

class SkeletonList extends StatelessWidget {
  final int count;
  const SkeletonList({super.key, this.count = 6});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (_, __) => const _ItemSkeleton(),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: count,
    );
  }
}

class SkeletonGrid extends StatelessWidget {
  final int count;
  const SkeletonGrid({super.key, this.count = 6});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 4 / 2,
      ),
      itemBuilder: (_, __) => const _ItemSkeleton(),
      itemCount: count,
    );
  }
}

class _ItemSkeleton extends StatelessWidget {
  const _ItemSkeleton();
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SkeletonBox(height: 16, width: 140),
            SizedBox(height: 8),
            SkeletonBox(height: 12, width: 200),
            SizedBox(height: 12),
            Row(
              children: [
                SkeletonBox(height: 20, width: 60),
                SizedBox(width: 8),
                SkeletonBox(height: 20, width: 60),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
