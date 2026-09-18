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

  static double size(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  // --- Helpers adaptatifs ---

  /// Hauteur des boutons principaux
  static double buttonHeight(BuildContext context) {
    if (isDesktop(context)) return 58;
    if (isTablet(context)) return 54;
    return 48;
  }

  /// Taille de police pour les titres de page
  static double titleFontSize(BuildContext context) {
    if (isDesktop(context)) return 30;
    if (isTablet(context)) return 26;
    return 22;
  }

  /// Taille de police pour les labels et textes courants
  static double bodyFontSize(BuildContext context) {
    if (isDesktop(context)) return 18;
    if (isTablet(context)) return 16;
    return 14;
  }

  /// Espacement vertical entre les éléments principaux du Column
  static double spacing(BuildContext context) {
    if (isDesktop(context)) return 36;
    if (isTablet(context)) return 28;
    return 20;
  }

  /// Espacement horizontal entre les éléments principaux du row
  static double spacingRow(BuildContext context) {
    if (isDesktop(context)) return 66;
    if (isTablet(context)) return 58;
    return 50;
  }

  /// Espacement entre le label et le champ de saisie
  static double fieldSpacing(BuildContext context) {
    if (isDesktop(context)) return 8;
    if (isTablet(context)) return 7;
    return 5;
  }

  /// Padding horizontal/vertical de l'écran
  static double padding(BuildContext context) {
    if (isDesktop(context)) return 48;
    if (isTablet(context)) return 32;
    return 16;
  }

  /// Rayon de bordure des champs de saisie
  static double radius(BuildContext context) {
    if (isDesktop(context)) return 14;
    if (isTablet(context)) return 12;
    return 10;
  }

  /// Largeur du formulaire (centré sur tablet/desktop)
  static double formWidth(BuildContext context) {
    if (isDesktop(context)) return 600;
    if (isTablet(context)) return 520;
    return MediaQuery.sizeOf(context).width;
  }

  static double containerGameWidth(BuildContext context) {
    if (isDesktop(context)) return 800;
    if (isTablet(context)) return 600;
    return MediaQuery.sizeOf(context).width;
  }

  static double imageGameWidth(BuildContext context) {
    if (isDesktop(context)) return 350;
    if (isTablet(context)) return 300;
    return 250;
  }

  static double consoleImageSize(BuildContext context) {
    if (isDesktop(context)) return 300;
    if (isTablet(context)) return 250;
    return 200;
  }

  static double heightContainerConsole(BuildContext context) {
    if (isDesktop(context)) return 380;
    if (isTablet(context)) return 340;
    return 300;
  }

  static double widthCard(BuildContext context) {
    if (isDesktop(context)) return 380;
    if (isTablet(context)) return 340;
    return 300;
  }

  static double heightCard(BuildContext context) {
    if (isDesktop(context)) return 110;
    if (isTablet(context)) return 90;
    return 70;
  }

  /// Hauteur du bottomSheet panier (total + bouton)
  static double bottomSheetHeight(BuildContext context) {
    if (isDesktop(context)) return 140;
    if (isTablet(context)) return 120;
    return 100;
  }

  /// Padding bas de la ListView pour ne pas être caché par le bottomSheet
  static double bottomSheetClearance(BuildContext context) {
    if (isDesktop(context)) return 160;
    if (isTablet(context)) return 140;
    return 116;
  }

  static double textTitleSize(BuildContext context) {
    if (isDesktop(context)) return 25;
    if (isTablet(context)) return 22;
    return 19;
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

extension ResponsiveExtension on BuildContext {
  bool get isMobile => Responsive.isMobile(this);
  bool get isTablet => Responsive.isTablet(this);
  bool get isDesktop => Responsive.isDesktop(this);
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  // Raccourcis des helpers
  double get buttonHeight => Responsive.buttonHeight(this);
  double get titleFontSize => Responsive.titleFontSize(this);
  double get bodyFontSize => Responsive.bodyFontSize(this);
  double get spacing => Responsive.spacing(this);
  double get spacingRow => Responsive.spacingRow(this);
  double get fieldSpacing => Responsive.fieldSpacing(this);
  double get padding => Responsive.padding(this);
  double get radius => Responsive.radius(this);
  double get formWidth => Responsive.formWidth(this);
  double get imageGameWidth => Responsive.imageGameWidth(this);
  double get textTitleSize => Responsive.textTitleSize(this);
  double get containerGameWidth => Responsive.containerGameWidth(this);
  double get consoleImageSize => Responsive.consoleImageSize(this);
  double get heightContainerConsole => Responsive.heightContainerConsole(this);
  double get heightCard => Responsive.heightCard(this);
  double get bottomSheetHeight => Responsive.bottomSheetHeight(this);
  double get bottomSheetClearance => Responsive.bottomSheetClearance(this);
  double get filmCardWidth => Responsive.getFilmCardWidth(this);
  double get filmCardHeight => Responsive.getCardHeight(this);
  double get personCardWidth => Responsive.getPersonCardWidth(this);
  double get personCardHeight => Responsive.getPersonCardHeight(this);
  double get filmsListHeight => Responsive.getFilmsListHeight(this);
  double get personListHeight => Responsive.getPersonListHeight(this);
  double get paddingH => Responsive.getPaddingHorizontal(this);
  double get paddingV => Responsive.getPaddingVertical(this);
  double get filmPosterHeight => Responsive.getFilmPosterHeight(this);
  double get filmInfoCardHeight => Responsive.getFilmInfoCardHeight(this);
  double get profileAvatarSize => Responsive.getProfileAvatarSize(this);
}
