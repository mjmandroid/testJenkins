package com.payne.desk_cloud;

import io.flutter.app.FlutterApplication;
import cn.jiguang.api.utils.JCollectionAuth;

public class MyApplication extends FlutterApplication {

    @Override
    public void onCreate() {
        super.onCreate();
        JCollectionAuth.enableAutoWakeup(this, false);
        JCollectionAuth.setAuth(this, false);
    }
}
