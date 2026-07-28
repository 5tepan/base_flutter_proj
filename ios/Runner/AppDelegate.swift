import Flutter
import UIKit
import UserNotifications

/// Clears delivered/pending notifications and app icon badge.
enum NotificationClearPlugin {
    static let channelName = "com.base.base_flutter_proj/notifications"

    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: channelName,
            binaryMessenger: registrar.messenger()
        )
        channel.setMethodCallHandler { call, result in
            guard call.method == "clearAll" else {
                result(FlutterMethodNotImplemented)
                return
            }

            let center = UNUserNotificationCenter.current()
            center.removeAllDeliveredNotifications()
            center.removeAllPendingNotificationRequests()

            if #available(iOS 16.0, *) {
                center.setBadgeCount(0) { _ in }
            } else {
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
            result(nil)
        }
    }
}

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        if let registrar = self.registrar(forPlugin: "NotificationClearPlugin") {
            NotificationClearPlugin.register(with: registrar)
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
