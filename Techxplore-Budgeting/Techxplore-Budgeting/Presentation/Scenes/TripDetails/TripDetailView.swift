//
//  TripDetailView.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/12/26.
//

import SwiftUI

struct TripDetailView: View {
    @StateObject var viewModel: TripDetailViewModel
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.appBackgroundColor.ignoresSafeArea()

            VStack(spacing: 0) {
                headerSection
                    .padding(.horizontal, 20)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        statsSection
                        aiText
                        chartSection
                        categoriesSection
                        if !viewModel.expenses.isEmpty {
                            expenseJournalSection
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
            
            if viewModel.trip.status == .ongoing {
                Button {
                    viewModel.isShowingAddExpense = true
                } label: {
                    Text("+ Expense")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(Color.activePill)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: Color.blueShadow, radius: 8, x: 0, y: 4)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $viewModel.isShowingAddExpense) {
            AddExpenseSheet(viewModel: viewModel)
                .presentationDetents([.fraction(0.45)])
                .presentationDragIndicator(.visible)
                .presentationBackground(Color.customContainer)
        }
    }
    
    // Sections
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button {
                dismiss()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.left")
                    Text("Back")
                }
                .font(.subheadline)
                .foregroundStyle(Color.activePill)
            }

            HStack(spacing: 6) {
                Text(viewModel.trip.flag)
                    .font(.system(size: 44))
                    .padding(.top,-15)

                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.trip.destination)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)

                    Text("\(viewModel.dateRange) · \(viewModel.daysCount) days")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
            }
            Divider().background(Color.white.opacity(0.1))
                .padding(.horizontal, -20)
        }
        .padding(.top, 16)
    }
    
    private var statsSection: some View {
        HStack(spacing: 10) {
            StatCard(title: "Budget", value: "₾\(Int(viewModel.totalBudget).formatted())", valueColor: .white)
            StatCard(title: "Spent", value: "₾\(Int(viewModel.totalSpent).formatted())",  valueColor: viewModel.totalSpentColor)
            StatCard(title: "Status", value: viewModel.budgetStatusText, valueColor: viewModel.budgetStatusColor)
        }
    }


    private var aiText: some View {
        Text(viewModel.aiSuggestion)
            .font(.subheadline)
            .foregroundStyle(Color.activePill)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.activePill.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.activePill.opacity(0.3), lineWidth: 1)
            )
    }
    
    private var chartSection: some View {
        TripDetailChart(
            categories: viewModel.categories,
            status: viewModel.trip.status
        )
    }

    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Categories")
                .font(.subheadline)
                .foregroundStyle(.gray)

            ForEach(viewModel.categories) { category in
                CategoryRow(
                    category: category,
                    isEditable: viewModel.trip.status == .ongoing
                ) { newBudget in
                    viewModel.updateBudget(for: category.name, amount: newBudget)
                }
            }
        }
    }
    

    private var expenseJournalSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Expenses")
                .font(.subheadline)
                .foregroundStyle(.gray)

            ForEach(viewModel.expenses) { expense in
                ExpenseRow(expense: expense, categories: viewModel.categories)
            }
        }
    }
}
