//
//  UpdateBudgetUseCase.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/13/26.
//

import Foundation

final class UpdateBudgetUseCase {
    func execute(categories: inout [TripCategory], categoryName: String, newBudget: Double) {
        guard let index = categories.firstIndex(where: { $0.name == categoryName }) else { return }
        categories[index].budgetAmount = newBudget
    }
}
