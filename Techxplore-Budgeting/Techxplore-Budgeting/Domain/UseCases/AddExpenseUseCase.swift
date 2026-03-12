//
//  AddExpenseUseCase.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/13/26.
//

import Foundation

final class AddExpenseUseCase {
    func execute(
        categories: inout [TripCategory],
        expenses: inout [Expense],
        categoryName: String,
        amount: Double
    ) {
        let expense = Expense(categoryName: categoryName, amount: amount, date: Date(), note: "")
        expenses.append(expense)

        if let index = categories.firstIndex(where: { $0.name == categoryName }) {
            categories[index].spentAmount += amount
        }
    }
}
