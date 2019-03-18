package com.trolik.video_example

import android.content.Intent
import android.os.Bundle
import android.support.v4.content.FileProvider
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import life.knowledge4.videotrimmer.utils.FileUtils
import java.io.File



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

        val path = call.argument<String>("path")
        share(path!!)

        result.success(true)
      } else if (call.method == "trim") {
        if (call.arguments !is Map<*, *>) {
          throw IllegalArgumentException("Map argument expected")
        }

        val path = call.argument<String>("path")
        trimVideo(path!!)

        result.success(true)
      } else {
        result.notImplemented()
      }
    }
  }

  private fun trimVideo(path: String) {
    val video = File(path)
    val uri = FileProvider.getUriForFile(this, "com.trolik.video_example.fileProvider", video)

    val intent = Intent(this, TrimmerActivity::class.java)
    intent.putExtra(EXTRA_VIDEO_PATH, FileUtils.getPath(this, uri))
    startActivity(intent)
  }

  private fun share(path: String) {
    if (path.isEmpty()) {
      throw IllegalArgumentException("Non-empty text expected")
    }

    val video = File(path)
    val uri = FileProvider.getUriForFile(this, "com.trolik.video_example.fileProvider", video)

    val shareIntent = Intent().apply {
      setAction(Intent.ACTION_SEND)
      putExtra(Intent.EXTRA_STREAM, uri)
      setType("video/mp4")
    }

    val chooserIntent = Intent.createChooser(shareIntent, null)
    startActivity(chooserIntent)
  }

  companion object {
      @JvmField
      val EXTRA_VIDEO_PATH = "EXTRA_VIDEO_PATH"
  }
}
