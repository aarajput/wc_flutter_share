package com.wisecrab.wc_flutter_share

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import androidx.annotation.NonNull
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File

class WcFlutterSharePlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel : MethodChannel
  private var context: Context? = null

  companion object {
    const val PROVIDER_AUTH_EXT = ".fileprovider.github.com/com/wisecrab/wc-flutter-share"
  }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "wc_flutter_share")
    channel.setMethodCallHandler(this)
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
    val activeContext = context ?: return

    val shareIntent = Intent(Intent.ACTION_SEND)
    shareIntent.type = mimeType

    if (text != null)
      shareIntent.putExtra(Intent.EXTRA_TEXT, text)
    if (subject != null)
      shareIntent.putExtra(Intent.EXTRA_SUBJECT, subject)

    val chooser: Intent = Intent.createChooser(shareIntent, sharePopupTitle)
    if (fileName != null) {
      val file = File(activeContext.cacheDir, fileName)
      val fileProviderAuthority = activeContext.packageName + PROVIDER_AUTH_EXT
      val contentUri = FileProvider.getUriForFile(activeContext, fileProviderAuthority, file)
      shareIntent.putExtra(Intent.EXTRA_STREAM, contentUri)

      val resInfoList: List<ResolveInfo> = activeContext.packageManager.queryIntentActivities(chooser, PackageManager.MATCH_DEFAULT_ONLY)
      for (resolveInfo in resInfoList) {
        val packageName: String = resolveInfo.activityInfo.packageName
        activeContext.grantUriPermission(packageName, contentUri, Intent.FLAG_GRANT_WRITE_URI_PERMISSION or Intent.FLAG_GRANT_READ_URI_PERMISSION)
      }
    }

    activeContext.startActivity(chooser)
  }


  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    this.context = binding.activity
  }

  override fun onDetachedFromActivity() {
    this.context = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    this.context = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    this.context = null
  }
}
