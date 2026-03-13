//
//  PurposeSelectionView.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI

struct PurposeSelectionView: View {
    let purposes: [String]
    @Binding var selectedPurposes: Set<String>
    var onTap: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            purposeHeader
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 130), spacing: 10)], alignment: .leading, spacing: 12) {
                ForEach(purposes, id: \.self) { purpose in
                    purposePill(purpose)
                }
            }
        }
    }
    
    private var purposeHeader: some View {
        HStack(spacing: 6) {
            Text("🎯")
            Text("Purpose (Optional)")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white)
        }
    }
    
    private func purposePill(_ purpose: String) -> some View {
        let isSelected = selectedPurposes.contains(purpose)
        
        return Text(purpose)
            .font(.system(size: 14, weight: .medium))
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? Color.purposeActivePill : Color(red: 0.18, green: 0.18, blue: 0.22))
            .foregroundStyle(isSelected ? .white : .gray)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .onTapGesture {
                onTap(purpose)
            }
    }
}
