//
//  NotificationManager.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/13/26.
//

import UserNotifications

final class LocalNotificationService: NSObject, NotificationServiceProtocol, UNUserNotificationCenterDelegate {

    init(center: UNUserNotificationCenter = .current()) {
        super.init()
        center.delegate = self
    }

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    func scheduleIfNeeded(category: TripCategory, destination: String) {
        let progress = category.budgetAmount > 0 ? category.spentAmount / category.budgetAmount : 0

        if progress >= 1.0 {
            send(
                id: "\(destination)-\(category.name)-exceeded",
                title: "Budget Exceeded 🚨",
                body: "\(category.icon) \(category.name) in \(destination) has gone over budget!"
            )
        } else if progress >= 0.8 {
            send(
                id: "\(destination)-\(category.name)-warning",
                title: "Budget Warning ⚠️",
                body: "\(category.icon) \(category.name) in \(destination) is at \(Int(progress * 100))% of budget."
            )
        }
    }

    private func send(id: String, title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
}
