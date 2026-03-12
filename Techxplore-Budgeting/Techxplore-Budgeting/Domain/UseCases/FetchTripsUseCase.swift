//
//  FetchTripsUseCase.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/13/26.
//

import Foundation

final class FetchTripsUseCase {
    private let repository: TripRepositoryProtocol

    init(repository: TripRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> [TripBudget] {
        repository.fetchTrips()
    }
}
