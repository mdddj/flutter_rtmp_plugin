//
//  RtmpViewFactory.swift
//  flutter_rtmp_plugin
//
//  Created by ldd on 2022/5/5.
//

import Foundation
import Flutter


class RtmpViewFactory : NSObject,FlutterPlatformViewFactory {
    
    
    var flutterBinaryMessager: FlutterBinaryMessenger?
    
    init(binaryMessenger messager: FlutterBinaryMessenger){
        self.flutterBinaryMessager = messager
    }
    
    /// 视图初始化
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        
        return SwiftFlutterRtmpPlugin(frame: frame, viewId: viewId, args: args, flutterBinaryMessager: flutterBinaryMessager)
    }
    
    ///参数解码配置
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    
    
}
