//
//  Extension+String.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import Foundation

extension String {
    func localized() -> String {
        let lang = LanguageManager.shared.getCurrentLanguage().rawValue
        
        guard let path = Bundle.main.path(forResource: lang, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(self, comment: "")
        }
        
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
    
    func localized(_ values: CVarArg...) -> String {
        let format = self.localized()
        return String(format: format, arguments: values)
    }
}
