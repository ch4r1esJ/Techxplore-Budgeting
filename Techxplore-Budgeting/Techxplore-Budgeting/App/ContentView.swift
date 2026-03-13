//
//  ContentView.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI

struct ContentView: View {
    let container = AppDIContainer()

    var body: some View {
        Homeview(
            viewModel: container.makeHomeViewModel(),
            container: container
        )
    }
}

#Preview {
    ContentView()
}
