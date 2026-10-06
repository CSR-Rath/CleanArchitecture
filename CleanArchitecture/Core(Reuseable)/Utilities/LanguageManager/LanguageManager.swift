//
//  LanguageManager.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import SwiftUI
import Combine

@MainActor
final class LanguageManager: ObservableObject {
    
    // MARK: - Singleton
    static let shared = LanguageManager()
    
    // MARK: - Properties
    @Published var currentLanguage: LanguageType {
        didSet {
            saveLanguage()
            updateBundle()
        }
    }
    
    private(set) var bundle: Bundle = .main
    private let languageKey = "app_language"
    
    // MARK: - Init
    private init() {
        if let savedLanguage = UserDefaults.standard.string(forKey: languageKey),
           let language = LanguageType(rawValue: savedLanguage) {
            currentLanguage = language
        } else {
            currentLanguage = .english
        }
        updateBundle()
    }
    
    // MARK: - Public
    func changeLanguage(_ language: LanguageType) {
        currentLanguage = language
    }
    
    func getCurrentLanguage() -> LanguageType {
        currentLanguage
    }
    
    // MARK: - Private
    private func saveLanguage() {
        UserDefaults.standard.set(currentLanguage.rawValue, forKey: languageKey)
    }
    
    private func updateBundle() {
        guard let path = Bundle.main.path(forResource: currentLanguage.rawValue, ofType:"lproj"),
        let bundle = Bundle(path: path) else {
            self.bundle = .main
            return
        }
        
        self.bundle = bundle
    }
}


