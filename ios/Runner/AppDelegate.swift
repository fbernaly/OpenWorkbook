import UIKit
import Flutter
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import AppCenterDistribute

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  
  override func application(_ application: UIApplication,
                            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    MSAppCenter.start("f9fbee81-875e-4493-8f1f-ccc47fed1323", withServices:[
      MSDistribute.self,
      MSAnalytics.self,
      MSCrashes.self
    ])
    
    if let controller = self.window.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(name: "com.openworkbook.orientation", binaryMessenger: controller.binaryMessenger)
      channel.setMethodCallHandler { (call, result) in
        if call.method == "setLandscape" {
          UIDevice.current.setValue( UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        } else if call.method == "setPortrait" {
          UIDevice.current.setValue( UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
      }
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
