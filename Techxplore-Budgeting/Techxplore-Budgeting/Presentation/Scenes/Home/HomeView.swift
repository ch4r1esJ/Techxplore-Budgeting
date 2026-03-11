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
                BackgroundColor(color: Color(red: 0.137, green: 0.157, blue: 0.169))
                
                VStack(spacing: 40) {
                    CustomPicker(selection: $selectedFilter)
                        .padding(.horizontal, 20)
                }
            }
        }
}

#Preview {
    Homeview()
}

