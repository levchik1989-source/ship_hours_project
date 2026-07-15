package com.example.ship_hours

import android.app.Activity
import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "com.example.ship_hours/file_export"
        private const val CREATE_DOCUMENT_REQUEST = 7001
    }

    private var pendingResult: MethodChannel.Result? = null
    private var pendingSourcePath: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "saveFile" -> {
                    if (pendingResult != null) {
                        result.error(
                            "SAVE_IN_PROGRESS",
                            "Another save operation is already in progress.",
                            null,
                        )
                        return@setMethodCallHandler
                    }

                    val sourcePath = call.argument<String>("sourcePath")
                    val suggestedName = call.argument<String>("suggestedName")
                    val mimeType = call.argument<String>("mimeType")

                    if (
                        sourcePath.isNullOrBlank() ||
                        suggestedName.isNullOrBlank() ||
                        mimeType.isNullOrBlank()
                    ) {
                        result.error(
                            "INVALID_ARGUMENTS",
                            "sourcePath, suggestedName and mimeType are required.",
                            null,
                        )
                        return@setMethodCallHandler
                    }

                    val sourceFile = File(sourcePath)

                    if (!sourceFile.exists()) {
                        result.error(
                            "SOURCE_NOT_FOUND",
                            "Temporary export file does not exist.",
                            sourcePath,
                        )
                        return@setMethodCallHandler
                    }

                    pendingResult = result
                    pendingSourcePath = sourcePath

                    val intent = Intent(Intent.ACTION_CREATE_DOCUMENT).apply {
                        addCategory(Intent.CATEGORY_OPENABLE)
                        type = mimeType
                        putExtra(Intent.EXTRA_TITLE, suggestedName)
                    }

                    try {
                        startActivityForResult(intent, CREATE_DOCUMENT_REQUEST)
                    } catch (error: Exception) {
                        clearPendingSave()

                        result.error(
                            "DIALOG_FAILED",
                            error.message ?: "Could not open save dialog.",
                            null,
                        )
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    @Deprecated("Deprecated in Android SDK, retained for ACTION_CREATE_DOCUMENT compatibility")
    override fun onActivityResult(
        requestCode: Int,
        resultCode: Int,
        data: Intent?,
    ) {
        if (requestCode != CREATE_DOCUMENT_REQUEST) {
            super.onActivityResult(requestCode, resultCode, data)
            return
        }

        val result = pendingResult
        val sourcePath = pendingSourcePath

        if (result == null || sourcePath == null) {
            clearPendingSave()
            return
        }

        if (resultCode != Activity.RESULT_OK) {
            clearPendingSave()
            result.success(false)
            return
        }

        val targetUri: Uri? = data?.data

        if (targetUri == null) {
            clearPendingSave()

            result.error(
                "INVALID_TARGET",
                "Android did not return a destination for the file.",
                null,
            )
            return
        }

        try {
            val outputStream = contentResolver.openOutputStream(targetUri)

            if (outputStream == null) {
                throw IllegalStateException(
                    "Could not open the selected destination.",
                )
            }

            outputStream.use { output ->
                File(sourcePath).inputStream().use { input ->
                    input.copyTo(output)
                }
            }

            clearPendingSave()
            result.success(true)
        } catch (error: Exception) {
            clearPendingSave()

            result.error(
                "SAVE_FAILED",
                error.message ?: "Could not save the file.",
                null,
            )
        }
    }

    private fun clearPendingSave() {
        pendingResult = null
        pendingSourcePath = null
    }
}
