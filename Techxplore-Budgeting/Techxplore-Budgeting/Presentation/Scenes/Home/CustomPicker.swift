//
//  CustomPicker.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI

struct CustomPicker: View {
    @Binding var selection: TimeCategories
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TimeCategories.allCases, id: \.self) { filter in
                Text(filter.rawValue)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(selection == filter ? .white : Color.inactiveText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background {
                        if selection == filter {
                            Capsule()
                                .fill(Color.activePill)
                                .overlay(
                                    Capsule().stroke(Color.white, lineWidth: 1.5)
                                )
                                .matchedGeometryEffect(id: "activeTab", in: animation)
                        }
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                            selection = filter
                        }
                    }
            }
        }
        .padding(4)
        .background(Color.customContainer)
        .clipShape(Capsule())
    }
}
