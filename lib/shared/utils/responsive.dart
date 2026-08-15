import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < 600;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= 600;
  }

  /// Retourne la largeur disponible avec padding
  static double getWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (isMobile(context)) return width - 16; // 8 padding par côté
    return width - 32; // 16 padding par côté
  }

  /// Hauteur des cartes (responsive)
  static double getCardHeight(BuildContext context) {
    if (isMobile(context)) return 280; // Mobile
    return 350; // Tablet
  }

  /// Largeur des cartes films (responsive)
  static double getFilmCardWidth(BuildContext context) {
    if (isMobile(context)) return 160;
    return 200;
  }

  /// Hauteur des cartes person (responsive)
  static double getPersonCardHeight(BuildContext context) {
    if (isMobile(context)) return 90;
    return 110;
  }

  /// Container height pour listes horizontales de films
  static double getFilmsListHeight(BuildContext context) {
    if (isMobile(context)) return 320;
    return 400;
  }

  /// Container height pour listes horizontales de persons
  static double getPersonListHeight(BuildContext context) {
    if (isMobile(context)) return 120;
    return 160;
  }

  /// Padding horizontal adaptatif
  static double getPaddingHorizontal(BuildContext context) {
    if (isMobile(context)) return 8;
    if (isTablet(context)) return 16;
    return 24;
  }

  /// Padding vertical adaptatif
  static double getPaddingVertical(BuildContext context) {
    if (isMobile(context)) return 8;
    if (isTablet(context)) return 12;
    return 16;
  }

  /// Spacing entre éléments (adaptatif)
  static double getSpacing(BuildContext context) {
    if (isMobile(context)) return 8;
    if (isTablet(context)) return 12;
    return 16;
  }
}

/// Extension pour accéder facilement aux tailles
extension ResponsiveContext on BuildContext {
  bool get isMobile => Responsive.isMobile(this);
  bool get isTablet => Responsive.isTablet(this);

  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  double get filmCardWidth => Responsive.getFilmCardWidth(this);
  double get filmCardHeight => Responsive.getCardHeight(this);
  double get personCardHeight => Responsive.getPersonCardHeight(this);
  double get filmsListHeight => Responsive.getFilmsListHeight(this);
  double get personListHeight => Responsive.getPersonListHeight(this);
  double get paddingH => Responsive.getPaddingHorizontal(this);
  double get paddingV => Responsive.getPaddingVertical(this);
  double get spacing => Responsive.getSpacing(this);
}
