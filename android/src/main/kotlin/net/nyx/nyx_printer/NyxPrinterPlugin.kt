package net.nyx.nyx_printer

import android.annotation.SuppressLint
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.graphics.BitmapFactory
import android.os.Build
import android.os.IBinder
import android.os.Looper
import android.util.Log
import androidx.core.view.accessibility.AccessibilityEventCompat.setAction
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.util.HandlerCompat
import net.nyx.nyx_printer.PrinterResult.SDK_SERVICE_NOT_BIND
import net.nyx.nyx_printer.PrinterResult.SDK_UNKNOWN_ERR
import net.nyx.nyx_printer.PrinterResult.msg
import net.nyx.printerservice.print.IPrinterService
import net.nyx.printerservice.print.PrintTextFormat
import java.io.ByteArrayInputStream


/** NyxPrinterPlugin */
class NyxPrinterPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var context: Context? = null;

    private var printerService: IPrinterService? = null
    private val connService: ServiceConnection = object : ServiceConnection {
        override fun onServiceDisconnected(name: ComponentName) {
            Log.d("PrinterPlugin", "Printer service disconnected")
            printerService = null
            HandlerCompat.createAsyncHandler(Looper.myLooper()).postDelayed({ bindService() }, 2000)
        }

        override fun onServiceConnected(name: ComponentName, service: IBinder) {
            Log.d("PrinterPlugin", "Printer service connected")
            printerService = IPrinterService.Stub.asInterface(service)

        }
    }

    private fun bindService() {
        var prefix = "net.nyx"
        if (Build.VERSION.SDK_INT == Build.VERSION_CODES.TIRAMISU
            && "SC9863A" == getSystemProperty("ro.soc.model")
        ) {
            prefix = "com.incar"
        }
        val intent = Intent()
        intent.setPackage("$prefix.printerservice")
        intent.setAction("$prefix.printerservice.IPrinterService")
        val bind = context?.bindService(intent, connService, Context.BIND_AUTO_CREATE)
        if (bind?.not() == true) {
            Log.e("PrinterPlugin", "Bind printer service failed, please check the device")
        }
    }

    private fun unbindService(context: Context) {
        context.unbindService(connService)
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "nyx_printer_flutter")
        channel.setMethodCallHandler(this)

        context = flutterPluginBinding.applicationContext
        bindService()
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        Log.d("PrinterPlugin", "onDetachedFromEngine")
        unbindService(binding.applicationContext)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (printerService == null) {
            result.error(SDK_SERVICE_NOT_BIND.toString(), msg(SDK_SERVICE_NOT_BIND), null)
            return
        }
        try {
            if (call.method == "getServiceVersion") {
                result.success(printerService?.serviceVersion)
            } else if (call.method == "getPrinterVersion") {
                val res = arrayOfNulls<String>(1)
                val ret = printerService?.getPrinterVersion(res)
                if (ret == 0) {
                    result.success(res[0])
                } else {
                    result.error(ret.toString(), msg(ret), null)
                }
            } else if (call.method == "getPrinterModel") {
                val res = arrayOfNulls<String>(1)
                val ret = printerService?.getPrinterModel(res)
                if (ret == 0) {
                    result.success(res[0])
                } else {
                    result.error(ret.toString(), msg(ret), null)
                }
            } else if (call.method == "getPrinterStatus") {
                val ret = printerService?.getPrinterStatus()
                if (ret != null) {
                    if (ret < -1200 && ret > -1300 || ret == 0) {
                        result.success(ret)
                    } else {
                        result.error(ret.toString(), msg(ret), null)
                    }
                }
            } else if (call.method == "paperOut") {
                val arg = call.argument<Int>("px") ?: 0
                var ret: Int? = 0
                if (arg > 0) {
                    ret = printerService?.paperOut(arg)
                }
                handleResult(ret, result)
            } else if (call.method == "paperBack") {
                val arg = call.argument<Int>("px") ?: 0
                var ret: Int? = 0
                if (arg > 0) {
                    ret = printerService?.paperBack(arg)
                }
                handleResult(ret, result)
            } else if (call.method == "printText") {
                val text = call.argument<String>("text")
                val style = call.argument<Map<String, Any?>>("style")
                val textWidth = call.argument<Int>("textWidth")
                val align = call.argument<Int>("align")
                val textFormat = convertStyleMap(style)
                if (textWidth == null) {
                    val ret = printerService?.printText(text, textFormat)
                    handleResult(ret, result)
                } else {
                    val ret = printerService?.printText2(text, textFormat, textWidth, align ?: 0)
                    handleResult(ret, result)
                }
            } else if (call.method == "printBarcode") {
                val data = call.argument<String>("data")!!
                val width = call.argument<Int>("width")!!
                val height = call.argument<Int>("height")!!
                val textPosition = call.argument<Int>("textPosition")!!
                val align = call.argument<Int>("align")!!
                val symbology = call.argument<Int>("symbology")!!
                val ret = printerService?.printBarcode(
                    data,
                    width,
                    height,
                    textPosition,
                    align,
                    symbology
                )
                handleResult(ret, result)
            } else if (call.method == "printQrCode") {
                val data = call.argument<String>("data")!!
                val width = call.argument<Int>("width")!!
                val height = call.argument<Int>("height")!!
                val align = call.argument<Int>("align")!!
                val ret = printerService?.printQrCode(data, width, height, align)
                handleResult(ret, result)
            } else if (call.method == "printBitmap") {
                val img = call.argument<ByteArray>("img")
                val type = call.argument<Int>("type")!!
                val align = call.argument<Int>("align")!!
                val bitmap = BitmapFactory.decodeStream(ByteArrayInputStream(img))
                val ret = printerService?.printBitmap(bitmap, type, align)
                handleResult(ret, result)
            } else if (call.method == "labelLocate") {
                val labelHeight = call.argument<Int>("labelHeight")!!
                val labelGap = call.argument<Int>("labelGap")!!
                val ret = printerService?.labelLocate(labelHeight, labelGap)
                handleResult(ret, result)
            } else if (call.method == "labelPrintEnd") {
                val ret = printerService?.labelPrintEnd()
                handleResult(ret, result)
            } else if (call.method == "labelLocateAuto") {
                val labelHeight = call.argument<Int>("labelHeight")!!
                val labelGap = call.argument<Int>("labelGap")!!
                val ret = printerService?.labelLocateAuto(labelHeight, labelGap)
                handleResult(ret, result)
            } else if (call.method == "labelDetectAuto") {
                val ret = printerService?.labelDetectAuto()
                handleResult(ret, result)
            } else if (call.method == "hasLabelLearning") {
                val ret = printerService?.hasLabelLearning()
                result.success(ret)
            } else if (call.method == "clearLabelLearning") {
                val ret = printerService?.clearLabelLearning()
                handleResult(ret, result)
            } else if (call.method == "printRasterData") {
                val data = call.argument<ByteArray>("data")
                val ret = printerService?.printRasterData(data)
                handleResult(ret, result)
            } else if (call.method == "printEscposData") {
                val data = call.argument<ByteArray>("data")
                val ret = printerService?.printEscposData(data)
                result.success(ret)
            } else if (call.method == "printTableText") {
                val texts = call.argument<List<String>>("texts")!!.toTypedArray()
                val weights = call.argument<List<Int>>("weights")!!.toTypedArray()
                val styles = call.argument<List<Map<String, Any>>>("styles")!!
                val formats = styles.map { convertStyleMap(it) }.toTypedArray()
                val ret = printerService?.printTableText(texts, weights.toIntArray(), formats)
                handleResult(ret, result)
            } else if (call.method == "printEndAutoOut") {
                val ret = printerService?.printEndAutoOut()
                handleResult(ret, result)
            } else if (call.method == "showLcdBitmap") {
                val img = call.argument<ByteArray>("img")
                val bitmap = BitmapFactory.decodeStream(ByteArrayInputStream(img))
                val ret = printerService?.showLcdBitmap(bitmap)
                handleResult(ret, result)
            } else if (call.method == "configLcd") {
                val lcdOpt = call.argument<Int>("opt")!!
                val ret = printerService?.configLcd(lcdOpt)
                handleResult(ret, result)
            } else if (call.method == "openCashBox") {
                val ret = printerService?.openCashBox()
                handleResult(ret, result)
            } else if (call.method == "triggerQscScan") {
                val opt = call.argument<Int>("opt")!!
                val ret = printerService?.triggerQscScan(opt)
                handleResult(ret, result)
            } else if (call.method == "setLcdLogo") {
                val img = call.argument<ByteArray>("img")
                val bitmap = BitmapFactory.decodeStream(ByteArrayInputStream(img))
                val ret = printerService?.setLcdLogo(bitmap)
                handleResult(ret, result)
            } else if (call.method == "getPrinterDensity") {
                val res = IntArray(1)
                val ret = printerService?.getPrinterDensity(res)
                handleResult(ret, result, res[0])
            } else if (call.method == "setPrinterDensity") {
                val p = call.argument<Int>("density")!!
                val ret = printerService?.setPrinterDensity(p)
                handleResult(ret, result)
            } else if (call.method == "setPaperWidth") {
                val p = call.argument<Int>("width")!!
                val ret = printerService?.setPaperWidth(p)
                handleResult(ret, result)
            } else {
                result.notImplemented()
            }
        } catch (e: Exception) {
            result.error(SDK_UNKNOWN_ERR.toString(), msg(SDK_UNKNOWN_ERR), null)
        }
    }

    private fun handleResult(ret: Int?, result: Result, data: Any? = null) {
        if (ret == 0) {
            result.success(data)
        } else {
            result.error(ret.toString(), msg(ret), null)
        }
    }

    private fun convertStyleMap(style: Map<String, Any?>?): PrintTextFormat {
        val textFormat = PrintTextFormat()
        if (style != null) {
            textFormat.textSize = style["textSize"] as Int
            textFormat.isUnderline = style["underline"] as Boolean
            textFormat.textScaleX = (style["textScaleX"] as Double).toFloat()
            textFormat.textScaleY = (style["textScaleY"] as Double).toFloat()
            textFormat.letterSpacing = (style["letterSpacing"] as Double).toFloat()
            textFormat.lineSpacing = (style["lineSpacing"] as Double).toFloat()
            textFormat.topPadding = style["topPadding"] as Int
            textFormat.leftPadding = style["leftPadding"] as Int
            textFormat.ali = style["align"] as Int
            val font = style["font"]
            if (font != null) {
                textFormat.font = 5
                textFormat.path = font.toString()
            }
        }
        return textFormat
    }

    private fun getSystemProperty(key: String?): String? {
        var result: String? = null
        try {
            val c = Class.forName("android.os.SystemProperties")
            val get = c.getMethod("get", String::class.java)
            result = get.invoke(c, key) as String
        } catch (e: java.lang.Exception) {
            e.printStackTrace()
        }
        return result
    }
}
