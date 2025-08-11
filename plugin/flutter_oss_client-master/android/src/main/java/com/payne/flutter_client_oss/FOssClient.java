package com.payne.flutter_client_oss;

import android.annotation.SuppressLint;
import android.os.Handler;
import android.util.Log;

import com.alibaba.sdk.android.oss.ClientConfiguration;
import com.alibaba.sdk.android.oss.ClientException;
import com.alibaba.sdk.android.oss.OSS;
import com.alibaba.sdk.android.oss.OSSClient;
import com.alibaba.sdk.android.oss.ServiceException;
import com.alibaba.sdk.android.oss.callback.OSSCompletedCallback;
import com.alibaba.sdk.android.oss.common.auth.OSSCredentialProvider;
import com.alibaba.sdk.android.oss.common.auth.OSSStsTokenCredentialProvider;
import com.alibaba.sdk.android.oss.internal.OSSAsyncTask;
import com.alibaba.sdk.android.oss.model.OSSRequest;
import com.alibaba.sdk.android.oss.model.ResumableDownloadRequest;
import com.alibaba.sdk.android.oss.model.ResumableDownloadResult;
import com.alibaba.sdk.android.oss.model.ResumableUploadRequest;
import com.alibaba.sdk.android.oss.model.ResumableUploadResult;

import java.io.File;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.Random;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class FOssClient {
    public int speedLimit = 0;
    private OSS mOss;
    final private MethodChannel channel;
    final Handler handler = new Handler();
    FOssClient(MethodChannel channel){
        this.channel = channel;
    }
    private Map<String, OSSAsyncTask> taskMap = new HashMap();
    public void initClient(MethodCall call,MethodChannel.Result result){
        Map<String,String> sts = call.argument("sts");
        String accessKeyId = sts.get("accessKeyId");
        String accessKeySecret = sts.get("accessKeySecret");
        String securityToken = sts.get("securityToken");
        String endPoint = call.argument("endPoint");
        // 从STS服务获取的临时访问密钥（AccessKey ID和AccessKey Secret）。
        if (accessKeyId == null || accessKeySecret == null || securityToken == null || endPoint == null){
            result.success(0);
            return;
        }
        OSSCredentialProvider provider = new OSSStsTokenCredentialProvider(accessKeyId,accessKeySecret,securityToken);
        ClientConfiguration conf = new ClientConfiguration();
        if (call.hasArgument("config")){
            Map<String,Integer> config = call.argument("config");
            Integer maxConcurrentRequest = config.get("maxConcurrentRequest");
            if (maxConcurrentRequest != null){
                conf.setMaxConcurrentRequest(maxConcurrentRequest);
            }
            Integer socketTimeout = config.get("socketTimeout");
            if (socketTimeout != null){
                conf.setSocketTimeout(socketTimeout);
            }
            Integer connectionTimeout = config.get("connectionTimeout");
            if (connectionTimeout != null){
                conf.setConnectionTimeout(connectionTimeout);
            }
            Integer maxLogSize = config.get("maxLogSize");
            if (maxLogSize != null){
                conf.setMaxLogSize(maxLogSize);
            }
            Integer maxErrorRetry = config.get("maxErrorRetry");
            if (maxErrorRetry != null){
                conf.setMaxErrorRetry(maxErrorRetry);
            }
        }
        mOss = new OSSClient(FlutterClientOssPlugin.weakActivity.get(),endPoint,provider,conf);
    }

    public void methodUpload(MethodCall call, MethodChannel.Result result){
        String bucketName = call.argument("bucketName");
        String ossFileName = call.argument("ossFileName");
        String filePath = call.argument("filePath");
        String recordDir = call.argument("recordDir");
        String id = createTaskId();
        asyncResumableUpload(bucketName,ossFileName,filePath,recordDir,id);
        result.success(id);
    }

    private void asyncResumableUpload(String bucketName,String ossFileName,String filePath,String recordDir,String taskId){
        Log.e("asyncResumableUpload","start-0");
        File recordDirFile = new File(recordDir);
        // 确保断点记录的保存文件夹已存在，如果不存在则新建断点记录的保存文件夹。
        if (!recordDirFile.exists()) {
            recordDirFile.mkdirs();
        }
        Log.e("asyncResumableUpload","start-1");
        ResumableUploadRequest request = new ResumableUploadRequest(bucketName,ossFileName,filePath,recordDir);
        request.setDeleteUploadOnCancelling(false);
        request.setThreadNum(1);
        request.setProgressCallback((request1, currentSize, totalSize) -> {
            Log.e("asyncResumableUpload","start-3");
            if (totalSize == 0) {
                Log.e("asyncResumableUpload","start-4");
                return;
            }
            Map<String, Object> args = new HashMap<>();
            args.put("current",currentSize);
            args.put("total",totalSize);
            args.put("taskId",taskId);
            Log.e("asyncResumableUpload","start-5");
            handler.post(() -> channel.invokeMethod("uploadProgress",args));
            Log.e("asyncResumableUpload","start-6");
        });
        OSSAsyncTask<ResumableUploadResult> task = mOss.asyncResumableUpload(request, new OSSCompletedCallback<ResumableUploadRequest, ResumableUploadResult>() {
            @Override
            public void onSuccess(ResumableUploadRequest request, ResumableUploadResult result) {
                Log.e("asyncResumableUpload","start-8");
                Map<String, Object> args = new HashMap<>();
                args.put("success",1);
                args.put("taskId",taskId);
                handler.post(() -> channel.invokeMethod("uploadResult",args));
            }

            @Override
            public void onFailure(ResumableUploadRequest request, ClientException clientException, ServiceException serviceException) {
                Map<String, Object> args = new HashMap<>();
                args.put("success",0);
                args.put("taskId",taskId);
                if (clientException != null) {
                    Log.e("asyncResumableUpload","start-9");
                    clientException.printStackTrace();
                    args.put("cancel", clientException.isCanceledException() ? 1 : 0);
                    args.put("message", clientException.getMessage());
                    handler.post(() -> channel.invokeMethod("uploadResult", args));
                } else if (serviceException != null) {
                    Log.e("asyncResumableUpload","start-10");
                    args.put("message",serviceException.getErrorCode());
                    args.put("cancel",0);
                    handler.post(() -> channel.invokeMethod("uploadResult",args));
                    serviceException.printStackTrace();
                }
            }
        });
        Log.e("asyncResumableUpload","start-2");
        taskMap.put(taskId,task);
    }

    public void methodDownload(MethodCall call, MethodChannel.Result result){
        String bucketName = call.argument("bucketName");
        String ossFileName = call.argument("ossFileName");
        String filePath = call.argument("filePath");
        String recordFile = call.argument("recordFile");
        Log.e("methodDownload",bucketName + "--" + ossFileName + "--" + filePath +  "--" + recordFile);
        String id = createTaskId();
        asyncResumableDownload(bucketName,ossFileName,filePath,recordFile,id);
        result.success(id);
    }

    public void asyncResumableDownload(String bucketName, String ossFileName, String filePath, String recordFile,String taskId) {

        ResumableDownloadRequest request = new ResumableDownloadRequest(bucketName, ossFileName, filePath);
        request.setEnableCheckPoint(true);
        request.setCheckPointFilePath(recordFile);
        request.setThreadNum(1);
        if (speedLimit > 0) {
            Map<String, String> headers = new HashMap<>();
            headers.put("x-oss-traffic-limit",speedLimit + "");
            request.setRequestHeader(headers);
        }
        request.setProgressListener((request1, currentSize, totalSize) -> {
            if (totalSize == 0) {
                return;
            }
            Map<String, Object> args = new HashMap<>();
            args.put("current",currentSize);
            args.put("total",totalSize);
            args.put("taskId",taskId);
            handler.post(() -> channel.invokeMethod("downloadProgress",args));
        });
        final OSSAsyncTask<ResumableDownloadResult> task = mOss.asyncResumableDownload(request, new OSSCompletedCallback<ResumableDownloadRequest, ResumableDownloadResult>() {
            @Override
            public void onSuccess(ResumableDownloadRequest request, ResumableDownloadResult result) {
                Map<String, Object> args = new HashMap<>();
                args.put("success",1);
                args.put("taskId",taskId);
                handler.post(() -> channel.invokeMethod("downloadResult",args));
            }

            @Override
            public void onFailure(ResumableDownloadRequest request, ClientException clientException, ServiceException serviceException) {
                Map<String, Object> args = new HashMap<>();
                args.put("success",0);
                args.put("taskId",taskId);
                if (clientException != null) {
                    if (taskMap.get(taskId) == null) { //这个代表用户主动取消，去执行回调
                        args.put("cancel", clientException.isCanceledException() ? 1 : 0);
                        args.put("message", clientException.getMessage());
                        handler.post(() -> channel.invokeMethod("downloadResult", args));
                    }
                    clientException.printStackTrace();;
                } else if (serviceException != null) {
                    args.put("message",serviceException.getErrorCode());
                    args.put("cancel",0);
                    handler.post(() -> channel.invokeMethod("downloadResult",args));
                    serviceException.printStackTrace();
                }
            }
        });
        taskMap.put(taskId,task);
    }

    public void checkFile(MethodCall call, MethodChannel.Result result){
        String bucketName = call.argument("bucketName");
        String fileName = call.argument("fileName");
        try {
           boolean r = mOss.doesObjectExist(bucketName, fileName);
           result.success(r ? 1 : 0);
        }catch (Exception e){
            result.success(0);
        }
    }

    public void getSignUrl(MethodCall call, MethodChannel.Result result){
        String bucketName = call.argument("bucketName");
        String fileName = call.argument("fileName");
       String r = mOss.presignPublicObjectURL(bucketName,fileName);
       result.success(r);
    }

    public void cancelTask(String taskId){
        OSSAsyncTask task = taskMap.get(taskId);
        if (task != null && !task.isCanceled() && !task.isCompleted()) {
            taskMap.remove(taskId);
            task.cancel();
        }
    }

    public void cancelAllTask(){
        for (String key : taskMap.keySet()) {
            OSSAsyncTask task = taskMap.get(key);
            if (task != null && !task.isCanceled() && !task.isCompleted()) {
                taskMap.remove(key);
                task.cancel();
            }
        }
        taskMap.clear();
    }

    @SuppressLint("DefaultLocale")
    private String createTaskId(){
        StringBuilder randomStr = new StringBuilder();
        for (int i = 0; i < 4; i++) {
            randomStr.append(String.format("%02d",(new Random()).nextInt(10000) % 100));
        }
        return System.currentTimeMillis() + randomStr.toString();
    }
}
