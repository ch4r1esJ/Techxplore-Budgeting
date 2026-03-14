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
    let date: String
    let note: String
}

struct UpdateCategoriesRequest: Encodable {
    let categories: [UpdateCategoryRequest]
}

struct UpdateCategoryRequest: Encodable {
    let name: String
    let budgetAmount: Double
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
    let categories: [CategoryDetailDTO]?
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
    let categories: [CategoryDetailDTO]?
}

struct CategoryDetailDTO: Decodable {
    let name: String
    let icon: String?
    let colorHex: String?
    let budgetAmount: Double
    let spentAmount: Double
}

extension TripListItemDTO {
    func toDomain() -> TripBudget {
        return TripBudget(
            id: id,
            destination: destination,
            flag: flag,
            startDate: ISO8601DateFormatter.parseDate(from: startDate),
            endDate: ISO8601DateFormatter.parseDate(from: endDate),
            budget: budget,
            spent: spent,
            status: TripStatus(rawValue: status) ?? .future,
            categories: categories?.map { $0.toDomain() } ?? []
        )
    }
}

extension TripDetailDTO {
    func toDomain() -> TripBudget {
        TripBudget(
            id: id,
            destination: destination,
            flag: flag,
            startDate: ISO8601DateFormatter.parseDate(from: startDate),
            endDate: ISO8601DateFormatter.parseDate(from: endDate),
            budget: budget,
            spent: spent,
            status: TripStatus(rawValue: status) ?? .future,
            categories: categories?.map { $0.toDomain() } ?? []
        )
    }
}

extension CategoryDetailDTO {
    func toDomain() -> TripCategory {
        TripCategory(
            name: name,
            icon: icon ?? "📦",
            color: colorHex.map { Color(hex: $0) } ?? Color(red: 0.5, green: 0.5, blue: 0.5),
            budgetAmount: budgetAmount,
            spentAmount: spentAmount
        )
    }
}

extension ISO8601DateFormatter {
    static let iso: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()

    static let isoNoFraction: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        return f
    }()

    static let plainFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }()

    static let plainFormatterNoFraction: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }()

    static func parseDate(from string: String) -> Date {
        return iso.date(from: string)
            ?? isoNoFraction.date(from: string)
            ?? plainFormatter.date(from: string)
            ?? plainFormatterNoFraction.date(from: string)
            ?? Date()
    }
}
