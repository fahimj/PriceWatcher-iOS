//
//  AppDelegate.swift
//  PriceWatcher iOS
//
//  Created by Fahim Jatmiko on 17/03/22.
//

import UIKit
import BackgroundTasks
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        registerBackgroundTask()
        return true
    }
    
    func registerBackgroundTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.fahim.PriceWatcher-iOS.fetchAndCache", using: nil) { task in
            self.scheduleAppRefresh()
            
            let locationManager = CLLocationManager()
            locationManager.requestAlwaysAuthorization()
            let urlSessionHttpClient = UrlSessionHttpClient(session: URLSession.shared)
            let remotePriceLoader = RemotePriceLoader(httpClient: urlSessionHttpClient)
            let dataRequestActivityManager = DataRequestActivityManager(loader: remotePriceLoader, cache: LocalPriceDataRequestActivityCache(), locationManager: locationManager)
            Task {
                do {
                    try await dataRequestActivityManager.loadRemotelyAndCache()
                    task.setTaskCompleted(success: true)
                }
                catch {
                    task.setTaskCompleted(success: false)
                }
                
            }
            
        }
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.fahim.PriceWatcher-iOS.removeCache", using: nil) { task in
            Task {
                self.scheduleDeleteLocalCache()
                LocalPriceDataRequestActivityCache().delete()
                task.setTaskCompleted(success: true)
            }
            
        }
        
        scheduleAppRefresh()
        scheduleDeleteLocalCache()
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.fahim.PriceWatcher-iOS.fetchAndCache")
        // Fetch no earlier than 60 minutes from now.
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 60)
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
    
    func scheduleDeleteLocalCache() {
        //delete once in 1 week
        let deleteTaskRequest = BGAppRefreshTaskRequest(identifier: "com.fahim.PriceWatcher-iOS.removeCache")
        deleteTaskRequest.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 60 * 24)
        
        do {
            try BGTaskScheduler.shared.submit(deleteTaskRequest)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
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

