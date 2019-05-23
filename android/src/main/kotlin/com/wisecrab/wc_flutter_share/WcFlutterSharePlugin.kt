package com.wisecrab.wc_flutter_share

import android.content.Intent
import androidx.core.content.FileProvider
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.io.File

class WcFlutterSharePlugin(private val registrar: Registrar) : MethodCallHandler {


    companion object {
        const val PROVIDER_AUTH_EXT = ".fileprovider.github.com/com/wisecrab/wc-flutter-share"
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "wc_flutter_share")
            channel.setMethodCallHandler(WcFlutterSharePlugin(registrar))
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "text" -> onText(call.arguments)
            "file" -> onFile(call.arguments)
            else -> result.notImplemented()
        }
    }

    @Suppress("UNCHECKED_CAST")
    private fun onText(args: Any) {
        val argMap = args as Map<String, String>
        val title = argMap["title"]
        val textToSend = argMap["text"]
        val mimeType = argMap["mimeType"]

        val context = registrar.activeContext()
        val shareIntent = Intent(Intent.ACTION_SEND)
        shareIntent.type = mimeType
        shareIntent.putExtra(Intent.EXTRA_TEXT, textToSend)
        context.startActivity(Intent.createChooser(shareIntent, title))

    }


    @Suppress("UNCHECKED_CAST")
    private fun onFile(arguments: Any) {
        val argMap = arguments as Map<String, String>
        val sharePopupTitle = argMap["sharePopupTitle"]
        val textToShare = argMap["textToShare"]
        val subjectToShare = argMap["subjectToShare"]
        val fileName = argMap["fileName"]
        val mimeTypeOfFile = argMap["mimeTypeOfFile"]
        val activeContext = registrar.activeContext()

        val shareIntent = Intent(Intent.ACTION_SEND)
        shareIntent.type = mimeTypeOfFile
        val file = File(activeContext.cacheDir, fileName)
        val fileProviderAuthority = activeContext.packageName + PROVIDER_AUTH_EXT
        val contentUri = FileProvider.getUriForFile(activeContext, fileProviderAuthority, file)
        shareIntent.putExtra(Intent.EXTRA_STREAM, contentUri)
        if (textToShare != null)
            shareIntent.putExtra(Intent.EXTRA_TEXT, textToShare)
        if (subjectToShare != null)
            shareIntent.putExtra(Intent.EXTRA_SUBJECT, subjectToShare)
        activeContext.startActivity(Intent.createChooser(shareIntent, sharePopupTitle))
    }
}
