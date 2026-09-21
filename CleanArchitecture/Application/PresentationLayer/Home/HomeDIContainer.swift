//
//  HomeDIContainer.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import SwiftUI

public final class HomeDIContainer {
    private let networkClient: NetworkClientProtocol

    public init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    
    // option 1
    public func makeHomeVM() -> HomeViewModel {
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
    public func makeHomeView() -> HomeScreen {
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
