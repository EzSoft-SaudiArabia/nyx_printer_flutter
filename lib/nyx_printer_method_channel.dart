import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'nyx_printer_definition.dart';
import 'nyx_printer_platform_interface.dart';

/// An implementation of [NyxPrinterPlatform] that uses method channels.
class MethodChannelNyxPrinter extends NyxPrinterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('nyx_printer_flutter');

  @override
  Future<String?> getServiceVersion() async {
    return await methodChannel.invokeMethod<String>('getServiceVersion');
  }

  @override
  Future<String?> getPrinterVersion() async {
    return await methodChannel.invokeMethod<String>('getPrinterVersion');
  }

  @override
  Future<int?> getPrinterStatus() async {
    return await methodChannel.invokeMethod<int>('getPrinterStatus');
  }

  @override
  Future<int?> getPrinterDensity() async {
    return await methodChannel.invokeMethod<int>('getPrinterDensity');
  }

  @override
  Future<void> setPrinterDensity(int density) async {
    return await methodChannel
        .invokeMethod<void>('setPrinterDensity', {'density': density});
  }

  @override
  Future<void> setPaperWidth(int width) async {
    return await methodChannel
        .invokeMethod<void>('setPaperWidth', {'width': width});
  }

  @override
  Future<void> paperOut(int px) async {
    return await methodChannel.invokeMethod<void>('paperOut', {'px': px});
  }

  @override
  Future<void> paperBack(int px) async {
    return await methodChannel.invokeMethod<void>('paperBack', {'px': px});
  }

  @override
  Future<void> printText(String text, PrintTextStyle? style,
      {int? textWidth, PrintAlign? align}) async {
    Map<String, dynamic> args = <String, dynamic>{
      'text': text,
      'style': style?.toMap(),
      'textWidth': textWidth,
      'align': align?.index
    };
    return await methodChannel.invokeMethod<void>('printText', args);
  }

  @override
  Future<void> printBarcode(String data, int width, int height,
      {BarcodeTextPosition textPosition = BarcodeTextPosition.NO_TEXT,
      PrintAlign align = PrintAlign.LEFT,
      BarcodeSymbology symbology = BarcodeSymbology.CODE128}) async {
    Map<String, dynamic> args = <String, dynamic>{
      'data': data,
      'width': width,
      'height': height,
      'textPosition': textPosition.index,
      'align': align.index,
      'symbology': symbology.index,
    };
    return await methodChannel.invokeMethod<void>('printBarcode', args);
  }

  @override
  Future<void> printQrCode(String data, int width, int height,
      {PrintAlign align = PrintAlign.LEFT}) async {
    Map<String, dynamic> args = <String, dynamic>{
      'data': data,
      'width': width,
      'height': height,
      'align': align.index,
    };
    return await methodChannel.invokeMethod<void>('printQrCode', args);
  }

  @override
  Future<void> printImage(Uint8List img,
      {ImageType type = ImageType.BLACK_WHITE,
      PrintAlign align = PrintAlign.LEFT}) async {
    Map<String, dynamic> args = <String, dynamic>{
      'img': img,
      'type': type.index,
      'align': align.index,
    };
    return await methodChannel.invokeMethod<void>('printBitmap', args);
  }

  @override
  Future<void> printRasterData(Uint8List data) async {
    return await methodChannel
        .invokeMethod<void>('printRasterData', {'data': data});
  }

  @override
  Future<Uint8List?> printEscposData(Uint8List data) async {
    return await methodChannel
        .invokeMethod<Uint8List>('printEscposData', {'data': data});
  }

  @override
  Future<void> printTableText(List<String> texts, List<void> weights,
      List<PrintTextStyle> styles) async {
    Map<String, dynamic> args = <String, dynamic>{
      'texts': texts,
      'weights': weights,
      'styles': styles.map((e) => e.toMap()).toList(),
    };
    return await methodChannel.invokeMethod<void>('printTableText', args);
  }

  @override
  Future<void> printEndAutoOut() async {
    return await methodChannel.invokeMethod<void>('printEndAutoOut');
  }

  @override
  Future<void> labelLocate(int labelHeight, int labelGap) async {
    Map<String, dynamic> args = <String, dynamic>{
      'labelHeight': labelHeight,
      'labelGap': labelGap,
    };
    return await methodChannel.invokeMethod<void>('labelLocate', args);
  }

  @override
  Future<void> labelPrintEnd() async {
    return await methodChannel.invokeMethod<void>('labelPrintEnd');
  }

  @override
  Future<void> labelLocateAuto({int labelHeight = 0, int labelGap = 0}) async {
    Map<String, dynamic> args = <String, dynamic>{
      'labelHeight': labelHeight,
      'labelGap': labelGap,
    };
    return await methodChannel.invokeMethod<void>('labelLocateAuto', args);
  }

  @override
  Future<void> labelDetectAuto() async {
    return await methodChannel.invokeMethod<void>('labelDetectAuto');
  }

  @override
  Future<bool?> hasLabelLearning() async {
    return await methodChannel.invokeMethod<bool>('hasLabelLearning');
  }

  @override
  Future<void> clearLabelLearning() async {
    return await methodChannel.invokeMethod<void>('clearLabelLearning');
  }

  @override
  Future<void> configLcd(LcdOpt opt) async {
    return await methodChannel
        .invokeMethod<void>('configLcd', {'opt': opt.index});
  }

  @override
  Future<void> showLcdImage(Uint8List img) async {
    return await methodChannel
        .invokeMethod<void>('showLcdBitmap', {'img': img});
  }

  @override
  Future<void> setLcdLogo(Uint8List img) async {
    return await methodChannel.invokeMethod<void>('setLcdLogo', {'img': img});
  }

  @override
  Future<void> openCashBox() async {
    return await methodChannel.invokeMethod<void>('openCashBox');
  }
}
