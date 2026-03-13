//
//  DatePicker.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI

struct DateRangePickerView: View {
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            DateHeader(
                emoji: "📅",
                title: "Dates"
            )
            
            HStack(spacing: 12) {
                DatePicker("", selection: $startDate, displayedComponents: .date)
                    .labelsHidden()
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.18, green: 0.18, blue: 0.22))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .colorScheme(.dark)
                
                DatePicker("", selection: $endDate, displayedComponents: .date)
                    .labelsHidden()
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.18, green: 0.18, blue: 0.22))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .colorScheme(.dark)
            }
        }
    }
}

struct DateHeader: View {
    var emoji: String
    var title: String
    var body: some View {
        HStack(spacing: 6) {
            Text(emoji)
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white)
        }
    }
}
