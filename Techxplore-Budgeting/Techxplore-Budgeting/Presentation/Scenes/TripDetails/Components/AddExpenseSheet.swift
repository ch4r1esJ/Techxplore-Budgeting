//
//  AddExpenseSheet.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI

struct AddExpenseSheet: View {
    @ObservedObject var viewModel: TripDetailViewModel
    @Environment(\.dismiss) var dismiss

    @State private var selectedCategory: TripCategory?
    @State private var amount: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Add expense")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .center)

            VStack(alignment: .leading, spacing: 8) {
                Text("Category")
                    .font(.caption)
                    .foregroundStyle(.gray)

                Menu {
                    ForEach(viewModel.categories) { category in
                        Button {
                            selectedCategory = category
                        } label: {
                            Text("\(category.icon) \(category.name)")
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedCategory.map { "\($0.icon) \($0.name)" } ?? "Choose category")
                            .foregroundStyle(.white)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.gray)
                    }
                    .padding()
                    .background(Color.white.opacity(0.07))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Amount (₾)")
                    .font(.caption)
                    .foregroundStyle(.gray)

                TextField("0", text: $amount)
                    .keyboardType(.decimalPad)
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.white.opacity(0.07))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Button {
                guard let category = selectedCategory,
                      let amountValue = Double(amount) else { return }
                viewModel.addExpense(categoryName: category.name, amount: amountValue, note: "")
                dismiss()
            } label: {
                Text("Save expense")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.activePill)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.top, 8)
        }
        .padding(20)
        .onAppear {
            selectedCategory = viewModel.categories.first
        }
    }
}
