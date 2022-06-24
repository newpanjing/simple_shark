import Cocoa
import FlutterMacOS
import UserNotifications
import SwiftUI
import os.log

@NSApplicationMain
class AppDelegate: FlutterAppDelegate, UNUserNotificationCenterDelegate {


    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {

        true
    }

    var token=""
    
     override func applicationDidFinishLaunching(_ notification: Notification) {
         NSLog("启动成功")

          if #available(macOS 10.14, *) {
              let userNotificationCenter = UNUserNotificationCenter.current()
              userNotificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                  print("Permission granted: \(granted)")
              }
 
              NSApplication.shared.registerForRemoteNotifications()
              UNUserNotificationCenter.current().delegate = self
          }

             
         //注册事件
         let controller : FlutterViewController = mainFlutterWindow?.contentViewController as! FlutterViewController
         let channel = FlutterMethodChannel(name: "com.github.panjing.MethodChannel", binaryMessenger: controller.engine.binaryMessenger)
         channel.setMethodCallHandler { (call:FlutterMethodCall, result:@escaping FlutterResult) in
             if (call.method == "getToken") {
                 result(["token":self.token])
             }
         }

    }
    

     override func application(_ application: NSApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

         self.token = deviceToken.map {
                     String(format: "%02.2hhx", $0)
                 }
                 .joined()
         print(self.token)

         //收到token，发送给flutter
         let channel = FlutterEventChannel()

         if #available(macOS 10.14, *) {
             print(NSApplication.shared.isRegisteredForRemoteNotifications)
         }
     }

     override func application(_ application: NSApplication,
                               didFailToRegisterForRemoteNotificationsWithError
                               error: Error) {
         // Try again later.
         NSLog("Register Error")
     }

     override func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String: Any]) {
         print(userInfo)

     }

}
