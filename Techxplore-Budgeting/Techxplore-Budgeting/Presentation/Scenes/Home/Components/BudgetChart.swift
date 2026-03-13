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
        VStack(spacing: 0) {
            Chart(data) { category in
                SectorMark(
                    angle: .value("Amount", isAnimated ? category.amount : 0),
                    innerRadius: .ratio(0.75),
                    angularInset: 2.0
                )
                .foregroundStyle(by: .value("Category", category.name))
                .cornerRadius(4)
                .annotation(position: .overlay) {
                    let dataTotal = data.reduce(0) { $0 + $1.amount }
                    let percentage = dataTotal > 0 ? category.amount / dataTotal : 0
                    if percentage > 0.04 {
                        Text(category.icon)
                            .font(.system(size: 10))
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                            .opacity(isAnimated ? 1 : 0)
                    }
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
            .chartLegend(.hidden)
            .frame(height: 220)
            .padding(.top, 24)
            .padding(.horizontal, 24)

            // Custom 2-column legend
            let columns = [
                GridItem(.flexible(), alignment: .leading),
                GridItem(.flexible(), alignment: .leading),
                GridItem(.flexible(), alignment: .leading)
            ]

            LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
                ForEach(data) { category in
                    HStack(spacing: 6) {
                        Circle()
                            .fill(category.color)
                            .frame(width: 7, height: 7)
                        Text(category.name)
                            .font(.system(size: 11, weight: .regular))
                            .foregroundStyle(Color(red: 0.65, green: 0.65, blue: 0.75))
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal, 20)
            .padding(.leading, 15)
            .padding(.vertical, 14)
        }
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
