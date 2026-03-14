//
//  FetchTripDetailUseCase.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/14/26.
//

import Foundation

final class FetchTripDetailUseCase {
    private let repository: TripRepositoryProtocol
    init(repository: TripRepositoryProtocol) { self.repository = repository }
    
    func execute(id: String) async throws -> TripBudget {
        try await repository.fetchTripDetail(id: id)
    }
}
