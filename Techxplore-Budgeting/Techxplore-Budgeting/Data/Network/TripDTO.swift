//
//  TripDTO.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/13/26.
//

import SwiftUI

struct CreateTripRequest: Encodable {
    let userId: String
    let destination: String
    let flag: String
    let startDate: String
    let endDate: String
    let budget: Double
    let categories: [CategoryRequest]
}

struct CategoryRequest: Encodable {
    let name: String
    let budgetAmount: Double
}

struct AddExpenseRequest: Encodable {
    let categoryName: String
    let amount: Double
}

struct UpdateCategoriesRequest: Encodable {
    let categories: [CategoryRequest]
}

struct TripListItemDTO: Decodable {
    let id: String
    let destination: String
    let flag: String
    let startDate: String
    let endDate: String
    let budget: Double
    let spent: Double
    let budgetStatus: String
    let status: String
}

struct TripDetailDTO: Decodable {
    let id: String
    let destination: String
    let flag: String
    let startDate: String
    let endDate: String
    let budget: Double
    let spent: Double
    let budgetStatus: String
    let status: String
    let categories: [CategoryDetailDTO]
}

struct CategoryDetailDTO: Decodable {
    let name: String
    let icon: String
    let colorHex: String
    let budgetAmount: Double
    let spentAmount: Double
}

extension TripListItemDTO {
    func toDomain() -> TripBudget {
        TripBudget(
            id: id,
            destination: destination,
            flag: flag,
            startDate: DateFormatter.iso.date(from: startDate) ?? Date(),
            endDate: DateFormatter.iso.date(from: endDate) ?? Date(),
            budget: budget,
            spent: spent,
            status: TripStatus(rawValue: status) ?? .future,
            categories: []
        )
    }
}

extension TripDetailDTO {
    func toDomain() -> TripBudget {
        TripBudget(
            id: id,
            destination: destination,
            flag: flag,
            startDate: DateFormatter.iso.date(from: startDate) ?? Date(),
            endDate: DateFormatter.iso.date(from: endDate) ?? Date(),
            budget: budget,
            spent: spent,
            status: TripStatus(rawValue: status) ?? .future,
            categories: categories.map { $0.toDomain() }
        )
    }
}

extension CategoryDetailDTO {
    func toDomain() -> TripCategory {
        TripCategory(
            name: name,
            icon: icon,
            color: Color(hex: colorHex),
            budgetAmount: budgetAmount,
            spentAmount: spentAmount
        )
    }
}

extension DateFormatter {
    static let iso: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return f
    }()

    static func isoString(from date: Date) -> String {
        iso.string(from: date)
    }
}
