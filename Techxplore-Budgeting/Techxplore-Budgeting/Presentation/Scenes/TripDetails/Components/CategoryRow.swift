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
        return category.spentAmount / category.budgetAmount
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
                    
                    Image(systemName: category.icon)
                        .font(.system(size: 18))
                        .foregroundStyle(category.color)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text(category.name)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .lineLimit(1)

                    Text("₾\(Int(category.spentAmount)) Spent")
                        .font(.caption)
                        .foregroundStyle(.gray)
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
                    VStack(alignment: .trailing, spacing: 15) {
                        HStack(spacing: 4) {
                            Text("₾\(Int(category.spentAmount)) / ₾\(Int(category.budgetAmount))")
                                .font(.caption)
                                .foregroundStyle(isOverBudget ? .red : .gray)
                                .lineLimit(1)

                            if isEditable {
                                Button {
                                    editText = "\(Int(category.budgetAmount))"
                                    isEditing = true
                                } label: {
                                    Image(systemName: "square.and.pencil")
                                        .font(.subheadline)
                                        .foregroundStyle(.blue)
                                }
                            }
                        }

                        Text("\(Int(progress * 100))%")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(isOverBudget ? .red : Color.activePill)
                    }
                }
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.1))
                    Capsule()
                        .fill(isOverBudget ? Color.red : category.color)
                        .frame(width: geo.size.width * min(progress, 1.0))
                }
            }
            .frame(height: 10)
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
