//
//  TripDetailViewModel.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI
import Combine

class TripDetailViewModel: ObservableObject {
    @Published var categories: [TripCategory] = []
    @Published var expenses: [Expense] = []
    @Published var isShowingAddExpense = false

    let trip: TripBudget

    init(trip: TripBudget) {
        self.trip = trip
        loadMockData()
    }

    var totalBudget: Double {
        categories.reduce(0) { $0 + $1.budgetAmount }
    }

    var totalSpent: Double {
        categories.reduce(0) { $0 + $1.spentAmount }
    }

    var budgetStatusText: String {
        totalSpent > totalBudget ? "Exceeded" : "On Track"
    }

    var budgetStatusColor: Color {
        totalSpent > totalBudget ? .red : Color.activePill
    }
    
    var totalSpentColor: Color {
        totalSpent > totalBudget ? .red : .white
    }
    

    var dateRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return "\(formatter.string(from: trip.startDate)) – \(formatter.string(from: trip.endDate))"
    }

    var daysCount: Int {
        Calendar.current.dateComponents([.day], from: trip.startDate, to: trip.endDate).day ?? 0
    }

    var aiSuggestion: String {
        "🤖 AI · \(daysCount)-day adventure trip to \(trip.destination)"
    }

    func addExpense(categoryName: String, amount: Double, note: String) {
        let expense = Expense(categoryName: categoryName, amount: amount, date: Date(), note: note)
        expenses.append(expense)

        if let index = categories.firstIndex(where: { $0.name == categoryName }) {
            categories[index].spentAmount += amount
        }
    }
    
    func updateBudget(for categoryName: String, amount: Double) {
        guard let index = categories.firstIndex(where: { $0.name == categoryName }) else { return }
        categories[index].budgetAmount = amount
    }
    
    private func loadMockData() {
        categories = [
            TripCategory(name: "Accommodation", icon: "🏨", color: Color(red: 0.6, green: 0.5, blue: 0.9), budgetAmount: 15000, spentAmount: 0),
            TripCategory(name: "Food",          icon: "🍽️", color: Color(red: 0.8, green: 0.7, blue: 0.3), budgetAmount: 10000, spentAmount: 0),
            TripCategory(name: "Transport",     icon: "✈️", color: Color(red: 0.3, green: 0.7, blue: 0.8), budgetAmount: 9000,  spentAmount: 0),
            TripCategory(name: "Sightseeing",   icon: "🏛️", color: Color(red: 0.9, green: 0.6, blue: 0.4), budgetAmount: 7500,  spentAmount: 0),
            TripCategory(name: "Shopping",      icon: "🛍️", color: Color(red: 0.5, green: 0.8, blue: 0.6), budgetAmount: 7000,  spentAmount: 0),
            TripCategory(name: "Health",        icon: "🏥", color: Color(red: 0.4, green: 0.6, blue: 0.9), budgetAmount: 1000,  spentAmount: 0),
            TripCategory(name: "Misc",          icon: "📦", color: Color(red: 0.5, green: 0.5, blue: 0.5), budgetAmount: 500,   spentAmount: 0)
        ]
    }
}
