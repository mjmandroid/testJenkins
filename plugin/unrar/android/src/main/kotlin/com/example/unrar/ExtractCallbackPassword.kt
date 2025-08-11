package com.example.unrar

import android.util.Log
import net.sf.sevenzipjbinding.ExtractAskMode
import net.sf.sevenzipjbinding.ExtractOperationResult
import net.sf.sevenzipjbinding.IArchiveExtractCallback
import net.sf.sevenzipjbinding.ICryptoGetTextPassword
import net.sf.sevenzipjbinding.IInArchive
import net.sf.sevenzipjbinding.ISequentialOutStream
import net.sf.sevenzipjbinding.PropID
import net.sf.sevenzipjbinding.SevenZipException
import java.io.File
import java.io.FileOutputStream


class ExtractCallbackPassword(
    private val inArchive: IInArchive,
    private val ourDir: String,
    private val password: String?
) : IArchiveExtractCallback, ICryptoGetTextPassword {

    // 用于跟踪文件路径变化的临时变量
    private var oldPath: String = ""


    /**
     * 实现密码获取接口
     * @throws SevenZipException 当需要密码但未提供时抛出异常
     */
    @Throws(SevenZipException::class)
    override fun cryptoGetTextPassword(): String {
        return password ?: throw SevenZipException("需要密码来解压加密文件")
    }

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

        // 检查是否需要密码
        if (inArchive.getProperty(index, PropID.ENCRYPTED) as Boolean) {
            if (password.isNullOrEmpty()) {
                throw SevenZipException("EMPTY_PASSWORD")
            }
        }

        return if (!isFolder) {
            ISequentialOutStream { data ->
                try {
                    val targetFile = File(ourDir, path)
                    val appendMode = path == oldPath
                    save2File(targetFile, data, appendMode)
                    oldPath = path
                } catch (e: Exception) {
                    Log.e("ExtractError", "文件写入失败: ${e.message}")
                    throw SevenZipException("WRITE_ERROR")
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