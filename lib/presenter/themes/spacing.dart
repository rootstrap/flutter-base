class Spacing {
  final double spacerSize;
  final double xxs;
  final double xs;
  final double s;
  final double m;
  final double l;
  final double xl;
  final double xxl;
  final double xxxl;
  final double xxxxl;
  final double xxxxxl;

  Spacing._({
    required this.spacerSize,
    required this.xxs,
    required this.xs,
    required this.s,
    required this.m,
    required this.l,
    required this.xl,
    required this.xxl,
    required this.xxxl,
    required this.xxxxl,
    required this.xxxxxl,
  });

  factory Spacing({double spacerSize = 4.0}) {
    return Spacing._(
      spacerSize: spacerSize,
      xxs: 1 * spacerSize,
      xs: 2 * spacerSize,
      s: 3 * spacerSize,
      m: 4 * spacerSize,
      l: 5 * spacerSize,
      xl: 6 * spacerSize,
      xxl: 7 * spacerSize,
      xxxl: 8 * spacerSize,
      xxxxl: 9 * spacerSize,
      xxxxxl: 10 * spacerSize,
    );
  }
}
