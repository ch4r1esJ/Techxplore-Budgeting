//
//  TripCardProgressSection.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI

struct TripCardProgressSection: View {
    var formattedSpent: String
    var progressPercent: String
    var isOverBudget: Bool
    var progress: Double
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("\(formattedSpent) Spent")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
                
                Spacer()
                
                Text(progressPercent)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(isOverBudget ? .red : .green)
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 6)
                    
                    Capsule()
                        .fill(isOverBudget ? Color.red : Color.green)
                        .frame(width: geo.size.width * min(progress, 1.0), height: 10)
                        .animation(.easeInOut(duration: 0.5), value: progress)
                }
            }
            .frame(height: 6)
        }
    }
}
