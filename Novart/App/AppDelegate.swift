//
//  AppDelegate.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/06/25.
//

import UIKit
import GoogleSignIn
import KakaoSDKCommon

@main
class AppDelegate: UIResponder {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configureGoogleSignIn()
        configureKakaoSignIn()
        registerForPushNotifications()
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
extension AppDelegate: UIApplicationDelegate {
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(
                options: [.alert, .sound, .badge]) { [weak self] granted, _ in
                    print("🔔🔔🔔 Push Notification Permission granted: \(granted)")
                    guard granted else { return }
                    
                    self?.getNotificationSettings()
                }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("🔔🔔🔔 Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("🔔🔔🔔 Failed to register: \(error)")
    }
}
