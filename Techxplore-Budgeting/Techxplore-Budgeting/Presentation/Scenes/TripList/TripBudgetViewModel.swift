//
//  TripBudgetViewModel.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import Combine
import Foundation

enum TripStatus {
    case ongoing
    case future
    case completed
}

class TripBudgetViewModel: ObservableObject {
    @Published var trip: TripBudget
    
    init() {
        self.trip = TripBudget(
            destination: "Japan",
            flag: "🇯🇵",
            startDate: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 5))!,
            endDate: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 19))!,
            budget: 3200,
            spent: 3265,
            status: .future
        )
    }
    
    init(trip: TripBudget) {
        self.trip = trip
    }
    
    var formattedBudget: String {
        "₾\(Int(trip.budget).formatted())"
    }
    
    var formattedSpent: String {
        "₾\(Int(trip.spent).formatted())"
    }
    
    var progressPercent: String {
        "\(Int(trip.progress * 100))%"
    }
    
    var dateRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return "\(formatter.string(from: trip.startDate)) – \(formatter.string(from: trip.endDate))"
    }
    
    var isOverBudget: Bool {
        trip.progress >= 1.0
    }
}
