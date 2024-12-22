import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontHelper {
  static TextStyle getAppropriateFont({
    required final String text,
    required final TextStyle? baseStyle,
  }) {
    final rtlRegex = RegExp(
      r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
    );

    if (rtlRegex.hasMatch(text)) {
      return GoogleFonts.notoSansArabic(
        textStyle: baseStyle,
        height: 1.5,
        letterSpacing: 0.5,
      );
    }

    return GoogleFonts.inter(
      textStyle: baseStyle,
      height: 1.4,
    );
  }
}
