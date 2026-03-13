//
//  NotificationServiceProtocol.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/13/26.
//


protocol NotificationServiceProtocol {
    func requestPermission()
    func scheduleIfNeeded(category: TripCategory, destination: String)
}