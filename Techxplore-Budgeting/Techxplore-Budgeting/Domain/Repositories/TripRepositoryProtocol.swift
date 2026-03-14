//
//  TripRepositoryProtocol.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/13/26.
//

import Foundation

protocol TripRepositoryProtocol {
    func fetchTrips() async throws -> [TripBudget]
    func fetchTripDetail(id: String) async throws -> TripBudget
    func addTrip(_ trip: TripBudget, categories: [TripCategory]) async throws -> TripBudget
    func addExpense(tripId: String, categoryName: String, amount: Double) async throws
    func updateCategories(tripId: String, categories: [TripCategory]) async throws
    func deleteTrip(id: String) async throws
}
