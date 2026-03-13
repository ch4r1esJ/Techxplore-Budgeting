//
//  StatCard.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let valueColor: Color

    var body: some View {
        VStack(alignment: .center, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .center)

            Text(value)
                .font(.callout)
                .fontWeight(.bold)
                .foregroundStyle(valueColor)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(Color.white.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
