//
//  BaseText.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import SwiftUI

struct BaseText: View {
    let textKey: String
    var textType: TextType = .body
    var textColor: Color = .primary          // was `tetColor`
    var alignment: TextAlignment = .leading
    var lineLimit: Int? = nil
    var args: [CVarArg] = []

    @ObservedObject private var languageManager = LanguageManager.shared

    private var localizedString: String {
        let format = textKey.localized()
        return args.isEmpty ? format : String(format: format, arguments: args)
    }

    var body: some View {
        Text(localizedString)
            .font(textType.font(for: languageManager.currentLanguage))
            .foregroundStyle(textColor)
            .multilineTextAlignment(alignment)
            .lineLimit(lineLimit)
            .fixedSize(horizontal: false, vertical: true) // avoids vertical truncation
    }
}

// MARK: - Usage Example

struct ContentView: View {
    @ObservedObject private var languageManager = LanguageManager.shared

    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 12) {
                // Localized Strings
                BaseText(textKey: "welcome_title", textType: .title)
                BaseText(textKey: "profile_subtitle", textType: .subtitle, textColor: .secondary)
                BaseText(textKey: "user_greeting", textType: .body, args: ["Alex", "Aliza"])
                BaseText(textKey: "footer_note", textType: .caption, textColor: .gray)
                BaseText(textKey: "welcome_title", textType: .custom(type: .subtitle, size: 18))
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





