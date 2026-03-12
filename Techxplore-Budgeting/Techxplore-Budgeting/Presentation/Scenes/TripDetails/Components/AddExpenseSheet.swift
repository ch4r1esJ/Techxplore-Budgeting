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

    @State private var selectedIndex: Int = 0
    @State private var amount: String = ""

    var selectedCategory: TripCategory {
        viewModel.categories[selectedIndex]
    }

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

                Picker("", selection: $selectedIndex) {
                    ForEach(viewModel.categories.indices, id: \.self) { index in
                        Text("\(viewModel.categories[index].icon) \(viewModel.categories[index].name)")
                            .tag(index)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.white.opacity(0.07))
                .clipShape(RoundedRectangle(cornerRadius: 12))
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
                guard let amountValue = Double(amount) else { return }
                viewModel.addExpense(categoryName: selectedCategory.name, amount: amountValue, note: "")
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
    }
}
