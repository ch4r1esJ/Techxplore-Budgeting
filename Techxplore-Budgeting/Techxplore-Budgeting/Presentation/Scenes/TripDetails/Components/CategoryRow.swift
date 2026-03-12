//
//  CategoryRow.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI

struct CategoryRow: View {
    let category: TripCategory
    let isEditable: Bool
    var onBudgetChanged: ((Double) -> Void)?

    @State private var isEditing = false
    @State private var editText = ""

    var progress: Double {
        guard category.budgetAmount > 0 else { return 0 }
        return min(category.spentAmount / category.budgetAmount, 1.0)
    }

    var isOverBudget: Bool {
        category.spentAmount > category.budgetAmount
    }

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(category.color.opacity(0.25))
                        .frame(width: 48, height: 48)
                    Text(category.icon)
                        .font(.system(size: 22))
                }

                if !isEditing {
                    Text(category.name)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                }

                Spacer()

                if isEditing {
                    Text("₾\(Int(category.spentAmount)) /")
                        .font(.caption)
                        .foregroundStyle(isOverBudget ? .red : .gray)
                        .lineLimit(1)

                    TextField("0", text: $editText)
                        .keyboardType(.decimalPad)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .frame(width: 80)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.activePill, lineWidth: 1.5)
                        )

                    Button {
                        if let value = Double(editText) {
                            onBudgetChanged?(value)
                        }
                        isEditing = false
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.subheadline.bold())
                            .foregroundStyle(.black)
                            .frame(width: 36, height: 36)
                            .background(Color.activePill)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                } else {
                    Text("₾\(Int(category.spentAmount)) / ₾\(Int(category.budgetAmount))")
                        .font(.caption)
                        .foregroundStyle(isOverBudget ? .red : .gray)
                        .lineLimit(1)

                    if isEditable {
                        Button {
                            editText = "\(Int(category.budgetAmount))"
                            isEditing = true
                        } label: {
                            Image(systemName: "pencil")
                                .font(.caption)
                                .foregroundStyle(.orange)
                        }
                    }
                }
            }

            ProgressView(value: progress)
                .tint(isOverBudget ? .red : category.color)
                .background(Color.white.opacity(0.1))
                .clipShape(Capsule())
        }
        .padding(14)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isEditing ? Color.activePill.opacity(0.5) : Color.clear, lineWidth: 1.5)
        )
        .animation(.easeInOut(duration: 0.2), value: isEditing)
    }
}
