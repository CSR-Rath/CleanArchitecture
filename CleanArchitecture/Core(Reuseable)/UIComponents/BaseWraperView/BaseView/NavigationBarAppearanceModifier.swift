//
//  NavigationBarAppearanceModifier.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/21/26.
//

import SwiftUI

struct NavigationBarAppearanceModifier: ViewModifier {
    let scrolledBackgroundColor: UIColor
    let backgroundColor: UIColor
    let scrolledTitleColor: UIColor
    let titleColor: UIColor
    
    let isTranslucent: Bool
    
    init(
        backgroundColor: UIColor = .white,
        titleColor: UIColor = .black,
        scrolledBackgroundColor: UIColor = .lightGray,
        scrolledTitleColor: UIColor = .black,
        isTranslucent: Bool = false
    ) {
        self.backgroundColor = backgroundColor
        self.titleColor = titleColor
        self.scrolledBackgroundColor = scrolledBackgroundColor
        self.scrolledTitleColor = scrolledTitleColor
        self.isTranslucent = isTranslucent
        
        
        let appearance = UINavigationBarAppearance()
        
        if isTranslucent {
            appearance.configureWithTransparentBackground()
        } else {
            appearance.configureWithOpaqueBackground()
            appearance.shadowColor = .clear
            appearance.backgroundColor =  backgroundColor
        }
        
        appearance.titleTextAttributes = [.foregroundColor: titleColor]
        appearance.largeTitleTextAttributes = [.foregroundColor: titleColor]
        
        // Standard appearance (used when content is scrolled behind)
        let scrolledAppearance = UINavigationBarAppearance()
        scrolledAppearance.configureWithOpaqueBackground()
//        scrolledAppearance.shadowColor = .clear // 👈 Removes the separator line
        scrolledAppearance.backgroundColor = scrolledBackgroundColor
        scrolledAppearance.titleTextAttributes = [.foregroundColor: scrolledTitleColor]
        scrolledAppearance.largeTitleTextAttributes = [.foregroundColor: scrolledTitleColor]
        
        UINavigationBar.appearance().standardAppearance = scrolledAppearance
        UINavigationBar.appearance().compactAppearance = scrolledAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func configureNavigationBarAppearance(
        backgroundColor: UIColor = .white,
        titleColor: UIColor = .black,
        isTranslucent: Bool = false
    ) -> some View {
//        .toolbarBackground(.orange, for: .navigationBar)
//        .toolbarBackground(.visible, for: .navigationBar)
        
        self.modifier(
            NavigationBarAppearanceModifier(
                backgroundColor: backgroundColor,
                titleColor: titleColor,
                isTranslucent: isTranslucent
            )
        )
    }
}
