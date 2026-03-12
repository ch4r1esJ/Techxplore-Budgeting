//
//  MockTripRepository.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/13/26.
//

import SwiftUI

final class MockTripRepository: TripRepositoryProtocol {

    private let defaultCategories: [TripCategory] = [
        TripCategory(name: "Accommodation", icon: "🏨", color: Color(red: 0.6, green: 0.5, blue: 0.9), budgetAmount: 15000, spentAmount: 100),
        TripCategory(name: "Food",          icon: "🍽️", color: Color(red: 0.8, green: 0.7, blue: 0.3), budgetAmount: 10000, spentAmount: 0),
        TripCategory(name: "Transport",     icon: "✈️", color: Color(red: 0.3, green: 0.7, blue: 0.8), budgetAmount: 9000,  spentAmount: 0),
        TripCategory(name: "Sightseeing",   icon: "🏛️", color: Color(red: 0.9, green: 0.6, blue: 0.4), budgetAmount: 7500,  spentAmount: 0),
        TripCategory(name: "Shopping",      icon: "🛍️", color: Color(red: 0.5, green: 0.8, blue: 0.6), budgetAmount: 8500,  spentAmount: 0)
    ]
    
    private let otherCategories: [TripCategory] = [
        TripCategory(name: "Accommodation", icon: "🏨", color: Color(red: 0.6, green: 0.5, blue: 0.9), budgetAmount: 1500, spentAmount: 100),
        TripCategory(name: "Food",          icon: "🍽️", color: Color(red: 0.8, green: 0.7, blue: 0.3), budgetAmount: 10000, spentAmount: 0),
        TripCategory(name: "Transport",     icon: "✈️", color: Color(red: 0.3, green: 0.7, blue: 0.8), budgetAmount: 1000,  spentAmount: 0),
        TripCategory(name: "Sightseeing",   icon: "🏛️", color: Color(red: 0.9, green: 0.6, blue: 0.4), budgetAmount: 3500,  spentAmount: 0),
        TripCategory(name: "Shopping",      icon: "🛍️", color: Color(red: 0.5, green: 0.8, blue: 0.6), budgetAmount: 1500,  spentAmount: 0)
    ]

    func fetchTrips() -> [TripBudget] {
        [
            TripBudget(
                destination: "Japan",
                flag: "🇯🇵",
                startDate: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 5))!,
                endDate: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 19))!,
                budget: 3100,
                spent: 4000,
                status: .ongoing,
                categories: defaultCategories
            ),
            TripBudget(
                destination: "Georgia",
                flag: "🇬🇪",
                startDate: Calendar.current.date(from: DateComponents(year: 2026, month: 3, day: 4))!,
                endDate: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 1))!,
                budget: 50000,
                spent: 500,
                status: .future,
                categories: otherCategories
            ),
            TripBudget(
                destination: "Italy",
                flag: "🇮🇹",
                startDate: Calendar.current.date(from: DateComponents(year: 2026, month: 3, day: 4))!,
                endDate: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 1))!,
                budget: 500,
                spent: 1000,
                status: .completed,
                categories: defaultCategories
            )
        ]
    }
}
