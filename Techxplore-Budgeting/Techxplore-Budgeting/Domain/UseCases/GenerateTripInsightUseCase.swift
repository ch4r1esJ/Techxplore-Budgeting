//
//  GenerateTripInsightUseCase.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/13/26.
//

import Foundation

final class GenerateTripInsightUseCase {
    private let repository: AIBudgetRepositoryProtocol

    init(repository: AIBudgetRepositoryProtocol) {
        self.repository = repository
    }

    func execute(trip: TripBudget) async throws -> String {
        try await repository.generateInsight(trip: trip)
    }
}
