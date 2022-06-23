import Cocoa
import FlutterMacOS
import UserNotifications
import SwiftUI
import os.log

@NSApplicationMain
class AppDelegate: FlutterAppDelegate,UNUserNotificationCenterDelegate {
    
    
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {

    return true
}
    
    
    override func applicationDidFinishLaunching(_ notification: Notification) {
        NSLog("启动成功")

        if #available(macOS 10.14, *){
            let userNotificationCenter = UNUserNotificationCenter.current()
            userNotificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                print("Permission granted: \(granted)")
            }
            
            NSApplication.shared.registerForRemoteNotifications()
            UNUserNotificationCenter.current().delegate=self
        }
        
    }

    

    override func application(
        _ application: NSApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ){
        
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(token)
        
        if #available(macOS 10.15, *) {
            Alert(title: Text("Hello SwiftUI!"),
                  message: Text(token),
                  dismissButton: .default(Text("OK")))
        }
        
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
    
    override func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String : Any]) {
        print(userInfo)
    }
    
}
