package com.origin.flutter_origin_resources;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;

import androidx.annotation.NonNull;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** FlutterOriginResourcesPlugin */
public class FlutterOriginResourcesPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  private MethodChannel channel;
  private Activity mActivity;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_origin_resources");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("getResourcePath")){
      try {
        String name = call.argument("name");
        String type = call.argument("type");
        if (name == null || type == null) {
          result.success(null);
          return;
        }
        // 通过字符串获取Drawable
        int drawableResourceId = mActivity.getResources().getIdentifier(name, type, mActivity.getPackageName());
        Drawable drawable = mActivity.getResources().getDrawable(drawableResourceId);

        // 将Drawable转换为Bitmap
        Bitmap bitmap = ((BitmapDrawable) drawable).getBitmap();

        // 保存Bitmap到cache文件夹
        File cachePath = new File(mActivity.getCacheDir(), "images");
        if (!cachePath.exists()) {
          cachePath.mkdirs(); // 创建文件夹
        }
        String fullPath = cachePath + "/" + name + ".png";
        if (new File(fullPath).exists()){
          result.success(fullPath);
          return;
        }
        new Thread(){
          @Override
          public void run() {
            FileOutputStream stream = null; // 在这个文件夹中创建.png文件
            try {
              stream = new FileOutputStream(fullPath);
              bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream); // 压缩bitmap到.png文件中
              stream.close(); // 关闭流
              result.success(fullPath);
            } catch (Exception e) {
              e.printStackTrace();
              result.success(null);
            }
          }
        }.start();
      } catch (Exception e) {
        e.printStackTrace();
        result.success(null);
      }
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
    mActivity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {
    mActivity = null;
  }
}
