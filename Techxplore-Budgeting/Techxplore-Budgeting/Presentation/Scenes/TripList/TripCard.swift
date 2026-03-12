//
//  TripCard.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI

struct TripBudgetCard: View {
    @StateObject var viewModel = TripBudgetViewModel()
    
    init(trip: TripBudget) {
        _viewModel = StateObject(wrappedValue: TripBudgetViewModel(trip: trip))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TripCardHeaderSection(
                flag: viewModel.trip.flag,
                destination: viewModel.trip.destination,
                dataRange: viewModel.dateRange,
                daysCount: viewModel.trip.daysCount,
                status: viewModel.trip.status,
                formattedBudget: viewModel.formattedBudget
            )
            
            TripCardProgressSection(
                formattedSpent: viewModel.formattedSpent,
                progressPercent: viewModel.progressPercent,
                isOverBudget: viewModel.isOverBudget,
                progress: viewModel.trip.progress
            )
        }
        .padding(20)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.07), lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }
}
