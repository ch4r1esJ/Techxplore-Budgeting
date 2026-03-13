//
//  AddTrip.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI

struct AddTrip: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {

                CenteredHeaderView(
                    title: "New Trip",
                    subtitle: "AI will create a personalized budget plan"
                )

                CountrySearchField(selectedCountry: $viewModel.country)

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

                if let error = viewModel.generationError {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .center)
                }

                GenerateBudgetButton {
                    viewModel.generateBudgetPlan()
                }
                .disabled(viewModel.isGenerating)
                .overlay(
                    Group {
                        if viewModel.isGenerating {
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.black.opacity(0.4))
                            ProgressView()
                                .tint(.white)
                        }
                    }
                )
            }
            .padding(20)
        }
        .background(Color.sheetColor.ignoresSafeArea())
    }
}

#Preview {
    let container = AppDIContainer()
    AddTrip(viewModel: container.makeHomeViewModel())
}
