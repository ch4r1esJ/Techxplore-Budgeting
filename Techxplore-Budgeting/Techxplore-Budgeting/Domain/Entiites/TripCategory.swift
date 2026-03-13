//
//  TripCategory.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI

struct TripCategory: Identifiable, Equatable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    var budgetAmount: Double
    var spentAmount: Double
}
