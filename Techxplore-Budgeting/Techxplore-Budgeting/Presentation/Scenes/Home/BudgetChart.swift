//
//  BudgetChart.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI
import Charts

struct BudgetChart: View {
    let budgetData: [BudgetCategory] = [
        BudgetCategory(name: "Accommodation", amount: 13200, icon: "🏨", color: Color(red: 0.6, green: 0.5, blue: 0.9)),
        BudgetCategory(name: "Food", amount: 8250, icon: "🍽️", color: Color(red: 0.8, green: 0.7, blue: 0.3)),
        BudgetCategory(name: "Transport", amount: 4950, icon: "✈️", color: Color(red: 0.3, green: 0.7, blue: 0.8)),
        BudgetCategory(name: "Sightseeing", amount: 3300, icon: "🏛️", color: Color(red: 0.9, green: 0.6, blue: 0.4)),
        BudgetCategory(name: "Shopping", amount: 3300, icon: "🛍️", color: Color(red: 0.5, green: 0.8, blue: 0.6))
    ]
    
    var totalBudget: Double {
        budgetData.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        Chart(budgetData) { category in
            SectorMark(
                angle: .value("Amount", category.amount),
                innerRadius: .ratio(0.7),
                angularInset: 3.0
            )
            .foregroundStyle(by: .value("Category", category.name))
            .cornerRadius(4)
            .annotation(position: .overlay) {
                Text(category.icon)
                    .font(.system(size: 10))
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
            }
        }
        .chartForegroundStyleScale(
            domain: budgetData.map { $0.name },
            range: budgetData.map { $0.color }
        )
        .chartBackground { chartProxy in
            GeometryReader { geometry in
                if let anchor = chartProxy.plotFrame {
                    let frame = geometry[anchor]
                    
                    VStack(spacing: 4) {
                        Text("₾\(Int(totalBudget).formatted(.number.grouping(.automatic)))")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Budget")
                            .font(.system(size: 13))
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.7))
                    }
                    .position(x: frame.midX, y: frame.midY)
                }
            }
        }
        .chartLegend(position: .bottom, alignment: .center, spacing: 20)
        .foregroundStyle(.white)
        .font(.system(size: 16, weight: .medium))
        .frame(height: 250)
        .padding(24)
        .background(Color(red: 0.165, green: 0.184, blue: 0.192))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
        .padding(.horizontal, 20)
        .environment(\.colorScheme, .dark)
    }
}

#Preview {
    BudgetChart()
}
