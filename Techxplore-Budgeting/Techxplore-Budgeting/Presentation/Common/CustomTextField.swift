//
//  CustomTextField.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI

struct CustomTextField: View {
    let icon: String
    let title: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Text(icon)
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white)
            }
            
            TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(Color.gray))
                .padding(16)
                .background(Color(red: 0.18, green: 0.18, blue: 0.22))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .foregroundStyle(.white)
                .keyboardType(keyboardType)
        }
    }
}
