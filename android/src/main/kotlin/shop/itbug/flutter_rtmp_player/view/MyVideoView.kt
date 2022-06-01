package com.itbug.flutter_rtmp_plugin.view

import android.content.Context
import android.util.AttributeSet
import com.shuyu.gsyvideoplayer.video.StandardGSYVideoPlayer

/// 自定义视频播放器,空UI
class MyVideoView : StandardGSYVideoPlayer {


    constructor(context: Context,fullFlag: Boolean) : super(context,fullFlag)
    constructor(context: Context): super(context)
    constructor(context: Context,attrs: AttributeSet): super(context, attrs)


    override fun touchSurfaceMoveFullLogic(absDeltaX: Float, absDeltaY: Float) {
        super.touchSurfaceMoveFullLogic(absDeltaX, absDeltaY)
        mChangePosition = false
        mChangeVolume = false
        mBrightness = false
        isFullHideActionBar = false
    }


    /**
     * 隐藏控制器UI
     */
    fun hideUi() {
        println("隐藏UI")
        hideAllWidget()
    }
}