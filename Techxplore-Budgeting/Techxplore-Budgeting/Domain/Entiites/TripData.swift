//
//  TripData.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import Foundation

struct TripBudget: Identifiable {
    let id = UUID()
    let destination: String
    let flag: String
    let startDate: Date
    let endDate: Date
    let budget: Double
    let spent: Double
//    let categories: [BudgetCategory]
    let status: TripStatus

    var daysCount: Int {
        Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
    }

    var progress: Double {
        spent / budget
    }
}
