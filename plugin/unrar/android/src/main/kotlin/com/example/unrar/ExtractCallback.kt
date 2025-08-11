package com.example.unrar

import net.sf.sevenzipjbinding.ExtractAskMode
import net.sf.sevenzipjbinding.ExtractOperationResult
import net.sf.sevenzipjbinding.IArchiveExtractCallback
import net.sf.sevenzipjbinding.IInArchive
import net.sf.sevenzipjbinding.ISequentialOutStream
import net.sf.sevenzipjbinding.PropID
import net.sf.sevenzipjbinding.SevenZipException
import java.io.File
import java.io.FileOutputStream


/**
 * RAR 文件解压回调实现 (Android 兼容版)
 * 注意：使用 use 表达式自动管理资源
 */
class ExtractCallback(
    private val inArchive: IInArchive,
    private val ourDir: String,
) : IArchiveExtractCallback {

    // 用于跟踪文件路径变化的临时变量
    private var oldPath: String = ""


    /**
     * 设置解压进度 (空实现)
     */
    @Throws(SevenZipException::class)
    override fun setCompleted(arg0: Long) = Unit

    /**
     * 设置总大小 (空实现)
     */
    @Throws(SevenZipException::class)
    override fun setTotal(arg0: Long) = Unit

    /**
     * 获取文件输出流
     */
    @Throws(SevenZipException::class)
    override fun getStream(
        index: Int,
        extractAskMode: ExtractAskMode
    ): ISequentialOutStream? {
        // 获取文件属性
        val path = inArchive.getProperty(index, PropID.PATH) as String
        val isFolder = inArchive.getProperty(index, PropID.IS_FOLDER) as Boolean

        if (inArchive.getProperty(index, PropID.ENCRYPTED) as Boolean) {
            throw SevenZipException("NEED_PASSWORD")
        }

        return if (!isFolder) {
            // 创建匿名输出流实现
            ISequentialOutStream { data ->
                try {
                    val targetFile = File(ourDir, path)
                    // 判断是否需要追加写入（处理分块文件）
                    val appendMode = path == oldPath
                    if (save2File(targetFile, data, appendMode)) {
                        oldPath = path
                    }
                } catch (e: Exception) {
                    e.printStackTrace()
                }
                data.size
            }
        } else {
            null
        }
    }

    /**
     * 准备解压操作 (空实现)
     */
    @Throws(SevenZipException::class)
    override fun prepareOperation(arg0: ExtractAskMode) = Unit

    /**
     * 处理解压结果
     */
    @Throws(SevenZipException::class)
    override fun setOperationResult(extractOperationResult: ExtractOperationResult) {
        if (extractOperationResult != ExtractOperationResult.OK) {
            throw SevenZipException(extractOperationResult.name)
        }
    }
    /**
     * 将数据写入文件
     * @param file 目标文件
     * @param data 字节数据
     * @param append 是否追加模式
     * @return 是否写入成功
     */
    private fun save2File(file: File, data: ByteArray, append: Boolean): Boolean {
        // 自动资源管理（使用 Kotlin 的 use 表达式）
        return runCatching {
            // 创建父目录（如果需要）
            file.parentFile?.takeIf { !it.exists() }?.mkdirs()

            FileOutputStream(file, append).use { fos ->
                fos.write(data)
                fos.flush()
            }
            true
        }.getOrElse {
            it.printStackTrace()
            false
        }
    }
}

// 注意事项：
// 1. 需要添加文件权限：
//    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
// 2. 推荐在后台线程执行解压操作
// 3. 建议添加解压进度回调接口
// 4. 需要处理 Android 10 及以上版本的作用域存储问题
