#!/bin/bash

# 从 pubspec.yaml 获取版本号
version=$(grep '^version:' pubspec.yaml | awk '{print $2}')

# 渠道列表
channels=("huawei" "xiaomi")

# 打包输出目录
output_dir="build/apk_channels"

# 确保输出目录存在
mkdir -p $output_dir

# 遍历每个渠道，进行打包
for channel in "${channels[@]}"; do
    echo "开始为渠道 $channel 打包..."

    # 执行 Flutter 打包命令，传递渠道和版本号
    flutter build apk --release -t lib/main.dart --dart-define=CHANNEL=$channel --dart-define=VERSION=$version

    # APK 文件的源路径和目标路径
    apk_source_path="build/app/outputs/flutter-apk/app-release.apk"
    apk_target_path="$output_dir/app-release-$channel-$version.apk"

    # 移动 APK 到指定的目标路径，并重命名
    if [ -f "$apk_source_path" ]; then
        mv "$apk_source_path" "$apk_target_path"
        echo "渠道 $channel 打包完成，输出文件：$apk_target_path"
    else
        echo "打包失败：未找到 $apk_source_path"
    fi
done
