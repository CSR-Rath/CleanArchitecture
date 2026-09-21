//
//  ProfileDIContainer.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import SwiftUI

public final class ProfileDIContainer {
    private let networkClient: NetworkClientProtocol

    public init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    // option 1
    public func makeProfileVM() -> ProfileViewModel {
        let remoteDataSource = UserRemoteDataSource(networkClient: networkClient)
        let localDataSource = UserLocalDataSource()
        let repository = UserRepositoryImpl(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource
        )
        let useCase = GetUserProfileUseCase(repository: repository)
        let viewModel = ProfileViewModel(getUserProfileUseCase: useCase)
        return  viewModel
    }

    // option 2
    public func makeProfileView() -> ProfileScreen {
        let remoteDataSource = UserRemoteDataSource(networkClient: networkClient)
        let localDataSource = UserLocalDataSource()
        let repository = UserRepositoryImpl(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource
        )
        let useCase = GetUserProfileUseCase(repository: repository)
        let viewModel = ProfileViewModel(getUserProfileUseCase: useCase)
        return ProfileScreen(viewModel: viewModel)
    }
}
