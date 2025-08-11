package com.example.unrar


import android.os.Handler;
import android.os.Looper;
import android.util.Log

import java.io.IOException;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;


/** UnrarPlugin */
class UnrarPlugin: FlutterPlugin, MethodCallHandler {

	// 使用缓存线程池处理异步任务
    private val executor = Executors.newCachedThreadPool()
    // 主线程Handler用于界面回调
    private val handler = Handler(Looper.getMainLooper())
    
    // Flutter方法通道
    private lateinit var channel: MethodChannel


	/**
     * 插件绑定到Flutter引擎时初始化方法通道
     */
    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "unrar_file")
        channel.setMethodCallHandler(this)
    }

    /**
     * 处理方法调用，支持extractFile指令
     */
    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "extractFile" -> extractFile(call, result)
            else -> result.notImplemented()
        }
    }

    /**
     * 处理解压请求
     */
    private fun extractFile(call: MethodCall, result: Result) {
        // 从Dart端获取参数
        val filePath = call.argument<String>("file_path") ?: ""
        val destPath = call.argument<String>("destination_path") ?: ""
        val password = call.argument<String>("password")

        // 提交到线程池执行解压任务
        executor.execute {
            try {
                val unrarResult = when {
                    password.isNullOrEmpty() -> FileUtils.unRar(filePath, destPath)
                    else -> FileUtils.unRar(filePath, destPath, password)
                }

                Log.i("UnrarPlugin", unrarResult.toString())

                result.success(unrarResult)
            } catch (e: IOException) {
                result.success(mapOf(
                    "result" to false,
                    "message" to e.message
                ))
            } catch (e: Exception) {
                result.success(mapOf(
                    "result" to false,
                    "message" to e.message
                ))
            }
        }
    }

    /**
     * 处理解压请求
     */
//    private fun handleExtractCall(call: MethodCall, result: Result) {
//        // 从Dart端获取参数
//        val filePath = call.argument<String>("file_path") ?: ""
//        val destPath = call.argument<String>("destination_path") ?: ""
//        val password = call.argument<String>("password")
//
//        // 提交到线程池执行解压任务
//        executor.execute {
//            try {
//                extractFile(password, filePath, destPath)
//                sendSuccess(result)
//            } catch (e: UnsupportedRarV5Exception) {
//                sendError(result, "extractionRAR5Error :: ${e.message}")
//            } catch (e: IOException) {
//                sendError(result, "IOError :: ${e.message}")
//            } catch (e: RarException) {
//                sendError(result, "RARError :: ${e.message}")
//            }
//        }
//    }
//
//    /**
//     * 执行实际解压操作
//     */
//    @Throws(RarException::class, IOException::class)
//    private fun extractFile(password: String?, filePath: String, destPath: String) {
//        when {
//            password.isNullOrEmpty() -> Junrar.extract(filePath, destPath)
//            else -> Junrar.extract(filePath, destPath, password)
//        }
//    }

    /**
     * 插件从引擎分离时清理资源
     */
    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
