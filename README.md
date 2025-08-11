## 开发环境

> 开发环境：macOS 13.2.1
> 开发工具：VSCode
> 开发语言：Dart

> 开发框架：Flutter 3.22.3

> 请务必使用 Flutter 3.22.3 版本，其他版本可能存在问题


## 编译方式

> 编译前，请先对 plugin 下的插件 “分别” 进行 flutter pub get 操作

## 启动方式
> 测试
> flutter run -t lib/main_bata.dart

> 正式
> flutter run -t lib/main.dart

> 开发
> flutter run -t lib/main_dev.dart （请注意，版本号低于1.0.17时使用，大部分使用 bate 环境即可）

> 或者使用 launch.json 配置 配合 vscode 启动

## 打包命令
> 测试
> flutter build ipa --export-method ad-hoc -t lib/main_bata.dart

> Android 渠道测试包

> flutter build apk --release -t lib/main_bata.dart --dart-define=CHANNEL=huawei

> flutter build apk --release -t lib/main_bata.dart --dart-define=CHANNEL=xiaomi

> flutter build apk --release -t lib/main_bata.dart --dart-define=CHANNEL=oppo

> flutter build apk --release -t lib/main_bata.dart --dart-define=CHANNEL=vivo

> IOS 正式包：
> flutter build ios --release -t lib/main.dart  

> Android 正式渠道包：直接使用：./build_channels.sh

> 请注意：chmod +x build_channels.sh 赋予执行权限

## 崩溃监控
> https://bugly.qq.com/

> 账号：QQ登录
