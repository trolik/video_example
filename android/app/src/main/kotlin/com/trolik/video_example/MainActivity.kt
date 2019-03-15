package com.trolik.video_example

import android.content.Intent
import android.os.Bundle
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant



class MainActivity: FlutterActivity() {
  private val CHANNEL = "samples.flutter.io/share_file"

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)

    GeneratedPluginRegistrant.registerWith(this)

    MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
      if (call.method == "share") {
        if (call.arguments !is Map<*, *>) {
          throw IllegalArgumentException("Map argument expected")
        }

        val text = call.argument<String>("text")
        share(text!!)

        result.success(true)
      } else {
        result.notImplemented()
      }
    }
  }

  private fun share(text: String) {
    if (text.isEmpty()) {
      throw IllegalArgumentException("Non-empty text expected")
    }

    val shareIntent = Intent()
    shareIntent.setAction(Intent.ACTION_SEND)
    shareIntent.putExtra(Intent.EXTRA_TEXT, text)
    shareIntent.setType("text/plain")

    val chooserIntent = Intent.createChooser(shareIntent, null)
    startActivity(chooserIntent)
  }
}
