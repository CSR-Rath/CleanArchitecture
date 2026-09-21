//
//  ProfileViewModel.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import Foundation
import Combine

@MainActor
public final class ProfileViewModel: ObservableObject {
    @Published public private(set) var user: User?
    @Published public private(set) var isLoading: Bool = false
    @Published public private(set) var errorMessage: String?

    private let getUserProfileUseCase: GetUserProfileUseCaseProtocol

    public init(getUserProfileUseCase: GetUserProfileUseCaseProtocol) {
        self.getUserProfileUseCase = getUserProfileUseCase
    }

    public func loadProfile(userId: Int = 1) async {
        isLoading = true
        errorMessage = nil
        do {
            user = try await getUserProfileUseCase.execute(userId: userId)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
