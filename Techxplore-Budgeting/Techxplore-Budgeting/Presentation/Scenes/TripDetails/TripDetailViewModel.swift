//
//  TripDetailViewModel.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI
import Combine

final class TripDetailViewModel: ObservableObject {
    @Published var categories: [TripCategory]
    @Published var expenses: [Expense] = []
    @Published var isShowingAddExpense = false

    let trip: TripBudget

    private let addExpenseUseCase: AddExpenseUseCase
    private let updateBudgetUseCase: UpdateBudgetUseCase

    init(trip: TripBudget, addExpenseUseCase: AddExpenseUseCase, updateBudgetUseCase: UpdateBudgetUseCase) {
        self.trip = trip
        self.categories = trip.categories
        self.addExpenseUseCase = addExpenseUseCase
        self.updateBudgetUseCase = updateBudgetUseCase
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

    func addExpense(categoryName: String, amount: Double) {
        addExpenseUseCase.execute(
            categories: &categories,
            expenses: &expenses,
            categoryName: categoryName,
            amount: amount
        )
    }

    func updateBudget(for categoryName: String, amount: Double) {
        updateBudgetUseCase.execute(
            categories: &categories,
            categoryName: categoryName,
            newBudget: amount
        )
    }
}
