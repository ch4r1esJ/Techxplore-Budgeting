//
//  HomeViewModel.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI
import Combine

enum TripTimeCategory: String, CaseIterable {
    case future = "Future"
    case current = "Ongoing"
    case past = "Past"
}

final class HomeViewModel: ObservableObject {
    @Published var selectedFilter: TripTimeCategory = .current
    @Published var isShowingAddTrip = false
    @Published var trips: [TripBudget] = []

    @Published var country: String = ""
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var budget: String = ""
    @Published var selectedPurposes: Set<String> = []

    let availablePurposes = [
        "Sightseeing", "Visit Friends", "Business",
        "Leisure", "Adventure", "Culture & Art"
    ]

    private let fetchTripsUseCase: FetchTripsUseCase

    init(fetchTripsUseCase: FetchTripsUseCase) {
        self.fetchTripsUseCase = fetchTripsUseCase
        loadTrips()
    }

    var filteredTrips: [TripBudget] {
        trips.filter { trip in
            switch selectedFilter {
            case .future:  return trip.status == .future
            case .current: return trip.status == .ongoing
            case .past:    return trip.status == .completed
            }
        }
    }

    var totalBudget: Double {
        filteredTrips.reduce(0) { $0 + $1.budget }
    }

    var budgetData: [BudgetCategory] {
        var seen: [String] = []
        var totals: [String: (Double, String, Color)] = [:]

        for trip in filteredTrips {
            for category in trip.categories {
                if totals[category.name] == nil {
                    seen.append(category.name)
                    totals[category.name] = (category.budgetAmount, category.icon, category.color)
                } else {
                    totals[category.name]!.0 += category.budgetAmount
                }
            }
        }

        return seen.compactMap { name in
            guard let data = totals[name] else { return nil }
            return BudgetCategory(name: name, amount: data.0, icon: data.1, color: data.2)
        }
    }

    func togglePurpose(_ purpose: String) {
        if selectedPurposes.contains(purpose) {
            selectedPurposes.remove(purpose)
        } else {
            selectedPurposes.insert(purpose)
        }
    }

    func resetForm() {
        country = ""
        startDate = Date()
        endDate = Date()
        budget = ""
        selectedPurposes.removeAll()
    }

    private func loadTrips() {
        trips = fetchTripsUseCase.execute()
    }
}
