//
//  AppCoordinatorView.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/26/26.
//

import SwiftUI

@MainActor
struct AppCoordinatorView: View {
    @StateObject private var appState = AppState()
    @StateObject private var navigation = NavigationManager()

    var body: some View {
        Group {
            switch appState.root {
            case .splash:
                splashView

            case .login:
                loginView

            case .main:
                mainView
            }
        }
        .animation(.easeInOut, value: appState.root)
    }

    private var splashView: some View {
        VStack(spacing: 20) {
            Image(systemName: "building.columns.fill")
                .font(.system(size: 55))
                .foregroundStyle(.blue)

            Text("My Banking App")
                .font(.largeTitle.bold())

            Button("Get Started") {
                appState.setRoot(.login)
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var loginView: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.largeTitle.bold())

            Text("Welcome back!")

            Button("Login Successfully") {
                navigation.popToRoot()
                appState.setRoot(.main)
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var mainView: some View {
        NavigationStack(path: $navigation.path) {
            VStack(spacing: 16) {
                Text("Home Screen")
                    .font(.largeTitle.bold())

                Button("Open Profile") {
                    navigation.push(.profile(userID: "123"))
                }

                Button("Open Orders") {
                    navigation.push(.orders)
                }

                Button("Open Settings") {
                    navigation.push(.settings)
                }

                Button("Open Detail") {
                    navigation.push(.detail(id: 1001))
                }

                Divider()

                Button("Logout") {
                    navigation.popToRoot()
                    appState.setRoot(.login)
                }
                .foregroundStyle(.red)
            }
            .buttonStyle(.bordered)
            .navigationTitle("Home")
            .navigationDestination(for: AppRoute.self) { route in
                destination(for: route)
            }
        }
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .detail(let id):
            DetailView(title: "Detail \(id)", navigation: navigation)

        case .profile(let userID):
            DetailView(title: "Profile \(userID)", navigation: navigation)

        case .orders:
            DetailView(title: "Orders", navigation: navigation)

        case .settings:
            DetailView(title: "Settings", navigation: navigation)
        }
    }
}

// MARK: - Reusable Feature Screen

struct DetailView: View {
    let title: String
    @ObservedObject var navigation: NavigationManager

    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.largeTitle.bold())

            Button("Push Another Detail") {
                navigation.push(.detail(id: 2002))
            }
            .buttonStyle(.borderedProminent)

            Button("Pop One Screen") {
                navigation.pop()
            }
            .buttonStyle(.bordered)

            Button("Pop To Root") {
                navigation.popToRoot()
            }
            .buttonStyle(.bordered)

            Button("Pop Two Screens") {
                navigation.pop(2)
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
