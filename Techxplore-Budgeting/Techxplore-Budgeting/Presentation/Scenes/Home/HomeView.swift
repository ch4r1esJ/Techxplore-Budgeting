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
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Color.appBackgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 10) {
                    HeaderView(icon: "✈️", title: "Travel Budget")
                    CustomPicker(selection: $viewModel.selectedFilter)
                        .padding(.horizontal, 20)
                    BudgetChart(
                        data: viewModel.budgetData,
                        total: viewModel.totalBudget
                    )
                    .padding(.top, 5)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 10) {
                            ForEach(viewModel.trips) { trip in
                                NavigationLink(destination: TripDetailView(
                                    viewModel: TripDetailViewModel(trip: trip)
                                )) {
                                    TripBudgetCard(trip: trip)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.top, 5)
                        .padding(.bottom, 20)
                    }
                }
                
                AddButton {
                    viewModel.isShowingAddTrip = true
                }
                .padding(.trailing, 20)
                .padding(.bottom, 30)
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

