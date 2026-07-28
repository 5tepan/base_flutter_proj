package com.base.base_flutter_proj

import android.app.NotificationManager
import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        private const val NOTIFICATIONS_CHANNEL =
            "com.base.base_flutter_proj/notifications"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            NOTIFICATIONS_CHANNEL,
        ).setMethodCallHandler { call, result ->
            if (call.method == "clearAll") {
                val manager =
                    getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                manager.cancelAll()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }
}
