//
//  StatusBadge.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI

struct StatusBadge: View {
    let status: TripStatus
    
    var body: some View {
        HStack(spacing: 5) {
            
            Text(label)
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundStyle(textColor)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(backgroundColor)
        .clipShape(Capsule())
    }
    
    var label: String {
        switch status {
        case .ongoing:   return "Ongoing"
        case .future:   return "Future"
        case .completed: return "Past"
        }
    }
    
    var textColor: Color {
        switch status {
        case .ongoing:   return Color.activePill
        case .future:   return Color(red: 0.5, green: 0.4, blue: 0.9)
        case .completed: return .gray
        }
    }
    
    var backgroundColor: Color {
        switch status {
        case .ongoing:   return Color.activePill.opacity(0.15)
        case .future:   return Color(red: 0.102, green: 0.063, blue: 0.255).opacity(0.15)
        case .completed: return Color.white.opacity(0.08)
        }
    }
}
