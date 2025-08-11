package com.payne.flutter_client_oss;

import android.app.Activity;

import androidx.annotation.NonNull;

import java.lang.ref.WeakReference;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** FlutterClientOssPlugin */
public class FlutterClientOssPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  private MethodChannel channel;
  private FOssClient client;
  public static WeakReference<Activity> weakActivity;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_client_oss");
    channel.setMethodCallHandler(this);
    client = new FOssClient(channel);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("initSdk")){
      client.initClient(call,result);
      result.success(client.hashCode());
    }else if (call.method.equals("asyncResumableUpload")) {
      client.methodUpload(call, result);
    }else if (call.method.equals("asyncResumableDownload")) {
      client.methodDownload(call, result);
    } else if (call.method.equals("setSpeedLimit")) {
      client.speedLimit = (Integer) call.arguments;
      result.success(null);
    }else if (call.method.equals("checkFile")) {
      client.checkFile(call, result);
    }else if (call.method.equals("getSignUrl")) {
      client.getSignUrl(call, result);
    } else if (call.method.equals("cancelTask")) {
      client.cancelTask((String) call.arguments);
      result.success(null);
    } else if (call.method.equals("cancelAllTask")) {
      client.cancelAllTask();
      result.success(null);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
      weakActivity = new WeakReference<>(binding.getActivity());
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {
    weakActivity.clear();
  }
}
