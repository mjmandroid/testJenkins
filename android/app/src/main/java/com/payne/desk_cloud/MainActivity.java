package com.payne.desk_cloud;

import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.graphics.Color;
import android.view.WindowInsetsController;
import android.util.Log;

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // 获取 Window 对象
        Window window = getWindow();
        int currentApiVersion = android.os.Build.VERSION.SDK_INT;
        
        // 打印当前系统版本，用于调试
        Log.d("MainActivity", "Current API Level: " + currentApiVersion);
        
        try {
            // 设置状态栏透明
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
            window.setStatusBarColor(Color.TRANSPARENT);

            View decorView = window.getDecorView();
            
            // Android 12 (API 31) 及以上版本
            if (currentApiVersion >= android.os.Build.VERSION_CODES.S) {
                WindowInsetsController insetsController = window.getInsetsController();
                if (insetsController != null) {
                    insetsController.setSystemBarsAppearance(
                        WindowInsetsController.APPEARANCE_LIGHT_STATUS_BARS,
                        WindowInsetsController.APPEARANCE_LIGHT_STATUS_BARS
                    );
                }
            }
            // Android 6.0 (API 23) 到 Android 11
            else if (currentApiVersion >= android.os.Build.VERSION_CODES.M) {
                int flags = decorView.getSystemUiVisibility();
                flags |= View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR
                        | View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                        | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN;
                decorView.setSystemUiVisibility(flags);
                
                // 鸿蒙系统特殊处理
                try {
                    // EMUI/HarmonyOS 的特殊处理
                    int statusBarColor = Color.TRANSPARENT;
                    Class<?> layoutParams = Class.forName("com.huawei.android.view.LayoutParamsEx");
                    Object windowLayoutParams = layoutParams.newInstance();
                    layoutParams.getMethod("clearHwFlags", Window.class, int.class)
                            .invoke(windowLayoutParams, window, 0x00000001);
                    layoutParams.getMethod("addHwFlags", Window.class, int.class)
                            .invoke(windowLayoutParams, window, 0x00000002);
                } catch (Exception e) {
                    Log.e("MainActivity", "Huawei/HarmonyOS specific settings failed", e);
                }
            }

            // 设置导航栏
            window.setNavigationBarColor(Color.TRANSPARENT);
            if (currentApiVersion >= android.os.Build.VERSION_CODES.Q) {
                window.setNavigationBarContrastEnforced(true);
            }
            
        } catch (Exception e) {
            Log.e("MainActivity", "Error setting status bar appearance", e);
        }
    }
}