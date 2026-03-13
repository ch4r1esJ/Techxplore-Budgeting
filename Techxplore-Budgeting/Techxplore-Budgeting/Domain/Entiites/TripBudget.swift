//
//  TripBudget.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import Foundation

struct TripBudget: Identifiable {
    let id: String  // TODO: Change to id: String
    let destination: String
    let flag: String
    let startDate: Date
    let endDate: Date
    let budget: Double
    let spent: Double
    let status: TripStatus
    let categories: [TripCategory]

    var daysCount: Int {
        Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
    }

    var progress: Double {
        spent / budget
    }
}
