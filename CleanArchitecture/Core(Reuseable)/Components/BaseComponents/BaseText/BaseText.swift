//
//  BaseText.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import SwiftUI

struct BaseText: View {
    let textKey: String
    var variant: TextVariant = .body
    var color: Color = .primary
    var alignment: TextAlignment = .leading
    var lineLimit: Int? = nil
    var args: [CVarArg] = []
    
    // for update localization
    @ObservedObject private var languageManager = LanguageManager.shared

    private var localizedString: String {
        if args.isEmpty {
            return textKey.localized()
        } else {
            return String(format: textKey.localized(), arguments: args)
        }
    }

    var body: some View {
        Text(localizedString)
            .font(variant.font(for: languageManager.currentLanguage))
            .foregroundColor(color)
            .multilineTextAlignment(alignment)
            .lineLimit(lineLimit)
//            .fixedSize(horizontal: false, vertical: true)
    }
}

// MARK: - Usage Example

struct ContentView: View {
    @ObservedObject private var languageManager = LanguageManager.shared

    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 12) {
                // Localized Strings
                BaseText(textKey: "welcome_title", variant: .title)
                BaseText(textKey: "profile_subtitle", variant: .subtitle, color: .secondary)
                
                // Localized String with Arguments (e.g. "Hello, %@ %@")
                BaseText(
                    textKey: "user_greeting",
                    variant: .body,
                    args: ["Alex", "Aliza"]
                )
                
                BaseText(textKey: "footer_note", variant: .caption, color: .gray)
                
                // Clean Custom Variant with language fallback support
                BaseText(
                    textKey: "custom_header",
                    variant: .custom(
                        englishFont: "Roboto-Light",
                        khmerFont: "KantumruuyPro-Bold",
                        size: 10
                    )
                )
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)

            // Language Toggle Switcher
            BaseButton("Current: \(languageManager.currentLanguage.title) — Tap to Toggle") {
                let nextLang: LanguageType = languageManager.currentLanguage == .english ? .khmer : .english
                languageManager.changeLanguage(nextLang)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}





