//
//  LanguageType.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import Foundation

enum LanguageType: String, CaseIterable {
    case english = "en"
    case khmer = "km-KH"
    
    var title: String {
        switch self {
        case .english:
            return "English"
        case .khmer:
            return "ខ្មែរ"
        }
    }
}
