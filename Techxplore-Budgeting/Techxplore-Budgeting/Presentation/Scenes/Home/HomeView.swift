//
//  HomeView.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI

struct Homeview: View {
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            Color.appBackgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                HeaderView(icon: "✈️", title: "Travel Budget")
                CustomPicker(selection: $viewModel.selectedFilter)
//                    .padding(.horizontal, 20)
                BudgetChart(
                    data: viewModel.budgetData,
                    total: viewModel.totalBudget
                )
                    .padding(.top, 5)
                
                Spacer()
                AddButton {
                    viewModel.isShowingAddTrip = true
                }
                .sheet(isPresented: $viewModel.isShowingAddTrip, onDismiss: {
                    viewModel.resetForm()
                }) {
                    AddTrip(viewModel: viewModel)
                        .presentationDetents([.fraction(0.85), .large])
                        .presentationDragIndicator(.visible)
                        .presentationBackground(Color.customContainer)
                }
            }
        }
    }
}

#Preview {
    Homeview()
}

