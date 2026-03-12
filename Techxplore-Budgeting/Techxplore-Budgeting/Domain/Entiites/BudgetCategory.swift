//
//  BudgetCategory.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI

struct BudgetCategory: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    let icon: String
    let color: Color
}
