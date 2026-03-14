//
//  ExpenseRow.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI

struct ExpenseRow: View {
    let expense: Expense
    let categories: [TripCategory]

    var category: TripCategory? {
        categories.first { $0.name == expense.categoryName }
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: expense.date)
    }

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill((category?.color ?? .gray).opacity(0.25))
                    .frame(width: 48, height: 48)
                Image(systemName: category?.icon ?? "dollarsign.circle")
                    .font(.system(size: 22))
                    .foregroundStyle(category?.color ?? .gray)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(expense.categoryName)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                Text(formattedDate)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }

            Spacer()

            Text("₾\(Int(expense.amount))")
                .font(.body)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
        }
        .padding(14)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
