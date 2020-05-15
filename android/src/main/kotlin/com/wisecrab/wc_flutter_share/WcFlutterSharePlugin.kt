package com.wisecrab.wc_flutter_share

import android.content.Context
import android.content.Intent
import androidx.annotation.NonNull
import androidx.core.content.FileProvider

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.io.File

class WcFlutterSharePlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var context: Context? = null;

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "wc_flutter_share")
        channel.setMethodCallHandler(this);
    }

    companion object {
        const val PROVIDER_AUTH_EXT = ".fileprovider.github.com/com/wisecrab/wc-flutter-share"

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "wc_flutter_share")
            channel.setMethodCallHandler(WcFlutterSharePlugin())
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "share" -> onShare(call.arguments)
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun onShare(arguments: Any) {
        val argMap = arguments as Map<*, *>

        val sharePopupTitle = argMap["sharePopupTitle"] as String
        val text = argMap["text"] as String?
        val subject = argMap["subject"] as String?
        val fileName = argMap["fileName"] as String?
        val mimeType = argMap["mimeType"] as String
        val activeContext = context ?: return;

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

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.context = binding.activity;
    }

    override fun onDetachedFromActivity() {
        this.context = null;
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        this.context = binding.activity;
    }

    override fun onDetachedFromActivityForConfigChanges() {
        this.context = null;
    }

}
