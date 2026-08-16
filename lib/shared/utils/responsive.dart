import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < 600;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= 600 && width < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= 1200;
  }

  /// Retourne la largeur disponible avec padding
  static double getWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (isMobile(context)) return width - 16; // 8 padding par côté
    if (isTablet(context)) return width - 32; // 16 padding par côté
    return width - 48; // 24 padding par côté
  }

  /// Hauteur des cartes (responsive)
  static double getCardHeight(BuildContext context) {
    if (isMobile(context)) return 280; // Mobile
    if (isTablet(context)) return 350; // Tablet
    return 380; // Desktop
  }

  /// Largeur des cartes films (responsive)
  static double getFilmCardWidth(BuildContext context) {
    if (isMobile(context)) return 160;
    if (isTablet(context)) return 200;
    return 220;
  }

  /// Hauteur des cartes person (responsive)
  static double getPersonCardHeight(BuildContext context) {
    if (isMobile(context)) return 90;
    if (isTablet(context)) return 110;
    return 120;
  }

  /// Largeur des cartes person (responsive)
  static double getPersonCardWidth(BuildContext context) {
    if (isMobile(context)) return 240;
    if (isTablet(context)) return 300;
    return 320;
  }

  /// Container height pour listes horizontales de films
  static double getFilmsListHeight(BuildContext context) {
    if (isMobile(context)) return 320;
    if (isTablet(context)) return 400;
    return 440;
  }

  /// Container height pour listes horizontales de persons
  static double getPersonListHeight(BuildContext context) {
    if (isMobile(context)) return 120;
    if (isTablet(context)) return 160;
    return 180;
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

  /// Hauteur de l'affiche de film (responsive)
  static double getFilmPosterHeight(BuildContext context) {
    if (isMobile(context)) return 300;
    if (isTablet(context)) return 400;
    return 480;
  }

  /// Hauteur de la carte d'info de film (responsive)
  static double getFilmInfoCardHeight(BuildContext context) {
    if (isMobile(context)) return 320;
    if (isTablet(context)) return 350;
    return 400;
  }

  /// Taille de l'avatar profil (responsive)
  static double getProfileAvatarSize(BuildContext context) {
    if (isMobile(context)) return 120;
    if (isTablet(context)) return 160;
    return 180;
  }
}

/// Extension pour accéder facilement aux tailles
extension ResponsiveContext on BuildContext {
  bool get isMobile => Responsive.isMobile(this);
  bool get isTablet => Responsive.isTablet(this);
  bool get isDesktop => Responsive.isDesktop(this);

  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  double get filmCardWidth => Responsive.getFilmCardWidth(this);
  double get filmCardHeight => Responsive.getCardHeight(this);
  double get personCardWidth => Responsive.getPersonCardWidth(this);
  double get personCardHeight => Responsive.getPersonCardHeight(this);
  double get filmsListHeight => Responsive.getFilmsListHeight(this);
  double get personListHeight => Responsive.getPersonListHeight(this);
  double get paddingH => Responsive.getPaddingHorizontal(this);
  double get paddingV => Responsive.getPaddingVertical(this);
  double get spacing => Responsive.getSpacing(this);
  double get filmPosterHeight => Responsive.getFilmPosterHeight(this);
  double get filmInfoCardHeight => Responsive.getFilmInfoCardHeight(this);
  double get profileAvatarSize => Responsive.getProfileAvatarSize(this);
}
