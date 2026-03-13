//
//  AppDIContainer.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/13/26.
//


import Foundation

final class AppDIContainer {

    lazy var tripRepository: TripRepositoryProtocol = MockTripRepository()

    lazy var fetchTripsUseCase = FetchTripsUseCase(repository: tripRepository)
    lazy var addExpenseUseCase = AddExpenseUseCase()
    lazy var updateBudgetUseCase = UpdateBudgetUseCase()
    
    lazy var aiBudgetRepository: AIBudgetRepositoryProtocol = FirebaseAIBudgetRepository()
    lazy var generateBudgetUseCase = GenerateBudgetUseCase(repository: aiBudgetRepository)
    
    lazy var notificationService: NotificationServiceProtocol = LocalNotificationService()

    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(
            fetchTripsUseCase: fetchTripsUseCase,
            generateBudgetUseCase: generateBudgetUseCase
        )
    }

    func makeTripDetailViewModel(trip: TripBudget) -> TripDetailViewModel {
        TripDetailViewModel(
            trip: trip,
            addExpenseUseCase: addExpenseUseCase,
            updateBudgetUseCase: updateBudgetUseCase,
            notificationService: notificationService
        )
    }
}
