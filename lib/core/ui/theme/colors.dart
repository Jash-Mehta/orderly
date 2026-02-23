// Color names are based from https://www.color-name.com/hex/6E791A

import 'package:flutter/material.dart';

class AppColors {
  static const Color black = Color(0xff000000);
  static const Color white = Color(0xffffffff);
  static const Color lightSkyBlue = Color(0xffE7F5FB);
  static const Color skyBlue = Color(0xffB3DEF3);
  static const Color darkSkyBlue = Color(0xff3BABDF);
  static const Color chineseBlue = Color(0xFF374EA2);
  static const Color lavender = Color(0xFFDDE1FF);
  static const Color oxfordBlue = Color(0xFF001452);
  static const Color darkBlue = Color(0xFF212760);
  static const Color royalBlue = Color(0xFF2B327C);
  static const Color majorelleBlue = Color(0xFF5556D9);
  static const Color aliceBlue = Color(0xFFE8F1FD);
  static const Color navyBlue = Color(0xFF08006C);
  static const Color carnelian = Color(0xFFBA1A1A);
  static const Color gunmetal = Color(0xFF2B2F38);
  static const Color sonicSilver = Color(0xFF767680);
  static const Color darkElectricBlue = Color(0xFF5D6679);
  static const Color auroMetalSaurus = Color(0xFF667085);
  static const Color fireEngineRed = Color(0xFFC5291D);
  static const Color cultured = Color(0xFFF5F6F7);
  static const Color forestGreen = Color(0xFF1B8820);
  static const Color metallicOrange = Color(0xFFDC6803);
  static const Color warmwhite = Color(0xFFF7F4EF);
  static const Color greyColor = Color.fromARGB(255, 59, 59, 59);

  // shade colors
  static const Color softMist = Color(0xfff5f6f7);
  // Status Colors
  static const Color success = forestGreen;
  static const Color warning = metallicOrange;
  static const Color info = chineseBlue;
  static const Color error = carnelian;
  static const Color grey = auroMetalSaurus;
  static const Color grey600 = sonicSilver;
  // Primary variations
  static const Color primary = chineseBlue;
  static const Color primaryLight = lavender;
  static const Color textPrimary = gunmetal;
  static const Color textSecondary = auroMetalSaurus;

  // Add to your existing AppColors class

// ── Snackbar surface colors (light tinted backgrounds) ─────────────────────
static const Color successSurface = Color(0xFFECFDF5);
static const Color errorSurface   = Color(0xFFFEF2F2);
static const Color warningSurface = Color(0xFFFFFBEB);
static const Color infoSurface    = Color(0xFFEFF6FF);


  // Function to convert Color to hex string
  static String colorToHex(Color color) {
    return color.value.toRadixString(16).substring(2).toUpperCase();
  }

  // Function to convert Hex to Int
  static int hexToColor(String hexCode, {String alpha = 'FF'}) {
    hexCode = hexCode.replaceAll('#', '');

    // If the hex code is shorthand (3 or 4 digits)
    // convert it to full form (6 or 8 digits)
    if (hexCode.length == 3) {
      hexCode = hexCode.split('').map((c) => '$c$c').join();
    } else if (hexCode.length == 4) {
      alpha = hexCode[0] + hexCode[0];
      hexCode = hexCode.substring(1).split('').map((c) => '$c$c').join();
    }
    // Ensure hexCode has 6 characters (RRGGBB)
    if (hexCode.length == 6) {
      return int.parse('0x$alpha$hexCode');
    } else if (hexCode.length == 8) {
      return int.parse('0x$hexCode');
    }

    throw const FormatException("Invalid hex code");
  }
}
