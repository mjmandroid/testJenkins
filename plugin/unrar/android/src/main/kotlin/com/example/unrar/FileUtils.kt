package com.example.unrar
import android.util.Log
import net.sf.sevenzipjbinding.ExtractOperationResult
import net.sf.sevenzipjbinding.IInArchive
import net.sf.sevenzipjbinding.SevenZip
import net.sf.sevenzipjbinding.SevenZipException
import net.sf.sevenzipjbinding.impl.RandomAccessFileInStream
import java.io.File
import java.io.FileNotFoundException
import java.io.IOException
import java.io.RandomAccessFile

/**
 * 文件操作工具类
 */
class FileUtils {

    companion object {
        /**
         * 解压 RAR 文件到指定目录
         * @param rarPath RAR文件路径
         * @param dstDirectoryPath 目标解压目录
         * @param password 解压密码
         * @return 文件路径列表（示例代码返回空，需根据实际需求修改）
         * @throws IOException 文件操作异常
         */
        @Throws(IOException::class)
        @JvmStatic
        fun unRar(rarPath: String, dstDirectoryPath: String, password: String? = null): Map<String, Any?> {
            val randomAccessFile = RandomAccessFile(rarPath, "r")

            var archive: IInArchive? = null

            try {
                // 执行解压操作
                // 注意这个方法
                // 这个官方文档不详细 我们要重写一个解压流来区分是否带密码
                if(password.isNullOrEmpty()){
                    Log.i("FileUtils", "直接解压无密码")

                    try {
                        archive = SevenZip.openInArchive(null, RandomAccessFileInStream(randomAccessFile))
                        // 创建索引数组用于遍历压缩包内容
                        val inIndices = IntArray(archive.numberOfItems) { it }
                        archive.extract(inIndices, false, ExtractCallback(archive, dstDirectoryPath))
                    } catch (e: SevenZipException) {
                        return when {
                            e.message?.contains("0x1") == true -> mapOf("status" to false, "message" to ExtractOperationResult.WRONG_PASSWORD.name)
                            else -> mapOf("status" to false, "message" to e.message)
                        }
                    }
                }else{
                    Log.i("FileUtils", "存在解压密码：$password")

                    try {
                        archive = SevenZip.openInArchive(null, RandomAccessFileInStream(randomAccessFile), password)
                        // 创建索引数组用于遍历压缩包内容
                        val inIndices = IntArray(archive.numberOfItems) { it }
                        archive.extract(inIndices, false, ExtractCallbackPassword(archive, dstDirectoryPath, password))
                    } catch (e: SevenZipException) {
                        return when {
                            e.message?.contains("0x1") == true -> mapOf("status" to false, "message" to ExtractOperationResult.WRONG_PASSWORD.name)
                            else -> mapOf("status" to false, "message" to e.message)
                        }
                    }
                }

            } catch (e: FileNotFoundException) {
                return mapOf("status" to false, "message" to e.message)
            } catch (e: SevenZipException) {
                return mapOf("status" to false, "message" to e.message)
            } catch (e: IOException) {
                return mapOf("status" to false, "message" to e.message)
            }finally {
                // 确保资源关闭
                archive?.close()
                randomAccessFile.close()
            }

            return mapOf("status" to true, "message" to "success")
        }

        /**
         * 递归获取目录下的所有文件/文件夹路径
         * @param directoryPath 需要遍历的目录路径
         * @param isAddDirectory 是否包含目录路径
         * @return 文件路径列表
         */
        @JvmStatic
        fun getAllFile(directoryPath: String, isAddDirectory: Boolean): List<String> {
            val list = mutableListOf<String>()
            val baseFile = File(directoryPath)

            // 校验基础路径有效性
            if (baseFile.isFile || !baseFile.exists()) return list

            // 获取目录文件列表
            val files = baseFile.listFiles()

            // 处理空目录情况
            if (files.isNullOrEmpty()) return emptyList()

            files.forEach { file ->
                if (file.isDirectory) {
                    // 需要添加目录路径时记录
                    if (isAddDirectory) {
                        list.add(file.absolutePath)
                    }
                    // 递归处理子目录
                    list.addAll(getAllFile(file.absolutePath, isAddDirectory))
                } else {
                    list.add(file.absolutePath)
                }
            }
            return list
        }
    }
}

// 注意：需要自行实现 ExtractCallback 类或使用库提供的实现
// 注意：AndroidManifest 需要添加文件读写权限：
// <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
// <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
