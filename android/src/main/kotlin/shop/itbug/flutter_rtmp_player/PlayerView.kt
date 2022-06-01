package com.itbug.flutter_rtmp_plugin

import AndroidOptions
import android.app.Activity
import android.content.Context
import android.view.LayoutInflater
import android.view.View
import com.itbug.flutter_rtmp_plugin.model.ChangeCacheParam
import com.itbug.flutter_rtmp_plugin.model.ChangeModeParams
import com.itbug.flutter_rtmp_plugin.model.ChangeUrlParams
import com.itbug.flutter_rtmp_plugin.model.LogLevelParam
import com.itbug.flutter_rtmp_plugin.util.ResultMakeUtil
import com.itbug.flutter_rtmp_plugin.util.parse
import com.itbug.flutter_rtmp_plugin.view.MyVideoView
import com.shuyu.gsyvideoplayer.GSYVideoManager
import com.shuyu.gsyvideoplayer.builder.GSYVideoOptionBuilder
import com.shuyu.gsyvideoplayer.cache.CacheFactory
import com.shuyu.gsyvideoplayer.cache.ProxyCacheManager
import com.shuyu.gsyvideoplayer.listener.GSYSampleCallBack
import com.shuyu.gsyvideoplayer.player.IjkPlayerManager
import com.shuyu.gsyvideoplayer.player.PlayerFactory
import com.shuyu.gsyvideoplayer.player.SystemPlayerManager
import com.shuyu.gsyvideoplayer.utils.Debuger
import com.shuyu.gsyvideoplayer.utils.OrientationUtils
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import tv.danmaku.ijk.media.exo2.Exo2PlayerManager
import tv.danmaku.ijk.media.exo2.ExoPlayerCacheManager
import tv.danmaku.ijk.media.player.IjkMediaPlayer


class PlayerView(
    context: Context?,
    viewId: Int,
    private val args: Any?,
    flutterPluginBinding: FlutterPlugin.FlutterPluginBinding,
    private val activity: Activity,
) : PlatformView, MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    ///配置
    private val gsyVideoOption = GSYVideoOptionBuilder()

    /// 播放器实例
    private var detailPlayer: MyVideoView = LayoutInflater.from(context!!)
        .inflate(R.layout.fragment_video_player_view, null) as MyVideoView

    /// 横屏工具
    var orientationUtils: OrientationUtils = OrientationUtils(activity, detailPlayer)

    /// 连接flutter端侧的方法通道
    var methodChannel: MethodChannel =
        MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_rtmp_plugin_$viewId")

    /// 流通道
    private var eventChannel: EventChannel =
        EventChannel(flutterPluginBinding.binaryMessenger, "play-status-channel-$viewId")

    private var sink: EventChannel.EventSink? = null

    /// 是否正在播放中
    var isPlay = false

    /**
     * 初始化
     */
    init {
        methodChannel.setMethodCallHandler(this)
        eventChannel.setStreamHandler(this)
    }


    /**
     * 返回视图
     */
    override fun getView(): View {
        return detailPlayer.rootView
    }

    /**
     * 热更新销毁,做一些资源释放的事
     */
    override fun dispose() {

        if (isPlay) {
            detailPlayer.release()
        }
        ///释放资源,取消监听
        detailPlayer.setVideoAllCallBack(null)
    }


    /**
     * 隐藏控制器UI
     */
    private fun hideUi() {
        detailPlayer.hideUi()
    }

    /**
     * 禁止息屏
     */
    private fun disableScreenCapture() {
//        activity.window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        detailPlayer.keepScreenOn = true
    }

    /**
     * 获取当前播放器的当前状态
     */
    private fun getStatus(result: MethodChannel.Result) {
        val state = detailPlayer.currentState
        result.success(state)
    }


    /**
     * 处理flutter端函数
     */
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "set-option" -> setOption(call.arguments)
            "change-play-url" -> changePlayUrl(call.arguments)
            "pause" -> pause()
            "resume" -> resume()
            "reset" -> reset()
            "stop" -> stop()
            "change-manager" -> changeManager(call.arguments)
            "change-cache" -> changeCache(call.arguments)
            "debug" -> loggerLevel(call.arguments)
            "play" -> play()
            "hideUi" -> hideUi()
            "disableScreenCapture" -> disableScreenCapture()
            "get-current-state" -> getStatus(result)
        }

    }


    /**
     * 设置日志等级
     */
    private fun loggerLevel(args: Any?) {
        args?.let {
            val (mode) = args.parse<LogLevelParam>()
            println("mode = $mode")
            when (mode) {
                1 -> IjkPlayerManager.setLogLevel(IjkMediaPlayer.IJK_LOG_DEFAULT)
                2 -> IjkPlayerManager.setLogLevel(IjkMediaPlayer.IJK_LOG_VERBOSE)
                3 -> IjkPlayerManager.setLogLevel(IjkMediaPlayer.IJK_LOG_DEBUG)
                4 -> IjkPlayerManager.setLogLevel(IjkMediaPlayer.IJK_LOG_INFO)
                5 -> IjkPlayerManager.setLogLevel(IjkMediaPlayer.IJK_LOG_WARN)
                6 -> IjkPlayerManager.setLogLevel(IjkMediaPlayer.IJK_LOG_ERROR)
                7 -> IjkPlayerManager.setLogLevel(IjkMediaPlayer.IJK_LOG_FATAL)
                8 -> IjkPlayerManager.setLogLevel(IjkMediaPlayer.IJK_LOG_SILENT)
                else -> IjkPlayerManager.setLogLevel(IjkMediaPlayer.IJK_LOG_UNKNOWN)
            }
            Debuger.disable()

        }
    }


    /**
     * 停止播放
     */
    private fun stop() {
        detailPlayer.release()
    }

    /**
     * 全局设置之切换内核
     */
    private fun changeManager(args: Any?) {
        args?.let {
            val params = it.parse<ChangeModeParams>()
            when (params.mode) {
                0 -> PlayerFactory.setPlayManager(Exo2PlayerManager::class.java)
                1 -> PlayerFactory.setPlayManager(SystemPlayerManager::class.java)
                else -> PlayerFactory.setPlayManager(IjkPlayerManager::class.java)
            }

        }
    }

    /**
     * 切换代理模式
     */
    private fun changeCache(args: Any?) {
        args?.let {
            val modeParams = it.parse<ChangeCacheParam>()
            when (modeParams.mode) {
                0 -> CacheFactory.setCacheManager(ExoPlayerCacheManager::class.java)
                else -> CacheFactory.setCacheManager(ProxyCacheManager::class.java)
            }
        }
    }

    /**
     * 暂停播放
     */
    private fun pause() {
        detailPlayer.onVideoPause()
    }

    /**
     * 恢复播放
     */
    private fun resume() {
        detailPlayer.onVideoResume()
    }

    /**
     * 重新开始播放,切换到正常状态
     */
    private fun reset() {
        detailPlayer.onVideoReset()
    }

    /**
     * 开始播放
     */
    private fun play() {
        detailPlayer.startPlayLogic()
    }


    /**
     * 改变播放的URL
     */
    private fun changePlayUrl(args: Any?) {
        args?.let {
            val params = it.parse<ChangeUrlParams>()
            gsyVideoOption.setUrl(params.url).build(detailPlayer)
        }
    }

    /**
     * 设置是否需要静音
     */
    private fun setMute(args: Any?) {
        args?.let {
            GSYVideoManager.instance().isNeedMute = false
        }
    }

    /**
     * 初始化配置
     */
    private fun setOption(args: Any?) {
        if (args == null) {
            return
        }
        val options = args.parse<AndroidOptions>()
        gsyVideoOption
            .setIsTouchWiget(options.isTouchWidget)
            .setRotateViewAuto(options.rotateViewAuto)
            .setLockLand(options.lockLand)
            .setAutoFullWithSize(options.autoFullWithSize)
            .setShowFullAnimation(options.showFullAnimation)
            .setNeedLockFull(options.needLockFull)
            .setCacheWithPlay(options.cacheWithPlay)
            .setVideoTitle(options.videoTitle)
            .setNeedOrientationUtils(options.needOrientationUtils)
            .setVideoAllCallBack(object : GSYSampleCallBack() {
                override fun onPrepared(url: String, vararg objects: Any) {
                    super.onPrepared(url, *objects)
                    //开始播放了才能旋转和全屏
                    orientationUtils.isEnable = detailPlayer.isRotateWithSystem;
                    isPlay = true;
                }

                override fun onQuitFullscreen(url: String, vararg objects: Any) {
                    super.onQuitFullscreen(url, *objects)
                    // ------- ！！！如果不需要旋转屏幕，可以不调用！！！-------
                    // 不需要屏幕旋转，还需要设置 setNeedOrientationUtils(false)
//                        if (orientationUtils != null) {
//                            orientationUtils.backToProtVideo();
//                        }
                }
            }).setLockClickListener { view, lock ->
                orientationUtils.isEnable = !lock
            }.setGSYStateUiListener {
                sink?.success(ResultMakeUtil.makeStateResult(it))
            }.build(detailPlayer)
    }


    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        events?.let {
            sink = it
        }
    }

    override fun onCancel(arguments: Any?) {
        sink = null
    }
}