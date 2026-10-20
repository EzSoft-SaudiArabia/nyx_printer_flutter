import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'nyx_printer_definition.dart';
import 'nyx_printer_method_channel.dart';

abstract class NyxPrinterPlatform extends PlatformInterface {
  /// Constructs a NyxPrinterPlatform.
  NyxPrinterPlatform() : super(token: _token);

  static final Object _token = Object();

  static NyxPrinterPlatform _instance = MethodChannelNyxPrinter();

  /// The default instance of [NyxPrinterPlatform] to use.
  ///
  /// Defaults to [MethodChannelNyxPrinter].
  static NyxPrinterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NyxPrinterPlatform] when
  /// they register themselves.
  static set instance(NyxPrinterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getServiceVersion() {
    throw UnimplementedError('getServiceVersion() has not been implemented.');
  }

  Future<String?> getPrinterVersion() {
    throw UnimplementedError('getPrinterVersion() has not been implemented.');
  }

  Future<int?> getPrinterStatus() async {
    throw UnimplementedError('getPrinterStatus() has not been implemented.');
  }

  Future<int?> getPrinterDensity() async {
    throw UnimplementedError('getPrinterStatus() has not been implemented.');
  }

  Future<void> setPrinterDensity(int density) async {
    throw UnimplementedError('getPrinterStatus() has not been implemented.');
  }

  Future<void> setPaperWidth(int width) async {
    throw UnimplementedError('getPrinterStatus() has not been implemented.');
  }

  Future<void> paperOut(int px) {
    throw UnimplementedError('paperOut() has not been implemented.');
  }

  Future<void> paperBack(int px) {
    throw UnimplementedError('paperBack() has not been implemented.');
  }

  Future<void> printText(String text, PrintTextStyle? style,
      {int? textWidth, PrintAlign? align}) {
    throw UnimplementedError('printText() has not been implemented.');
  }

  Future<void> printBarcode(String data, int width, int height,
      {BarcodeTextPosition textPosition = BarcodeTextPosition.NO_TEXT,
      PrintAlign align = PrintAlign.LEFT,
      BarcodeSymbology symbology = BarcodeSymbology.CODE128}) async {
    throw UnimplementedError('printBarcode() has not been implemented.');
  }

  Future<void> printQrCode(String data, int width, int height,
      {PrintAlign align = PrintAlign.LEFT}) {
    throw UnimplementedError('printQrCode() has not been implemented.');
  }

  Future<void> printImage(Uint8List img,
      {ImageType type = ImageType.BLACK_WHITE,
      PrintAlign align = PrintAlign.LEFT}) {
    throw UnimplementedError('printBitmap() has not been implemented.');
  }

  Future<void> printRasterData(Uint8List data) {
    throw UnimplementedError('printRasterData() has not been implemented.');
  }

  Future<Uint8List?> printEscposData(Uint8List data) {
    throw UnimplementedError('printEscposData() has not been implemented.');
  }

  Future<void> printTableText(
      List<String> texts, List<int> weights, List<PrintTextStyle> styles) {
    throw UnimplementedError('printTableText() has not been implemented.');
  }

  Future<void> printEndAutoOut() {
    throw UnimplementedError('printEndAutoOut() has not been implemented.');
  }

  Future<void> labelLocate(int labelHeight, int labelGap) {
    throw UnimplementedError('labelLocate() has not been implemented.');
  }

  Future<void> labelPrintEnd() {
    throw UnimplementedError('labelPrintEnd() has not been implemented.');
  }

  Future<void> labelLocateAuto({int labelHeight = 0, int labelGap = 0}) {
    throw UnimplementedError('labelLocateAuto() has not been implemented.');
  }

  Future<void> labelDetectAuto() {
    throw UnimplementedError('labelDetectAuto() has not been implemented.');
  }

  Future<bool?> hasLabelLearning() {
    throw UnimplementedError('hasLabelLearning() has not been implemented.');
  }

  Future<void> clearLabelLearning() {
    throw UnimplementedError('clearLabelLearning() has not been implemented.');
  }

  Future<void> configLcd(LcdOpt opt) {
    throw UnimplementedError('configLcd() has not been implemented.');
  }

  Future<void> showLcdImage(Uint8List img) {
    throw UnimplementedError('showLcdBitmap() has not been implemented.');
  }

  Future<void> setLcdLogo(Uint8List img) {
    throw UnimplementedError('showLcdBitmap() has not been implemented.');
  }

  Future<void> openCashBox() {
    throw UnimplementedError('openCashBox() has not been implemented.');
  }
}
