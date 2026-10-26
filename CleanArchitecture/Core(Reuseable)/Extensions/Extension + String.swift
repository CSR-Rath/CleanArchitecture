//
//  Extension + String.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/22/26.
//

import SwiftUI

extension String {
    var isValidEmail: Bool {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return range(of: emailRegex, options: .regularExpression) != nil
    }
}



