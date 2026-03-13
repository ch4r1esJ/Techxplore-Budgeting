//
//  AIBudgetRepositoryProtocol.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/13/26.
//

import Foundation

protocol AIBudgetRepositoryProtocol {
    func generateBudget(destination: String, days: Int, totalBudget: Double, purposes: [String]) async throws -> [TripCategory]
    func generateInsight(trip: TripBudget) async throws -> String
}
