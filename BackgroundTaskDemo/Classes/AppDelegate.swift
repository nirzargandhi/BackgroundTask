//
//  AppDelegate.swift
//  BackgroundTaskDemo
//
//  Created by Nirzar Gandhi on 05/12/24.
//

import UIKit
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties
    internal var window: UIWindow?
    var navController : UINavigationController?
    var dashboardVC: DashboardVC!
    
    let bgTaskLocalNotif = "com.BGTask.localNotif"
    
    
    // MARK: - RootView Setup
    func setRootViewController(rootVC: UIViewController) {
        
        self.navController = UINavigationController(rootViewController: rootVC)
        self.window?.rootViewController = self.navController
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Set Root Controller
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        
        let dashboardVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
        self.setRootViewController(rootVC: dashboardVC)
        
        self.window?.makeKeyAndVisible()
        
        application.applicationIconBadgeNumber = -1
        
        self.registerBgTask()
        
        self.registerForPushNotifications()
        
        return true
    }
}


// MARK: - Call Back
extension AppDelegate {
    
    fileprivate func registerBgTask() {
        
        BGTaskScheduler.shared.cancelAllTaskRequests()
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: self.bgTaskLocalNotif, using: nil) { task in
            
            guard let task = task as? BGProcessingTask else { return }
            
            self.scheduleNotification()
            self.handleBackgroundTask(task: task)
        }
    }
    
    fileprivate func handleBackgroundTask(task: BGProcessingTask) {
        
        self.submitBackgroundTask()
        
        task.setTaskCompleted(success: true)
    }
    
    fileprivate func submitBackgroundTask() {
        
        // check if there is a pending task request or not
        BGTaskScheduler.shared.getPendingTaskRequests { [weak self] request in
            print("\(request.count) BGTask pending.")
            
            guard request.isEmpty else { return }
            
            // Create a new background task request
            if let task = self?.bgTaskLocalNotif {
                
                let request = BGProcessingTaskRequest(identifier: task)
                request.requiresNetworkConnectivity = false
                request.requiresExternalPower = false
                request.earliestBeginDate = Date(timeIntervalSinceNow: 60) // Schedule the next task in 2 minutes
                
                do {
                    try BGTaskScheduler.shared.submit(request)
                } catch {
                    print("Unable to schedule background task: \(error.localizedDescription)")
                }
            }
        }
    }
    
    fileprivate func scheduleNotification() {
        
        var count = 0
        let content = UNMutableNotificationContent()
        content.title = "Local Notification"
        content.body = "This is a local notification example."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        let request = UNNotificationRequest(identifier: "localNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
            
            count += 1
        }
    }
}

// MARK: -
// MARK: - Remote Notification Handler
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    fileprivate func registerForPushNotifications() {
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound,.alert,.badge]) { (granted, error) in
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    fileprivate func getNotificationSettings() {
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            
            print("Notification settings: \(settings)")
            
            guard settings.authorizationStatus == .authorized else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("\nAPNs device token: " + deviceTokenString + "\n")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }
    
    // MARK: - UNUserNotificationCenter Delegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler: @escaping (UNNotificationPresentationOptions)->()) {
        
        // Show Notification Banner List (Handler)
        withCompletionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let _ = response.notification.request.content.userInfo
        
        UIApplication.shared.applicationIconBadgeNumber = -1
        
        completionHandler()
    }
}
