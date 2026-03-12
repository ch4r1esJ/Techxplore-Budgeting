//
//  HeaderView.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI

struct HeaderView: View {
    var icon: String
    var title: String
    
    var body: some View {
        HStack(spacing: 12) {
            Text(icon)
                .font(.system(size: 24))
            
            Text(title)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color(red: 0.18, green: 0.18, blue: 0.22)),
            alignment: .bottom
        )
    }
}
