//
//  GenerateBudgetButton.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI

struct GenerateBudgetButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "plus")
                Text("Generate Budget Plan")
            }
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.activePill)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }
}
