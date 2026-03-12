//
//  Techxplore_BudgetingApp.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI

@main
struct TechxploreBudgetingApp: App {
    let container = AppDIContainer()

    var body: some Scene {
        WindowGroup {
            Homeview(
                viewModel: container.makeHomeViewModel(),
                container: container
            )
        }
    }
}
