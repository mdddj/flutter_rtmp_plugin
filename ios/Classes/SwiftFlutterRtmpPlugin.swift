import Flutter
import PLPlayerKit
import SwiftyJSON
import UIKit

public class SwiftFlutterRtmpPlugin: NSObject, FlutterPlugin, FlutterPlatformView, FlutterStreamHandler, PLPlayerDelegate {
    /// 默认的播放配置
    let option = PLPlayerOption.default()
    var sink: FlutterEventSink?
    var player: PLPlayer?
    var uiView: UIView!

    var frame: CGRect? // 视图大小
    var viewId: Int64? // 视图ID
    var args: Any? // 参数
    var flutterBinaryMessager: FlutterBinaryMessenger?

    /// flutter和iOS通讯
    var channel: FlutterMethodChannel?

    init(frame: CGRect?, viewId: Int64, args: Any?, flutterBinaryMessager: FlutterBinaryMessenger?) {
        super.init()

        self.flutterBinaryMessager = flutterBinaryMessager
        self.viewId = viewId
        self.args = args
        self.frame = frame

//        let params = args as! NSMutableDictionary
//        let width = params.value(forKey: "width")
//        let height = params.value(forKey: "height")
//        let frame = CGRect(x: 0, y: 0, width: width as! Int, height: height as! Int)
        uiView = UIView()

        let methedChannelName = "flutter_rtmp_plugin_\(String(viewId))"

        channel = FlutterMethodChannel(name: methedChannelName, binaryMessenger: flutterBinaryMessager!)
        channel?.setMethodCallHandler(handle)

        let playStatusChannel = FlutterEventChannel(name: "play-status-channel-\(String(viewId))", binaryMessenger: flutterBinaryMessager!)
        playStatusChannel.setStreamHandler(self)
    }

    public func view() -> UIView {
        return uiView
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        registrar.register(RtmpViewFactory(binaryMessenger: registrar.messenger()), withId: "RtplPlayView")
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        // 初始化配置
        case "set-option":
            if let parasm = call.arguments {
                let json = JSON(parasm)
                print(json)

                /// 设置 接收/发送数据包超时时间间隔所对应的键值，单位为 s ，默认配置为 10s
                /// 该参数仅对 rtmp/flv 直播生效
                /// 建议设置正数。设置的值小于等于 0 时，表示禁用超时，播放卡住时，将无超时回调。
                if let pLPlayerOptionKeyTimeoutIntervalForMediaPackets = json["timeoutIntervalForMediaPackets"].int {
                    option.setOptionValue(pLPlayerOptionKeyTimeoutIntervalForMediaPackets, forKey: PLPlayerOptionKeyTimeoutIntervalForMediaPackets)
                }

                /// 一级缓存大小，单位为 ms，默认为 2000ms，增大该值可以减小播放过程中的卡顿率，但会增大弱网环境的最大累积延迟
                /// 该缓存存放的是网络层读取到的数据，为保证实时性，超过该缓存池大小的过期音频数据将被丢弃，视频将加速渲染追上音频
                if let pLPlayerOptionKeyMaxL1BufferDuration = json["maxL1BufferDuration"].int {
                    option.setOptionValue(pLPlayerOptionKeyMaxL1BufferDuration, forKey: PLPlayerOptionKeyMaxL1BufferDuration)
                }

                /// 默认二级缓存大小，单位为 ms，默认为 300ms，增大该值可以减小播放过程中的卡顿率，但会增大弱网环境的最大累积延迟
                /// 该缓存存放的是解码之后待渲染的数据，如果该缓存池满，则二级缓存将不再接收来自一级缓存的数据
                if let pLPlayerOptionKeyMaxL2BufferDuration = json["maxL2BufferDuration"].int {
                    option.setOptionValue(pLPlayerOptionKeyMaxL2BufferDuration, forKey: PLPlayerOptionKeyMaxL2BufferDuration)
                }

                /// 用于是否根据最小缓冲时间和最大缓冲时间，使播放速度变慢或变快
                if let cacheBufferDurationSpeedAdjust = json["cacheBufferDurationSpeedAdjust"].bool {
                    option.setOptionValue(cacheBufferDurationSpeedAdjust, forKey: PLPlayerOptionKeyCacheBufferDurationSpeedAdjust)
                }

                /// 用于是否根据最小缓冲时间和最大缓冲时间，使播放速度变慢或变快
                /// 默认 YES ，即底层会自动根据缓存 buffer 调节速率。注意点播播放的时候，需关闭这个参数
                ///
                /// 0 不开启 1 开启
                if let pLPlayerOptionKeyVideoToolbox = json["videoToolbox"].bool {
                    option.setOptionValue(pLPlayerOptionKeyVideoToolbox, forKey: PLPlayerOptionKeyVideoToolbox)
                }

                /// 配置日志级别
                if let logLevelValue = json["logLevel"].int {
                    option.setOptionValue(logLevelValue, forKey: PLPlayerOptionKeyLogLevel)
                }

                /// 开启 DNS 解析，默认使用系统 API 解析
                if let dnsManager = json["dnsManager"].string {
                    option.setOptionValue(dnsManager, forKey: PLPlayerOptionKeyDNSManager)
                }

                /// 该属性仅对点播 mp4 有效, 当 PLPlayerOptionKeyVideoCacheFolderPath 有值时，默认关闭 DNS  解析
                if let videoCacheFolderPath = json["videoCacheFolderPath"].string {
                    option.setOptionValue(videoCacheFolderPath, forKey: PLPlayerOptionKeyVideoCacheFolderPath)
                }

                /// 视频缓存目录名称是否加密，默认不加密,当 PLPlayerOptionKeyVideoCacheFolderPath 有值时，成效
                if let videoFileNameEncode = json["videoFileNameEncode"].bool {
                    option.setOptionValue(videoFileNameEncode, forKey: PLPlayerOptionKeyVideoFileNameEncode)
                }

                /// 视频预设值播放 URL 格式类型,该参数用于加快首开，提前告知播放器流类型，默认 kPLPLAY_FORMAT_UnKnown
                if let videoPreferFormat = json["videoPreferFormat"].int {
                    option.setOptionValue(videoPreferFormat, forKey: PLPlayerOptionKeyVideoPreferFormat)
                }

                /// 视频缓存扩展名
                if let videoCacheExtensionName = json["videoCacheExtensionName"].string {
                    option.setOptionValue(videoCacheExtensionName, forKey: PLPlayerOptionKeyVideoCacheExtensionName)
                }

                /// SDK 设备 ID
                if let sdkId = json["sdkId"].string {
                    option.setOptionValue(sdkId, forKey: PLPlayerOptionKeySDKID)
                }

                /// 该参数用于设置 http 的 header
                /// 不可包含 "\n" 或 "\r"，包含"\n" 或 "\r" 则设置无效
                if let headUserAgent = json["headUserAgent"].string {
                    option.setOptionValue(headUserAgent, forKey: PLPlayerOptionKeyHeadUserAgent)
                }

                /// 该参数用于自定义渲染，设置播放器解码回调数据格式
                if let videoOutputFormat = json["videoOutputFormat"].string {
                    option.setOptionValue(videoOutputFormat, forKey: PLPlayerOptionKeyVideoOutputFormat)
                }
            }

            break 
        // 初始化播放器
        case "init-player":
            if let arguments = call.arguments {
              
                let argsd = arguments as! NSMutableDictionary
                let urlOpt = argsd["playerUrl"]

                if let url = urlOpt {
                    player = nil

                    player = PLPlayer(url: URL(string: url as! String), option: option)
                    guard let pv = player?.playerView else {
                        return
                    }

                    let params = args as! NSMutableDictionary
                    print(params)
                    let width = params.value(forKey: "width")
                    let height = params.value(forKey: "height")
                    pv.frame = CGRect(x: 0, y: 0, width: width as! Int, height: height as! Int)

                    uiView.addSubview(pv)
                    player?.delegate = self
                }
            }
            break
        case "play":
            player?.play()
            break
        case "stop":
            player?.stop()
            break
        case "pause":
            player?.pause()
            break
        case "resume":
            player?.resume()
            break

        /// 改变组件的尺寸
        case "size-change":
//            let params = call.arguments as! NSMutableDictionary
//            let width = params.value(forKey: "width")
//            let height = params.value(forKey: "height")
//            let frame = CGRect(x: 0, y: 0, width: width as! Int, height: height as! Int)
//
//            uiView.frame = frame
//            self.player?.playerView?.frame = frame
            break
        default:
            print("其他方法接收到\(call.method)")
        }
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events

        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        return nil
    }

    /// 当发生错误,停止播放时,会回调这个方法
    public func player(_ player: PLPlayer, stoppedWithError error: Error?) {
        guard let eventSink = sink else {
            return
        }
        print("进来了=====播放发送错误")
        eventSink(error?.localizedDescription)
    }

    /// 当播放状态被改变时,会回调这个方法
    public func player(_ player: PLPlayer, statusDidChange state: PLPlayerStatus) {
        guard let eventSink = sink else {
            return
        }
        let type = "state-change"
        var value = -1
        switch state {
        case .statusUnknow:
            value = -1
        case .statusPreparing:
            value = 11
        case .statusReady:
            value = 12
        case .statusOpen:
            value = 13
        case .statusCaching:
            value = 14
        case .statusPlaying:
            value = 2
        case .statusPaused:
            value = 5
        case .statusStopped:
            value = 6
        case .statusError:
            value = 7
        case .stateAutoReconnecting:
            value = 19
        case .statusCompleted:
            value = 6
        @unknown default:
            value = -1
        }
        let json = JSON(["type": type,"json":"","value":value] as [String: Any?])
    
        let str =  json.rawString()
        
        if(str != nil){
            eventSink(str)
        }
     
    }
}
