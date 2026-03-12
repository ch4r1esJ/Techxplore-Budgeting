//
//  TripRepositoryProtocol.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/13/26.
//

import Foundation

protocol TripRepositoryProtocol {
    func fetchTrips() -> [TripBudget]
}
