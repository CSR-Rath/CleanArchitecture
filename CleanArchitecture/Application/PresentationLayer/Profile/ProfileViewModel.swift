//
//  ProfileViewModel.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import Foundation
import Combine

@MainActor
final class ProfileViewModel:  ObservableObject {
    
    @Published var state: UIState = .idle
    @Published private(set) var user: User?
    
    
    private let getUserProfileUseCase: GetUserProfileUseCaseProtocol

    init(getUserProfileUseCase: GetUserProfileUseCaseProtocol) {
        self.getUserProfileUseCase = getUserProfileUseCase
    }

    func loadProfile(userId: Int = 1) async {
     
        state = .loading
        do {
            user = try await getUserProfileUseCase.execute(userId: userId)
            state = .idle
        } catch {
//            state = .failed(error.localizedDescription)
        }
    }
}
