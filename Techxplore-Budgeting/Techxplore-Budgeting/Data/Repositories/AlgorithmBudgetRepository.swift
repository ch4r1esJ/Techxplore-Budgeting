//
//  AlgorithmBudgetRepository.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/13/26.
//


import SwiftUI

final class AlgorithmBudgetRepository: AIBudgetRepositoryProtocol {
    
    func generateBudget(destination: String, days: Int, totalBudget: Double, purposes: [String]) async throws -> [TripCategory] {
        let ratios = calculateRatios(destination: destination, purposes: purposes)
        return buildCategories(from: ratios, totalBudget: totalBudget, purposes: purposes)
    }
    
    func generateInsight(trip: TripBudget) async throws -> String {
        let perDay = trip.budget / Double(max(trip.daysCount, 1))
        return "\(trip.destination) · \(trip.daysCount) days · ₾\(Int(perDay))/day average budget."
    }
    
    private func calculateRatios(destination: String, purposes: [String]) -> [String: Double] {
        var ratios: [String: Double] = [
            "Accommodation": 0.35,
            "Food":          0.25,
            "Transport":     0.15,
            "Shopping":      0.10,
            "Health":        0.05,
            "Misc":          0.05,
            "Sightseeing":   0.05
        ]
        
        let expensiveDestinations = ["france", "germany", "italy", "spain", "netherlands",
                                     "uk", "switzerland", "norway", "sweden", "denmark",
                                     "japan", "singapore", "australia", "usa", "canada"]
        let cheapDestinations = ["georgia", "armenia", "azerbaijan", "turkey",
                                 "thailand", "vietnam", "indonesia", "egypt", "morocco"]
        
        let dest = destination.lowercased()
        
        if expensiveDestinations.contains(where: { dest.contains($0) }) {
            ratios["Accommodation"] = 0.42
            ratios["Food"]          = 0.28
            ratios["Transport"]     = 0.12
            ratios["Shopping"]      = 0.08
            ratios["Sightseeing"]   = 0.05
            ratios["Health"]        = 0.03
            ratios["Misc"]          = 0.02
        } else if cheapDestinations.contains(where: { dest.contains($0) }) {
            ratios["Accommodation"] = 0.25
            ratios["Food"]          = 0.20
            ratios["Transport"]     = 0.10
            ratios["Shopping"]      = 0.15
            ratios["Sightseeing"]   = 0.15
            ratios["Health"]        = 0.08
            ratios["Misc"]          = 0.07
        }
        
        if purposes.contains("Business") {
            ratios["Accommodation"]    = (ratios["Accommodation"] ?? 0) + 0.10
            ratios["Shopping"]         = max((ratios["Shopping"] ?? 0) - 0.05, 0)
            ratios["Sightseeing"]      = max((ratios["Sightseeing"] ?? 0) - 0.05, 0)
        }
        if purposes.contains("Visit Friends") {
            ratios["Accommodation"]    = max((ratios["Accommodation"] ?? 0) - 0.15, 0.05)
            ratios["Food"]             = (ratios["Food"] ?? 0) + 0.08
            ratios["Shopping"]         = (ratios["Shopping"] ?? 0) + 0.07
        }
        if purposes.contains("Adventure") {
            ratios["Transport"]        = (ratios["Transport"] ?? 0) + 0.08
            ratios["Health"]           = (ratios["Health"] ?? 0) + 0.05
            ratios["Accommodation"]    = max((ratios["Accommodation"] ?? 0) - 0.08, 0.10)
            ratios["Shopping"]         = max((ratios["Shopping"] ?? 0) - 0.05, 0)
        }
        if purposes.contains("Culture & Art") {
            ratios["Sightseeing"]      = (ratios["Sightseeing"] ?? 0) + 0.10
            ratios["Shopping"]         = max((ratios["Shopping"] ?? 0) - 0.05, 0)
            ratios["Misc"]             = max((ratios["Misc"] ?? 0) - 0.05, 0)
        }
        if purposes.contains("Leisure") {
            ratios["Food"]             = (ratios["Food"] ?? 0) + 0.05
            ratios["Shopping"]         = (ratios["Shopping"] ?? 0) + 0.05
            ratios["Accommodation"]    = max((ratios["Accommodation"] ?? 0) - 0.05, 0.10)
            ratios["Transport"]        = max((ratios["Transport"] ?? 0) - 0.05, 0.05)
        }
        
        let total = ratios.values.reduce(0, +)
        return ratios.mapValues { $0 / total }
    }
    
    private func buildCategories(from ratios: [String: Double], totalBudget: Double, purposes: [String]) -> [TripCategory] {
        var allCategories: [(String, String)] = [
            ("Accommodation", "🏨"),
            ("Food", "🍽️"),
            ("Transport", "✈️")
        ]
        
        if purposes.contains("Sightseeing") || purposes.contains("Culture & Art") || purposes.isEmpty {
            allCategories.append(("Sightseeing", "🏛️"))
        }
        if purposes.contains("Culture & Art") {
            allCategories.append(("Museums & Shows", "🎭"))
        }
        if purposes.contains("Adventure") {
            allCategories.append(("Activities & Tours", "🧗"))
        }
        if purposes.contains("Business") {
            allCategories.append(("Business Expenses", "💼"))
        }
        if purposes.contains("Visit Friends") {
            allCategories.append(("Gifts & Souvenirs", "🎁"))
        }
        if purposes.contains("Leisure") {
            allCategories.append(("Entertainment", "🎉"))
        }
        if purposes.contains("Shopping") || purposes.isEmpty {
            allCategories.append(("Shopping", "🛍️"))
        }
        
        allCategories.append(("Health", "🏥"))
        allCategories.append(("Misc", "📦"))
        
        let extraCount = Double(allCategories.count - 3)
        var extraRatio = 0.0
        if extraCount > 0 {
            extraRatio = ((ratios["Sightseeing"] ?? 0) + (ratios["Shopping"] ?? 0)) / extraCount
        }
        
        var result: [TripCategory] = []
        var remaining = totalBudget
        
        for (index, (name, icon)) in allCategories.enumerated() {
            let isLast = index == allCategories.count - 1
            let ratio: Double
            
            switch name {
            case "Accommodation":    ratio = ratios["Accommodation"] ?? 0.35
            case "Food":             ratio = ratios["Food"] ?? 0.25
            case "Transport":        ratio = ratios["Transport"] ?? 0.15
            case "Health":           ratio = max(ratios["Health"] ?? 0.05, 50 / totalBudget)
            case "Misc":             ratio = max(ratios["Misc"] ?? 0.05, 50 / totalBudget)
            default:                 ratio = extraRatio
            }
            
            let amount = isLast ? remaining : max(floor(totalBudget * ratio), 50)
            remaining -= isLast ? 0 : amount
            
            result.append(TripCategory(
                name: name,
                icon: icon,
                color: colorFor(name),
                budgetAmount: max(amount, 50),
                spentAmount: 0
            ))
        }
        
        return result
    }
    
    private func colorFor(_ name: String) -> Color {
        switch name {
        case "Accommodation":      return Color(red: 0.6, green: 0.5, blue: 0.9)
        case "Food":               return Color(red: 0.8, green: 0.7, blue: 0.3)
        case "Transport":          return Color(red: 0.3, green: 0.7, blue: 0.8)
        case "Sightseeing":        return Color(red: 0.9, green: 0.6, blue: 0.4)
        case "Shopping":           return Color(red: 0.5, green: 0.8, blue: 0.6)
        case "Health":             return Color(red: 0.4, green: 0.6, blue: 0.9)
        case "Museums & Shows":    return Color(red: 0.8, green: 0.4, blue: 0.7)
        case "Activities & Tours": return Color(red: 0.3, green: 0.8, blue: 0.5)
        case "Business Expenses":  return Color(red: 0.5, green: 0.6, blue: 0.8)
        case "Gifts & Souvenirs":  return Color(red: 0.9, green: 0.5, blue: 0.5)
        case "Entertainment":      return Color(red: 0.7, green: 0.4, blue: 0.9)
        default:                   return Color(red: 0.5, green: 0.5, blue: 0.5)
        }
    }
}
