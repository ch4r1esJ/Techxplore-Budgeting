//
//  GenerateBudgetUseCase.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/13/26.
//

import Foundation

final class GenerateBudgetUseCase {
    private let repository: AIBudgetRepositoryProtocol

    init(repository: AIBudgetRepositoryProtocol) {
        self.repository = repository
    }

    func execute(
        destination: String,
        days: Int,
        totalBudget: Double,
        purposes: [String]
    ) async throws -> [TripCategory] {
        try await repository.generateBudget(
            destination: destination,
            days: days,
            totalBudget: totalBudget,
            purposes: purposes
        )
    }
}
