# flutter_rtmp_player

flutter rtmp 在线网络视频播放器,支持rtmp拉流,适配大部分视频格式,支持Android,和iOS

## 安装

```yaml
flutter_rtmp_player: ^1.0.0
```

## 快速开始


```dart
const SizedBox(
  width: 100,
  height: 100,
  child: VideoPlayerWidget(url: 'rtmp://xxxxxxxxxxx'); // 播放器组件
);
```

## `VideoPlayerWidget`可选参数

1. 组件控制器
```dart
final PlayerController? controller; 
```
2. 安卓初始化配置

```dart
final AndroidOption androidConfig; // 不传使用默认最佳配置
```
<img src="https://s1.ax1x.com/2022/05/17/O4ZIzT.png">

3.iOS初始化配置
```dart
final IosOptions? iosOptions; // 不传使用默认最佳配置
```
<img src="https://s1.ax1x.com/2022/05/17/O4ecp6.png">
<img src="https://s1.ax1x.com/2022/05/17/O4eXng.png">

4. 播放URL
```dart
/// 播放的URL,如果设置了这个参数,会提前准备资源
/// 也可以不设置,后面也可以使用[PlayerController] 来控制播放器播放
final String? url;
```
5. 自动播放
```dart
 final bool autoPlay; 
```

6. 组件初始化完毕回调

<p>
可以在这个函数调用`PlayerController` api
</p>

```dart
final VoidCallback? onCreate; 
```

7. 自动隐藏UI控制面板
```dart
final bool? autoHideUi; 
```

## PlayerController Api

状态回调方法列表
[PlayerStateListener.dart](https://github.com/mdddj/flutter_rtmp_plugin/blob/master/lib/service/status_listener.dart)

```dart

/// 播放器的状态回调
controller.addStateChangeListener(PlayerStateListener listener);

///暂停播放
controller.pause();

///恢复播放
controller.resume();

///结束播放
controller.stop();

///(Android有效)
///切换播放器内核
///  可选的值有:
/// 1.[ManagerModel.ijkPlayerManager] - bilibili内核
/// 2.[ManagerModel.systemPlayerManager] - 系统自带内核
/// 3.[ManagerModel.exo2PlayerManager] - exo内核
/// 
///  如果需要播放[rtmp]格式的源,需要切换成[ManagerModel.exo2PlayerManager] 内核,否则会无法播放
///  如果需要播放[m3u8]格式的视频,需要切换成[ManagerModel.ijkPlayerManager] 内核
controller.setPlayManager(ManagerModel managerModel);

///切换播放的URL
controller.setPlayUrl(String url);

///是否已经初始化组件
controller.isInit;

///切换日志等级,隐藏烦人的日志滚动
controller.changeLoggerLevler({LoggerLevel? loggerLevel});

///隐藏控制器UI面板
controller.hideUi();

///禁用系统锁屏
contorller.disableScreenCapture();

///获取当前播放器的状态
controller.getCurrentState();
```
## 播放器状态

部分状态不止回调一次

<img src="https://s1.ax1x.com/2022/05/17/O4uzAH.png">