//
//  Expense.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/13/26.
//

import Foundation

struct Expense: Identifiable {
    let id = UUID()
    let categoryName: String
    let amount: Double
    let date: Date
    var note: String
}
