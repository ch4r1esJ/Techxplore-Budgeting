//
//  FirebaseAIBudgetRepository.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/13/26.
//

import SwiftUI
import FirebaseAI

final class FirebaseAIBudgetRepository: AIBudgetRepositoryProtocol {
    private let model: GenerativeModel

    init() {
        let ai = FirebaseAI.firebaseAI(backend: .googleAI())
        self.model = ai.generativeModel(modelName: "gemini-2.5-flash")
    }

    func generateBudget(
        destination: String,
        days: Int,
        totalBudget: Double,
        purposes: [String]
    ) async throws -> [TripCategory] {
        do {
            let categoryList = buildCategoryList(purposes: purposes)

            let prompt = """
            You are an expert travel budget planner with deep knowledge of travel costs worldwide.
            Generate a realistic budget breakdown for this trip in Georgian Lari (₾ GEL).

            Trip details:
            - Destination: \(destination)
            - Duration: \(days) days
            - Total budget: ₾\(Int(totalBudget)) GEL
            - Purposes: \(purposes.isEmpty ? "General tourism" : purposes.joined(separator: ", "))

            Real daily cost references in GEL (use these to guide proportions):
            - Georgia/Armenia/Azerbaijan: accommodation ₾80-150/night, food ₾40-80/day, local transport ₾20-50/day
            - Turkey/Egypt/Morocco: accommodation ₾120-200/night, food ₾60-100/day, local transport ₾30-60/day
            - Eastern Europe (Poland, Czech, Romania, Hungary): accommodation ₾150-250/night, food ₾80-150/day, local transport ₾40-80/day
            - Southern Europe (Greece, Croatia, Portugal): accommodation ₾250-450/night, food ₾120-200/day, local transport ₾60-100/day
            - Western Europe (France, Germany, Italy, Spain, Netherlands): accommodation ₾400-700/night, food ₾200-350/day, local transport ₾80-150/day
            - UK/Switzerland/Scandinavia: accommodation ₾600-1000/night, food ₾300-500/day, local transport ₾100-200/day
            - Japan/South Korea/Singapore: accommodation ₾350-600/night, food ₾150-280/day, local transport ₾60-120/day
            - USA/Canada/Australia: accommodation ₾550-900/night, food ₾250-450/day, local transport ₾80-160/day
            - Southeast Asia (Thailand, Vietnam, Bali): accommodation ₾80-200/night, food ₾40-100/day, local transport ₾20-60/day
            - UAE/Qatar: accommodation ₾400-800/night, food ₾200-400/day, local transport ₾80-150/day

            Purpose adjustments:
            - Sightseeing: allocate more to Sightseeing
            - Culture & Art: allocate more to Sightseeing and Entertainment
            - Adventure: increase Transportation (car/bike rental), add more to Misc
            - Business: increase Accommodation (business hotels), add BusinessDinners and BankingInsurance
            - Visit Friends: reduce Accommodation if staying with friends, add Beauty and Shopping for gifts
            - Leisure: balance evenly, slight bump in Entertainment and Food
            - Shopping: allocate meaningfully to Shopping

            Transportation covers LOCAL transport only (metro, taxi, bus within the city). International flights are assumed already paid.

            Smart budget rules:
            - Tight budget for expensive destination: prioritize Accommodation + Food, cut optional categories
            - Generous budget: spread more to experience categories
            - Misc: minimum ₾50 always
            - Every amount must be a whole positive integer
            - All amounts must sum to EXACTLY \(Int(totalBudget)) — this is critical

            The categories to use are EXACTLY these valid backend names — do not use any other names, do not add or remove any:
            \(categoryList)

            Return ONLY the JSON array with calculated amounts. No explanation, no markdown, no backticks, nothing else.
            """

            let response = try await model.generateContent(prompt)
            guard let text = response.text else {
                throw AIBudgetError.emptyResponse
            }

            return try parseCategories(from: text)
        } catch {
            let fallback = AlgorithmBudgetRepository()
            return try await fallback.generateBudget(
                destination: destination,
                days: days,
                totalBudget: totalBudget,
                purposes: purposes
            )
        }
    }

    func generateInsight(trip: TripBudget) async throws -> String {
        let categories = trip.categories.map { "\($0.name): ₾\(Int($0.budgetAmount))" }.joined(separator: ", ")
        let prompt = """
        You are a witty, concise travel budget advisor.
        Write ONE short insight (max 2 sentences) for this trip. Be specific, practical, and smart.

        Trip: \(trip.destination), \(trip.daysCount) days, ₾\(Int(trip.budget)) total budget
        Categories: \(categories)
        Status: \(trip.status == .ongoing ? "ongoing" : trip.status == .future ? "planned" : "completed")

        Examples of good insights:
        - "Paris on ₾4000 for 5 days is tight — skip taxis, use metro Pass Navigo and eat lunch at brasseries instead of dinner."
        - "Georgia in 28 days gives you ₾625/day — enough for comfort. Tbilisi to Batumi by train saves ₾200 vs taxi."
        - "Japan in 7 days: your food budget looks low. Street food and convenience stores cut costs by 40% vs restaurants."

        Return ONLY the insight text. No emoji at start, no labels, no quotes, nothing else.
        """

        let response = try await model.generateContent(prompt)
        guard let text = response.text else { throw AIBudgetError.emptyResponse }
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func analyzeProgress(
        destination: String,
        totalBudget: Double,
        totalSpent: Double,
        daysElapsed: Int,
        daysRemaining: Int,
        categories: [TripCategory]
    ) async throws -> String {
        let categoryBreakdown = categories.map {
            "\($0.name): spent ₾\(Int($0.spentAmount)) of ₾\(Int($0.budgetAmount))"
        }.joined(separator: ", ")

        let dailyRate = daysElapsed > 0 ? totalSpent / Double(daysElapsed) : 0
        let projectedTotal = totalSpent + dailyRate * Double(daysRemaining)

        let prompt = """
        You are a travel budget advisor. Analyze this trip's spending and give 2-3 sentences of specific advice.

        Trip: \(destination)
        Budget: ₾\(Int(totalBudget)), Spent so far: ₾\(Int(totalSpent))
        Days elapsed: \(daysElapsed), Days remaining: \(daysRemaining)
        Daily spend rate: ₾\(Int(dailyRate))/day
        Projected total: ₾\(Int(projectedTotal))
        Category breakdown: \(categoryBreakdown)

        Be specific about which categories are over/under and give actionable advice.
        Return ONLY the analysis text. No labels, no quotes, nothing else.
        """

        let response = try await model.generateContent(prompt)
        guard let text = response.text else { throw AIBudgetError.emptyResponse }
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func buildCategoryList(purposes: [String]) -> String {
        var categories: [(String, String)] = [
            ("Accommodation", "bed.double"),
            ("Food", "fork.knife"),
            ("Transportation", "tram.fill")
        ]

        if purposes.contains("Sightseeing") || purposes.contains("Culture & Art") {
            categories.append(("Sightseeing", "binoculars.fill"))
        }
        if purposes.contains("Leisure") || purposes.isEmpty {
            categories.append(("Entertainment", "gamecontroller.fill"))
        }
        if purposes.contains("Shopping") {
            categories.append(("Shopping", "bag.fill"))
        }
        if purposes.contains("Business") {
            categories.append(("BusinessDinners", "briefcase.fill"))
            categories.append(("BankingInsurance", "banknote.fill"))
        }
        if purposes.contains("Adventure") || purposes.contains("Visit Friends") {
            categories.append(("Beauty", "sparkles"))
        }

        categories.append(("Misc", "square.grid.2x2.fill"))

        let lines = categories.map { name, icon in
            "  {\"name\": \"\(name)\", \"icon\": \"\(icon)\", \"budgetAmount\": <calculated>}"
        }.joined(separator: ",\n")

        return "[\n\(lines)\n]"
    }

    private func parseCategories(from text: String) throws -> [TripCategory] {
        let cleaned = text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")

        guard let data = cleaned.data(using: .utf8) else {
            throw AIBudgetError.parseError
        }

        let decoded = try JSONDecoder().decode([AICategory].self, from: data)
        return decoded.map {
            TripCategory(
                name: $0.name,
                icon: $0.icon,
                color: colorFor($0.name),
                budgetAmount: $0.budgetAmount,
                spentAmount: 0
            )
        }
    }

    private func colorFor(_ name: String) -> Color {
        switch name {
        case "Accommodation":    return Color(red: 0.6, green: 0.5, blue: 0.9)
        case "Food":             return Color(red: 0.8, green: 0.7, blue: 0.3)
        case "Transportation":   return Color(red: 0.3, green: 0.7, blue: 0.8)
        case "Sightseeing":      return Color(red: 0.9, green: 0.6, blue: 0.4)
        case "Shopping":         return Color(red: 0.5, green: 0.8, blue: 0.6)
        case "Entertainment":    return Color(red: 0.7, green: 0.4, blue: 0.9)
        case "BusinessDinners":  return Color(red: 0.5, green: 0.6, blue: 0.8)
        case "BankingInsurance": return Color(red: 0.4, green: 0.7, blue: 0.5)
        case "Beauty":           return Color(red: 0.9, green: 0.5, blue: 0.7)
        case "Misc":             return Color(red: 0.5, green: 0.5, blue: 0.5)
        default:                 return Color(red: 0.5, green: 0.5, blue: 0.5)
        }
    }
}

private struct AICategory: Decodable {
    let name: String
    let icon: String
    let budgetAmount: Double
}

enum AIBudgetError: Error {
    case emptyResponse
    case parseError
}
