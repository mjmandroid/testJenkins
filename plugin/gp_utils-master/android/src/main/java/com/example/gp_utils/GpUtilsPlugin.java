package com.example.gp_utils;

import android.app.Activity;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Display;

import androidx.annotation.NonNull;

import com.blankj.utilcode.util.AppUtils;
import com.blankj.utilcode.util.NetworkUtils;
import com.blankj.utilcode.util.ResourceUtils;
import com.bytedance.hume.readapk.HumeSDK;
import com.github.gzuliyujiang.oaid.DeviceID;
import com.github.gzuliyujiang.oaid.DeviceIdentifier;
import com.github.gzuliyujiang.oaid.IGetter;
import com.kwai.monitor.payload.TurboHelper;
import com.tencent.vasdolly.helper.ChannelReaderUtil;

import java.util.HashMap;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** GpUtilsPlugin */
public class GpUtilsPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  private MethodChannel channel;
  private Activity mActivity;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "gp_utils");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull final Result result) {
    switch (call.method){
      case "androidId":
        result.success(DeviceUtils.getAndroidID(mActivity.getApplicationContext()));
        break;
      case "macAddress":
        result.success(com.blankj.utilcode.util.DeviceUtils.getMacAddress());
        break;
      case "uniqueDeviceId":
        result.success(DeviceUtils.getUniqueDeviceId(mActivity.getApplicationContext()));
        break;
      case "ipAddress":
        result.success(getIP());
        break;
      case "appName":
        result.success(AppUtils.getAppName());
        break;
      case "metaValue":
        Object value = getMetaValue(call.<String>argument("key"));
        result.success(value);
        break;
      case "version":
        result.success(AppUtils.getAppVersionName());
        break;
      case "versionCode":
        result.success(AppUtils.getAppVersionCode());
        break;
      case "assets":
        String str = ResourceUtils.readAssets2String(call.<String>argument("file"));
        result.success(str);
        break;
      case "hume":
        String humeChannel = HumeSDK.getChannel(mActivity);
        if (humeChannel == null){
          result.success("");
        }else{
          result.success(humeChannel);
        }
        break;
      case "tencentChannel":
        String tChannel = ChannelReaderUtil.getChannel(mActivity.getApplication());
        if (tChannel == null){
          result.success("");
        }else{
          result.success(tChannel);
        }
        break;
      case "ksChannel":
        String ksChannel = TurboHelper.getChannel(mActivity.getApplication());
        if (ksChannel == null){
          result.success("");
        }else{
          result.success(ksChannel);
        }
        break;
      case "sourceDir":
        result.success(mActivity.getApplication().getApplicationInfo().sourceDir);
        break;
      case "installApk":
        AppUtils.installApp(call.<String>argument("path"));
        result.success(true);
        break;
      case "openAppSetting":
        AppUtils.launchAppDetailsSettings();
        result.success(true);
        break;
      case "deviceType":
        result.success(com.blankj.utilcode.util.DeviceUtils.getModel());
        break;
      case "sdkVersion":
        result.success(DeviceUtils.getSDKVersionCode());
        break;
      case "initOaid":
        DeviceIdentifier.register(mActivity.getApplication());
        result.success(null);
        break;
      case "oaid":
        DeviceID.getOAID(mActivity, new IGetter() {
          @Override
          public void onOAIDGetComplete(String oaid) {
            result.success(oaid);
          }

          @Override
          public void onOAIDGetError(Exception error) {
            Log.e("DeviceId",error.toString());
            result.success("");
          }
        });
        break;
      case "metrics":
        HashMap displayResult = getHashMap();
        result.success(displayResult);
        break;
      default:
        result.success("");
        break;
    }
  }

  private @NonNull HashMap getHashMap() {
    Display display = mActivity.getWindowManager().getDefaultDisplay();
    DisplayMetrics metrics = new DisplayMetrics();
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
      display.getRealMetrics(metrics);
    } else {
      display.getMetrics(metrics);
    }

    HashMap displayResult = new HashMap<String, Object>();
    displayResult.put("widthPx",metrics.widthPixels);
    displayResult.put("heightPx",metrics.heightPixels);
    displayResult.put("xDpi",metrics.xdpi);
    displayResult.put("yDpi",metrics.ydpi);
    return displayResult;
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

  }
  
  private Object getMetaValue(String key){
    if (key == null){
      return null;
    }
    Object value = null;
    try {
      PackageInfo packageInfo = mActivity.getPackageManager().getPackageInfo(mActivity.getPackageName(), PackageManager.GET_META_DATA);
      value = packageInfo.applicationInfo.metaData.get(key);
    } catch (PackageManager.NameNotFoundException e) {
      e.printStackTrace();
    }
    return value;
  }

  private String getIP(){
    NetworkUtils.NetworkType type = NetworkUtils.getNetworkType();
    switch (type){
      case NETWORK_2G:
      case NETWORK_3G:
      case NETWORK_4G:
      case NETWORK_5G:
        return NetworkUtils.getIPAddress(true);
      case NETWORK_WIFI:
        return NetworkUtils.getIpAddressByWifi();
      default:
        return "";
    }
  }
}
