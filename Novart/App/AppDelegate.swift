//
//  AppDelegate.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/06/25.
//

import UIKit
import GoogleSignIn
import KakaoSDKCommon
import Firebase
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        FirebaseApp.configure()
        configureGoogleSignIn()
        configureKakaoSignIn()
        registerNotification()
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

private extension AppDelegate {
    func configureGoogleSignIn() {
        let signInConfig = GIDConfiguration.init(clientID: "937960757565-2verfe9hqvo4jrkfo9oenuukqtatpt7b.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.configuration = signInConfig
    }
    
    func configureKakaoSignIn() {
        KakaoSDK.initSDK(appKey: "4c764881505c7f1c4fc42bff687e9d79")
    }
}


// MARK: - Push Notification
extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    func registerNotification() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, _ in
            print("🔔🔔🔔 Push Notification granted: \(granted)")
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        // Firebase Token
        print("🔔🔔🔔 FCM Token: \(fcmToken)")
        
        // todo: 서버에 보내기
        
    }
}
