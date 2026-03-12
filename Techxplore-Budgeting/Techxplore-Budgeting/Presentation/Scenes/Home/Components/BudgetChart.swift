//
//  BudgetChart.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI
import Charts

struct BudgetChart: View {
    let data: [BudgetCategory]
    let total: Double
    
    @State private var isAnimated: Bool = false
    
    var body: some View {
        Chart(data) { category in
            SectorMark(
                angle: .value("Amount", isAnimated ? category.amount : 0),
                innerRadius: .ratio(0.75),
                angularInset: 2.0
            )
            .foregroundStyle(by: .value("Category", category.name))
            .cornerRadius(4)
            .annotation(position: .overlay) {
                Text(category.icon)
                    .font(.system(size: 10))
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    .opacity(isAnimated ? 1 : 0)
            }
        }
        .chartForegroundStyleScale(
            domain: data.map { $0.name },
            range: data.map { $0.color }
        )
        .chartBackground { chartProxy in
            GeometryReader { geometry in
                if let anchor = chartProxy.plotFrame {
                    let frame = geometry[anchor]
                    
                    VStack(spacing: 4) {
                        Text("₾\(Int(total).formatted(.number.grouping(.automatic)))")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundStyle(.white)
                        
                        Text("Budget")
                            .font(.system(size: 13))
                            .foregroundStyle(Color(red: 0.6, green: 0.6, blue: 0.7))
                    }
                    .position(x: frame.midX, y: frame.midY)
                }
            }
        }
        .chartLegend(position: .bottom, alignment: .center, spacing: 20)
        .frame(height: 250)
        .padding(24)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
        .padding(.horizontal, 20)
        .onAppear {
            withAnimation(.easeOut(duration: 0.7)) {
                isAnimated = true
            }
        }
    }
}
