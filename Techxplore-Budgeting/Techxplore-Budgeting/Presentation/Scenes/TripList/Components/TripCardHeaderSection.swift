//
//  TripCardHeaderSection.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI

struct TripCardHeaderSection: View {
    var flag: String
    var destination: String
    var dataRange: String
    var daysCount: Int
    var status: TripStatus
    var formattedBudget: String

    var body: some View {
        HStack(alignment: .top) {
            HStack(alignment: .top, spacing: 10) {
                Text(flag)
                    .font(.system(size: 28))

                VStack(alignment: .leading, spacing: 4) {
                    Text(destination)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)

                    Text(dataRange)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.85))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)

                    Text("\(daysCount) Days")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }

            Spacer(minLength: 12)

            VStack(alignment: .trailing, spacing: 6) {
                StatusBadge(status: status)

                Text(formattedBudget)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .fixedSize(horizontal: true, vertical: false)
        }
    }
}
