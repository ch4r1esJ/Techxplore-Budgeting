//
//  BackgroundColor.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI

struct BackgroundColor: View {
    var color: Color?
    var body: some View {
        color
            .ignoresSafeArea()
    }
}
