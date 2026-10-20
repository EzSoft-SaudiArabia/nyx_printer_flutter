class PrinterStatus {
  static const SDK_OK = 0;
  static const PRN_BASE_ERR = -1200;
  static const PRN_COVER_OPEN = (PRN_BASE_ERR - 1);
  static const PRN_PARAM_ERR = (PRN_BASE_ERR - 2);
  static const PRN_NO_PAPER = (PRN_BASE_ERR - 3);
  static const PRN_OVERHEAT = (PRN_BASE_ERR - 4);
  static const PRN_UNKNOWN_ERR = (PRN_BASE_ERR - 5);
  static const PRN_PRINTING = (PRN_BASE_ERR - 6);
  static const PRN_NO_NFC = (PRN_BASE_ERR - 7);
  static const PRN_NFC_NO_PAPER = (PRN_BASE_ERR - 8);
  static const PRN_LOW_BATTERY = (PRN_BASE_ERR - 9);
  static const PRN_LBL_LOCATE_ERR = (PRN_BASE_ERR - 90);
  static const PRN_LBL_DETECT_ERR = (PRN_BASE_ERR - 91);
  static const PRN_LBL_NO_DETECT = (PRN_BASE_ERR - 92);

  static String msg(int? code) {
    String res = "Unknown error";
    switch (code) {
      case SDK_OK:
        res = "Success";
        break;
      case PRN_COVER_OPEN:
        res = "Printer cover open";
        break;
      case PRN_PARAM_ERR:
        res = "Printer params error";
        break;
      case PRN_NO_PAPER:
        res = "Printer no paper";
        break;
      case PRN_OVERHEAT:
        res = "Printer overheat";
        break;
      case PRN_UNKNOWN_ERR:
        res = "Printer unknown error";
        break;
      case PRN_PRINTING:
        res = "Printer is printing";
        break;
      case PRN_NO_NFC:
        res = "Printer no NFC";
        break;
      case PRN_NFC_NO_PAPER:
        res = "Printer NFC no paper";
        break;
      case PRN_LOW_BATTERY:
        res = "Printer low battery";
        break;
      case PRN_LBL_LOCATE_ERR:
        res = "Printer label locate error";
        break;
      case PRN_LBL_DETECT_ERR:
        res = "Printer label detect error";
        break;
      case PRN_LBL_NO_DETECT:
        res = "Printer label not detected";
        break;
    }
    return res;
  }
}

class PrintTextStyle {
  /// text font size
  int? textSize = 24;

  /// text underline
  bool? underline = false;

  /// the horizontal skew factor for text
  double? textScaleX = 1.0;

  /// the horizontal scale factor for print text
  double? textScaleY = 1.0;

  /// text letter-spacing
  double? letterSpacing = 0;

  /// text line-spacing
  double? lineSpacing = 0;

  /// top padding
  int? topPadding = 0;

  /// left padding
  int? leftPadding = 0;

  /// text alignment
  PrintAlign? align = PrintAlign.LEFT;

  /// font file path for custom font
  String? font;

  PrintTextStyle(
      {this.textSize = 24,
      this.underline = false,
      this.textScaleX = 1.0,
      this.textScaleY = 1.0,
      this.letterSpacing = 0,
      this.lineSpacing = 0,
      this.topPadding = 0,
      this.leftPadding = 0,
      this.align = PrintAlign.LEFT,
      this.font});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['textSize'] = textSize;
    map['underline'] = underline;
    map['textScaleX'] = textScaleX;
    map['textScaleY'] = textScaleY;
    map['letterSpacing'] = letterSpacing;
    map['lineSpacing'] = lineSpacing;
    map['topPadding'] = topPadding;
    map['leftPadding'] = leftPadding;
    map['align'] = align?.index;
    map['font'] = font;
    return map;
  }
}

enum PrintAlign {
  LEFT,
  CENTER,
  RIGHT,
}

enum BarcodeTextPosition {
  NO_TEXT,
  TEXT_ABOVE,
  TEXT_BELOW,
  BOTH,
}

enum BarcodeSymbology {
  CODE128,
  CODE39,
  CODE93,
  UPCA,
  UPCE,
  EAN13,
  EAN8,
  ITF,
  CODABAR,
}

enum ImageType {
  /// for black and white bitmap
  BLACK_WHITE,

  /// grayscale bitmap, suitable for rich color images
  GRAYSCALE,
}

enum LcdOpt {
  INIT,
  WAKEUP,
  SLEEP,
  CLEAR,
  RESET,
}
