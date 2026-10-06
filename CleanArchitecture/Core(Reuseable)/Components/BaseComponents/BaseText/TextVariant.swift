//
//  TextVariant.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import SwiftUI

enum TextVariant {
    case title
    case subtitle
    case body
    case caption
    case custom(
        englishFont: String,
        khmerFont: String,
        size: CGFloat
    )

    /// Dynamically resolves font family based on active language
    func font(for language: LanguageType) -> Font {
        switch language {
        case .english:
            switch self {
            case .title:
                return .custom("Poppins-Bold", fixedSize: 28)
            case .subtitle:
                return .custom("Poppins-Medium", fixedSize: 20)
            case .body:
                return .custom("Roboto-Regular", fixedSize: 16)
            case .caption:
                return .custom("Roboto-Light", fixedSize: 12)
            case .custom(let englishFont, _, let size):
                return .custom(englishFont, fixedSize: size)
            }
        case .khmer:
            switch self {
            case .title:
                return .custom("KantumruuyPro-Bold", fixedSize: 26)
            case .subtitle:
                return .custom("KantumruuyPro-SemiBold", fixedSize: 19)
            case .body:
                return .custom("KantumruuyPro-Regular", fixedSize: 15)
            case .caption:
                return .custom("KantumruuyPro-Light", fixedSize: 12)
            case .custom(_, let khmerFont, let size):
                return .custom(khmerFont, fixedSize: size)

            }
        }
    }
}
