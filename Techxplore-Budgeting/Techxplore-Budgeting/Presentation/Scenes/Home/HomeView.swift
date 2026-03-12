//
//  HomeView.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI

enum TimeCategories: String, CaseIterable {
    case future = "Future"
    case current = "Ongoing"
    case past = "Past"
}

struct Homeview: View {
    @State private var selectedFilter: TimeCategories = .current
    
    var body: some View {
        ZStack {
            Color.appBackgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                HeaderView(icon: "✈️", title: "Travel Budget")
                CustomPicker(selection: $selectedFilter)
                    .padding(.horizontal, 20)
                BudgetChart()
                    .padding(.top, 5)
             
                Spacer()
            }
        }
    }
}

#Preview {
    Homeview()
}

