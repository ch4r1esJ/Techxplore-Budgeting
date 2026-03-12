//
//  AddTrip.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI

struct AddTrip: View {
    @ObservedObject var viewModel: HomeViewModel
        
    let purposes = ["Sightseeing", "Visit Friends", "Business", "Leisure", "Adventure", "Culture & Art"]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                
                CenteredHeaderView(
                    title: "New Trip",
                    subtitle: "AI will create a personalized budget plan"
                )
                
                CustomTextField(
                    icon: "🌍",
                    title: "Country",
                    placeholder: "Search country...",
                    text: $viewModel.country
                )
                
                DateRangePickerView(
                    startDate: $viewModel.startDate,
                    endDate: $viewModel.endDate
                )
                
                CustomTextField(
                    icon: "💰",
                    title: "Budget (₾)",
                    placeholder: "e.g. 3000",
                    text: $viewModel.budget,
                    keyboardType: .decimalPad
                )
                
                PurposeSelectionView(
                    purposes: viewModel.availablePurposes,
                    selectedPurposes: $viewModel.selectedPurposes,
                    onTap: { purpose in
                        viewModel.togglePurpose(purpose)
                    }
                )
                
                GenerateBudgetButton {
                    print("Tap")
                }
            }
            .padding(20)
        }
        .background(Color.sheetColor.ignoresSafeArea())
    }
}

#Preview  {
    AddTrip(viewModel: HomeViewModel())
}
