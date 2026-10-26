//
//  HomeDIContainer.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import SwiftUI

final class HomeDIContainer {
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    
    func makeHomeUsace() -> HomeViewModel {
        let remoteDataSource = FeedRemoteDataSource(networkClient: networkClient)
        let localDataSource = FeedLocalDataSource()
        let repository = FeedRepositoryImpl(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource
        )
        let useCase = GetFeedUseCase(repository: repository)
        let viewModel = HomeViewModel(getFeedUseCase: useCase)
        return viewModel
    }
    
    // option 1
    func makeHomeVM() -> HomeViewModel {
        let remoteDataSource = FeedRemoteDataSource(networkClient: networkClient)
        let localDataSource = FeedLocalDataSource()
        let repository = FeedRepositoryImpl(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource
        )
        let useCase = GetFeedUseCase(repository: repository)
        let viewModel = HomeViewModel(getFeedUseCase: useCase)
        return viewModel
    }

    
    // option 2
    func makeHomeView() -> HomeScreen {
        let remoteDataSource = FeedRemoteDataSource(networkClient: networkClient)
        let localDataSource = FeedLocalDataSource()
        let repository = FeedRepositoryImpl(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource
        )
        let useCase = GetFeedUseCase(repository: repository)
        let viewModel = HomeViewModel(getFeedUseCase: useCase)
        return HomeScreen(viewModel: viewModel)
    }
}
