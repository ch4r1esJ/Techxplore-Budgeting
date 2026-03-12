//
//  TripDetailChart.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI
import Charts

struct TripDetailChart: View {
    let categories: [TripCategory]
    let status: TripStatus

    @State private var isAnimated = false

    var totalBudget: Double { categories.reduce(0) { $0 + $1.budgetAmount } }
    var totalSpent: Double  { categories.reduce(0) { $0 + $1.spentAmount  } }

    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 8) {
                donutChart(
                    values: categories.map { ($0.name, $0.icon, $0.budgetAmount, $0.color) },
                    centerAmount: totalBudget
                )
                Text("Plan")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity)

            if status != .future {
                Divider()
                    .background(Color.white.opacity(0.1))
                    .frame(height: 160)

                VStack(spacing: 8) {
                    if totalSpent == 0 {
                        emptyDonut
                    } else {
                        donutChart(
                            values: categories.filter { $0.spentAmount > 0 }
                                .map { ($0.name, $0.icon, $0.spentAmount, $0.color) },
                            centerAmount: totalSpent
                        )
                    }
                    Text("Reality")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onAppear {
            withAnimation(.easeOut(duration: 0.7)) {
                isAnimated = true
            }
        }
    }

    private func donutChart(values: [(String, String, Double, Color)], centerAmount: Double) -> some View {
        let chartData = values.map { (name: $0.0, icon: $0.1, amount: $0.2, color: $0.3) }

        return Chart(chartData, id: \.name) { item in
            SectorMark(
                angle: .value("Amount", isAnimated ? item.amount : 0),
                innerRadius: .ratio(0.65),
                angularInset: 2.5
            )
            .foregroundStyle(item.color)
            .cornerRadius(4)
            .annotation(position: .overlay) {
                let percentage = item.amount / values.reduce(0) { $0 + $1.2 }
                if percentage > 0.1 {
                    Text(item.icon)
                        .font(.system(size: 9))
                        .opacity(isAnimated ? 1 : 0)
                }
            }
        }
        .chartBackground { proxy in
            GeometryReader { geo in
                if let anchor = proxy.plotFrame {
                    let frame = geo[anchor]
                    Text("₾\(Int(centerAmount).formatted(.number))")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.white)
                        .position(x: frame.midX, y: frame.midY)
                }
            }
        }
        .chartLegend(.hidden)
        .frame(width: 130, height: 130)
    }

    private var emptyDonut: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.1), lineWidth: 18)
                .frame(width: 100, height: 100)
            VStack(spacing: 2) {
                Text("–")
                    .font(.headline)
                    .foregroundStyle(.gray)
                Text("No data")
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }
        }
        .frame(width: 130, height: 130)
    }
}
