//
//  HomeView.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI

struct Homeview: View {
    @StateObject var viewModel: HomeViewModel
    @State private var selectedTrip: TripBudget? = nil
    let container: AppDIContainer

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Color.appBackgroundColor.ignoresSafeArea()

                VStack(spacing: 10) {
                    HeaderView(icon: "✈️", title: "Travel Budget")
                    CustomPicker(selection: $viewModel.selectedFilter)
                        .padding(.horizontal, 20)
                    BudgetChart(data: viewModel.budgetData, total: viewModel.totalBudget)
                        .padding(.top, 5)

                    List {
                        ForEach(viewModel.filteredTrips) { trip in
                            TripBudgetCard(trip: trip)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                                .onTapGesture { selectedTrip = trip }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        viewModel.deleteTrip(trip)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .navigationDestination(item: $selectedTrip) { trip in
                        TripDetailView(viewModel: container.makeTripDetailViewModel(trip: trip))
                    }
                }

                if viewModel.showSuccessToast {
                    VStack {
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                            Text("Trip added successfully!")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.customContainer)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .shadow(color: .black.opacity(0.3), radius: 10)
                        .padding(.top, 60)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation {
                                viewModel.showSuccessToast = false
                            }
                        }
                    }
                }

                AddButton { viewModel.isShowingAddTrip = true }
                    .padding(.trailing, 20)
                    .padding(.bottom, 30)
                    .sheet(isPresented: $viewModel.isShowingAddTrip, onDismiss: { viewModel.resetForm() }) {
                        AddTrip(viewModel: viewModel)
                            .presentationDetents([.fraction(0.85), .large])
                            .presentationDragIndicator(.visible)
                            .presentationBackground(Color.customContainer)
                    }
            }
        }
    }
}
