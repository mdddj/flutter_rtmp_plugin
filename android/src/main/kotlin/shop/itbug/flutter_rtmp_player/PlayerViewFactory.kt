package com.itbug.flutter_rtmp_plugin

import android.app.Activity
import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class PlayerViewFactory(private val flutterPluginBinding: FlutterPlugin.FlutterPluginBinding,private val activity: Activity) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    private lateinit var view: PlayerView

    /// 创建视图
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        view = PlayerView(context, viewId, args, flutterPluginBinding,activity)
        return view
    }

}