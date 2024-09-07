//
//  NotificationsUtils.swift
//  Calendar
//
//  Created by Kacper Lipiec on 05/09/2024.
//

import Foundation
import UserNotifications

/// - Returns: prints if yes or no a permission is authorized
public func requestNotificationPermission(){
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
        granted, error in if let error = error{
            print("Error requesting notification permission: \(error.localizedDescription)")
        }else if granted {
            print("Permission granted")
        }else{
            print("Permission denied")
        }
    }
}

/// - Parameter notificationTitle: a text that is printed as the title of a notification thrown
/// - Parameter notificationBody: a text that is printed as the body of a notification thrown
public func scheduleLocalNotification(notificationTitle: String, notificationBody: String) async {
    //Get the current notification center
    let center = UNUserNotificationCenter.current()

    //Fetch the current notification settings asynchronously
    let settings = await center.notificationSettings()

    //Check if the app has authorization to send notifications
    guard(settings.authorizationStatus == .authorized) || (settings.authorizationStatus == .provisional) else {
        print("Notifications are not authorized")
        return
    }
    
    //Check if the alert setting is enabled
    if settings.alertSetting == .enabled{
        do{
            let content = UNMutableNotificationContent()
            content.title = notificationTitle
            content.body = notificationBody
            content.sound = UNNotificationSound.default
            
            //May be better in the futur
            
            //var dateComponents = DateComponents()
            //dateComponents.year = 2024
            //dateComponents.month = 1
            //dateComponents.day = 1
            //dateComponents.hour = 9
            //dateComponents.minute = 0

            //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            //create a time based trigger
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            //create the request
            let request = UNNotificationRequest(identifier: "alertOnlyNotification", content: content, trigger: trigger)
            
            //Add the notification request to the center
            try await center.add(request)
            print("Alert notification scheduled.")
        }catch{
            print("Failed to schedule alert notifications: \(error.localizedDescription)")
        }
        //Schedule an alert-only notification
    }
}



