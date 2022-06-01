package com.itbug.flutter_rtmp_plugin

import android.util.Log
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding


class FlutterRtmpPlugin : FlutterPlugin, ActivityAware {

    private lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {}

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        /// 在onAttachedToEngine之后执行,导致不能传activity到PlayerView类里面去
        val pvf = PlayerViewFactory(flutterPluginBinding,binding.activity)
        flutterPluginBinding.platformViewRegistry.registerViewFactory(
            "FlutterRtmpPluginAndroidView",
            pvf
        )
        val activity = binding.activity

    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onDetachedFromActivity() {
    }
}
