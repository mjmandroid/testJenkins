// ignore_for_file: file_names

import 'dart:io';

/// How to use: dart scripts/set-version.dart x.y.z
void main(List<String> args) {
  // read new version from args
  final newVersion = args[0];

  // replace current version with new version in pubspec.yaml
  final pubspecFile = File("pubspec.yaml");
  final newPubspec = pubspecFile //
      .readAsStringSync()
      .replaceFirst(
          RegExp(r"^version: .*$", multiLine: true), 'version: $newVersion');
  pubspecFile.writeAsStringSync(newPubspec);

  // replace current version with new version in android/build.gradle
  final androidBuildGradleFile = File("android/build.gradle");
  final newAndroidBuildGradle = androidBuildGradleFile //
      .readAsStringSync()
      .replaceFirst(
          RegExp(r"^version .*$", multiLine: true), "version '$newVersion'");
  androidBuildGradleFile.writeAsStringSync(newAndroidBuildGradle);

  // replace current version with new version in ios/md5_file_checksum.podspec
  final iosPodspecFile = File("ios/md5_file_checksum.podspec");
  final newIosPodspec = iosPodspecFile //
      .readAsStringSync()
      .replaceFirst(RegExp(r"s.version\s+= .*", multiLine: true),
          "s.version = '$newVersion'");
  iosPodspecFile.writeAsStringSync(newIosPodspec);
}
