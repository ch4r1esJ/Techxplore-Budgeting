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
    @Published var isLoadingTrips = false

    @Published var country: String = ""
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var budget: String = ""
    @Published var selectedPurposes: Set<String> = []

    @Published var isGenerating = false
    @Published var generationError: String? = nil
    @Published var showSuccessToast = false

    let availablePurposes = [
        "Sightseeing", "Visit Friends", "Business",
        "Leisure", "Adventure", "Culture & Art"
    ]

    private let fetchTripsUseCase: FetchTripsUseCase
    private let generateBudgetUseCase: GenerateBudgetUseCase
    private let tripRepository: TripRepositoryProtocol

    init(fetchTripsUseCase: FetchTripsUseCase, generateBudgetUseCase: GenerateBudgetUseCase, tripRepository: TripRepositoryProtocol) {
        self.fetchTripsUseCase = fetchTripsUseCase
        self.generateBudgetUseCase = generateBudgetUseCase
        self.tripRepository = tripRepository
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
        generationError = nil
    }

    func loadTrips() {
        isLoadingTrips = true
        Task { @MainActor in
            do {
                trips = try await fetchTripsUseCase.execute()
            } catch {
                print("Failed to load trips: \(error)")
            }
            isLoadingTrips = false
        }
    }
    
    func deleteTrip(_ trip: TripBudget) {
        trips.removeAll { $0.id == trip.id }
        Task { @MainActor in
            do {
                try await tripRepository.deleteTrip(id: trip.id)
            } catch {
                print("Failed to delete trip: \(error)")
                loadTrips()
            }
        }
    }


    func generateBudgetPlan() {
        guard let budgetValue = Double(budget), !country.isEmpty else {
            generationError = "Please fill in country and budget"
            return
        }

        let days = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 7
        isGenerating = true
        generationError = nil

        Task { @MainActor in
            do {
                let categories = try await generateBudgetUseCase.execute(
                    destination: country,
                    days: days,
                    totalBudget: budgetValue,
                    purposes: Array(selectedPurposes)
                )

                let newTrip = TripBudget(
                    id: UUID().uuidString,
                    destination: country,
                    flag: flagFor(country),
                    startDate: startDate,
                    endDate: endDate,
                    budget: budgetValue,
                    spent: 0,
                    status: tripStatus(start: startDate, end: endDate),
                    categories: categories
                )

                let savedTrip = try await tripRepository.addTrip(newTrip, categories: categories)
                trips.append(savedTrip)
                isShowingAddTrip = false
                resetForm()
                withAnimation {
                    showSuccessToast = true
                }
            } catch {
                print("Generate/save error: \(error)")
                generationError = "Failed to generate budget. Try again."
            }
            isGenerating = false
        }
    }

    private func flagFor(_ country: String) -> String {
        guard let regionCode = Locale.Region.isoRegions.first(where: {
            Locale.current.localizedString(forRegionCode: $0.identifier)?.lowercased() == country.lowercased()
        })?.identifier else { return "🌍" }

        let flag = regionCode.unicodeScalars
            .compactMap { Unicode.Scalar(127397 + $0.value) }
            .map { String($0) }
            .joined()

        return flag.isEmpty ? "🌍" : flag
    }

    private func tripStatus(start: Date, end: Date) -> TripStatus {
        let now = Date()
        if now < start { return .future }
        if now > end   { return .completed }
        return .ongoing
    }
}
