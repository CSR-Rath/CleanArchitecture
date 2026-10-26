//
//  ProfileDIContainer.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import SwiftUI

final class ProfileDIContainer {
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    // option 1
    func makeProfileVM() -> ProfileViewModel {
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
    func makeProfileView() -> ProfileScreen {
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
