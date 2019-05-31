package com.wisecrab.wc_flutter_share

import android.content.Intent
import androidx.annotation.Nullable
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
            "share" -> onShare(call.arguments)
            else -> result.notImplemented()
        }
    }


    @Suppress("UNCHECKED_CAST")
    private fun onShare(arguments: Any) {
        val argMap = arguments as Map<String, String>

        val sharePopupTitle = argMap["sharePopupTitle"]
        val text = argMap["text"]
        val subject = argMap["subject"]
        val fileName = argMap["fileName"]
        val mimeType = argMap["mimeType"]
        val activeContext = registrar.activeContext()

        val shareIntent = Intent(Intent.ACTION_SEND)
        shareIntent.type = mimeType

        if (text != null)
            shareIntent.putExtra(Intent.EXTRA_TEXT, text)
        if (subject != null)
            shareIntent.putExtra(Intent.EXTRA_SUBJECT, subject)

        if (fileName != null) {
            val file = File(activeContext.cacheDir, fileName)
            val fileProviderAuthority = activeContext.packageName + PROVIDER_AUTH_EXT
            val contentUri = FileProvider.getUriForFile(activeContext, fileProviderAuthority, file)
            shareIntent.putExtra(Intent.EXTRA_STREAM, contentUri)
        }

        activeContext.startActivity(Intent.createChooser(shareIntent, sharePopupTitle))
    }
}
