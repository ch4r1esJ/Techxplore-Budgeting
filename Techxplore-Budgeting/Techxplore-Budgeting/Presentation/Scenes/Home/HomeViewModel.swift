//
//  HomeViewModel.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI
import Combine

enum TripTimeCategory: String, CaseIterable {
    case future = "Future"
    case current = "Ongoing"
    case past = "Past"
}

class HomeViewModel: ObservableObject {
    @Published var selectedFilter: TripTimeCategory = .current
    @Published var isShowingAddTrip = false
    
    @Published var country: String = ""
    @Published var startDate: Date = Date()
    @Published var endDate = Date()
    @Published var budget: String = ""
    @Published var selectedPurposes: Set<String> = []
    
    @Published var budgetData: [BudgetCategory] = []
    @Published var trips: [TripBudget] = []
    
    init() {
        loadMockData()
    }
    
    let availablePurposes = [
        "Sightseeing", "Visit Friends", "Business",
        "Leisure", "Adventure", "Culture & Art"
    ]
    
    var totalBudget: Double {
        budgetData.reduce(0) { $0 + $1.amount }
    }
    
    func togglePurpose(_ purpose: String) {
        if selectedPurposes.contains(purpose) {
            selectedPurposes.remove(purpose)
        } else {
            selectedPurposes.insert(purpose)
        }
    }
    
    func resetForm() {
        country = ""
        startDate = Date()
        endDate = Date()
        budget = ""
        selectedPurposes.removeAll()
    }
    
    func loadMockData() {
        budgetData = [
            BudgetCategory(name: "Accommodation", amount: 13200, icon: "🏨", color: Color(red: 0.6, green: 0.5, blue: 0.9)),
            BudgetCategory(name: "Food", amount: 8250, icon: "🍽️", color: Color(red: 0.8, green: 0.7, blue: 0.3)),
            BudgetCategory(name: "Transport", amount: 4950, icon: "✈️", color: Color(red: 0.3, green: 0.7, blue: 0.8)),
            BudgetCategory(name: "Sightseeing", amount: 3300, icon: "🏛️", color: Color(red: 0.9, green: 0.6, blue: 0.4)),
            BudgetCategory(name: "Shopping", amount: 3300, icon: "🛍️", color: Color(red: 0.5, green: 0.8, blue: 0.6))
        ]
        
        trips = [
            TripBudget(
                destination: "Japan",
                flag: "🇯🇵",
                startDate: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 5))!,
                endDate: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 19))!,
                budget: 3100,
                spent: 4000,
                status: .ongoing,
            ),
            TripBudget(
                destination: "Georgia",
                flag: "🇬🇪",
                startDate: Calendar.current.date(from: DateComponents(year: 2026, month: 3, day: 4))!,
                endDate: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 1))!,
                budget: 50000,
                spent: 500,
                status: .future,
            ),
            TripBudget(
                destination: "Italy",
                flag: "🇮🇹",
                startDate: Calendar.current.date(from: DateComponents(year: 2026, month: 3, day: 4))!,
                endDate: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 1))!,
                budget: 500,
                spent: 1000,
                status: .completed,
            )
        ]
    }
}
