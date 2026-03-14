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
        let userId = APIClient.userId
        async let future: [TripListItemDTO] = client.get("/api/trips?userId=\(userId)&status=Future")
        async let ongoing: [TripListItemDTO] = client.get("/api/trips?userId=\(userId)&status=Ongoing")
        async let completed: [TripListItemDTO] = client.get("/api/trips?userId=\(userId)&status=Completed")
        let all = try await future + ongoing + completed
        return all.map { $0.toDomain() }
    }

    func fetchTripDetail(id: String) async throws -> TripBudget {
        let dto: TripDetailDTO = try await client.get("/api/trips/\(id)")
        return dto.toDomain()
    }

    func addTrip(_ trip: TripBudget, categories: [TripCategory]) async throws -> TripBudget {
        struct CreateTripResponse: Decodable { let id: String }
        
        let body = CreateTripRequest(
            userId: APIClient.userId,
            destination: trip.destination,
            flag: trip.flag,
            startDate: ISO8601DateFormatter.iso.string(from: trip.startDate),
            endDate: ISO8601DateFormatter.iso.string(from: trip.endDate),
            budget: trip.budget,
            categories: categories.map { CategoryRequest(name: $0.name, budgetAmount: $0.budgetAmount) }
        )
        
        let response: CreateTripResponse = try await client.post("/api/trips", body: body)
        return try await fetchTripDetail(id: response.id)
    }

    func addExpense(tripId: String, categoryName: String, amount: Double) async throws {
        let body = AddExpenseRequest(
            categoryName: categoryName,
            amount: amount,
            date: ISO8601DateFormatter.iso.string(from: Date()),
            note: ""
        )
        let _: TripDetailDTO = try await client.post("/api/trips/\(tripId)/expenses", body: body)
    }

    func updateCategories(tripId: String, categories: [TripCategory]) async throws {
        let body = UpdateCategoriesRequest(
            categories: categories.map { UpdateCategoryRequest(name: $0.name, budgetAmount: $0.budgetAmount) }
        )
        try await client.put("/api/trips/\(tripId)/categories", body: body)
    }
    
    func deleteTrip(id: String) async throws {
        let _: EmptyResponse = try await client.delete("/api/trips/\(id)")
    }
}
