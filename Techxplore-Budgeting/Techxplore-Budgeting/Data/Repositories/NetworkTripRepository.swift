//
//  NetworkTripRepository.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/13/26.
//


import Foundation

final class NetworkTripRepository: TripRepositoryProtocol {
    private let client = APIClient()

    func fetchTrips() async throws -> [TripBudget] {
        let dtos: [TripListItemDTO] = try await client.get("/trips?userId=\(APIClient.userId)")
        return dtos.map { $0.toDomain() }
    }

    func fetchTripDetail(id: String) async throws -> TripBudget {
        let dto: TripDetailDTO = try await client.get("/trips/\(id)")
        return dto.toDomain()
    }

    func addTrip(_ trip: TripBudget, categories: [TripCategory]) async throws -> TripBudget {
        let body = CreateTripRequest(
            userId: APIClient.userId,
            destination: trip.destination,
            flag: trip.flag,
            startDate: DateFormatter.isoString(from: trip.startDate),
            endDate: DateFormatter.isoString(from: trip.endDate),
            budget: trip.budget,
            categories: categories.map { CategoryRequest(name: $0.name, budgetAmount: $0.budgetAmount) }
        )
        let dto: TripDetailDTO = try await client.post("/trips", body: body)
        return dto.toDomain()
    }

    func addExpense(tripId: String, categoryName: String, amount: Double) async throws {
        let body = AddExpenseRequest(categoryName: categoryName, amount: amount)
        try await client.put("/trips/\(tripId)/expenses", body: body)
    }

    func updateCategories(tripId: String, categories: [TripCategory]) async throws {
        let body = UpdateCategoriesRequest(
            categories: categories.map { CategoryRequest(name: $0.name, budgetAmount: $0.budgetAmount) }
        )
        try await client.put("/trips/\(tripId)/categories", body: body)
    }
}