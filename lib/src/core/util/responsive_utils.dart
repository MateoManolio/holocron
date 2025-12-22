class ResponsiveGridConfig {
  final int crossAxisCount;
  final double horizontalPadding;
  final double childAspectRatio;

  const ResponsiveGridConfig({
    required this.crossAxisCount,
    required this.horizontalPadding,
    required this.childAspectRatio,
  });
}

class ResponsiveUtils {
  static ResponsiveGridConfig getGridConfig(
    double width, {
    bool isDetailed = false,
  }) {
    if (width < 600) {
      return ResponsiveGridConfig(
        crossAxisCount: 2,
        horizontalPadding: 16,
        childAspectRatio: isDetailed ? 0.46 : 0.65,
      );
    } else if (width < 900) {
      return ResponsiveGridConfig(
        crossAxisCount: 3,
        horizontalPadding: 24,
        childAspectRatio: isDetailed ? 0.52 : 0.72,
      );
    } else if (width < 1200) {
      return ResponsiveGridConfig(
        crossAxisCount: 4,
        horizontalPadding: 32,
        childAspectRatio: isDetailed ? 0.54 : 0.72,
      );
    } else if (width < 1600) {
      return ResponsiveGridConfig(
        crossAxisCount: 5,
        horizontalPadding: 48,
        childAspectRatio: isDetailed ? 0.54 : 0.72,
      );
    } else {
      return ResponsiveGridConfig(
        crossAxisCount: 6,
        horizontalPadding: 80,
        childAspectRatio: isDetailed ? 0.54 : 0.72,
      );
    }
  }
}

