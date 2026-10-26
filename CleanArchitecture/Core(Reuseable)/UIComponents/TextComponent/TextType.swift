//
//  TextType.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import SwiftUI

enum TextType {
    case title
    case subtitle
    case body
    case caption
    case custom(type: FontType, size: CGFloat)

    func font(for language: LanguageType) -> Font {
        if case .custom(let type, let size) = self {
            return .custom(fontName(for: type, language: language), fixedSize: size)
        } else {
            return .custom(fontName(for: baseType, language: language),fixedSize: defaultSize(for: language))
        }
    }

    // Maps each preset to a FontType (custom carries its own)
    private var baseType: FontType {
        switch self {
        case .title:   return .title
        case .subtitle: return .subtitle
        case .body:    return .body
        case .caption: return .caption
        case .custom(let type, _): return type
        }
    }

    private func defaultSize(for language: LanguageType) -> CGFloat {
        switch (language, baseType) {
        case (.english, .title):    return 28
        case (.english, .subtitle): return 20
        case (.english, .body):     return 16
        case (.english, .caption):  return 12
        case (.khmer, .title):      return 26
        case (.khmer, .subtitle):   return 19
        case (.khmer, .body):       return 15
        case (.khmer, .caption):    return 12
        }
    }

    private func fontName(for type: FontType, language: LanguageType) -> String {
        switch language {
        case .english:
            switch type {
            case .title:    return English.bold.rawValue
            case .subtitle: return English.medium.rawValue
            case .body:     return English.regular.rawValue
            case .caption:  return English.caption.rawValue
            }
        case .khmer:
            switch type {
            case .title:    return Khmer.bold.rawValue
            case .subtitle: return Khmer.medium.rawValue
            case .body:     return Khmer.regular.rawValue
            case .caption:  return Khmer.light.rawValue
            }
        }
    }
}

enum FontType {
    case body, subtitle, title, caption
}

enum English: String {
    case regular = "GoogleSans-Regular"
    case medium  = "GoogleSans-Medium"
    case bold    = "GoogleSans-Bold"
    case caption = "GoogleSans_17pt-Regular"
}

enum Khmer: String {
    case regular = "KantumruyPro-Regular"
    case medium  = "KantumruyPro-Medium"
    case bold    = "KantumruyPro-Bold"
    case light   = "KantumruyPro-Light"
}

