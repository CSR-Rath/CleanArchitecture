//
//  Extension + UIColor.swift
//  CleanArchitecture
//
//  Created by Rath! on 24/8/24.
//

import UIKit
import SwiftUI

extension Color {
    
    static var mainBlueColor         = Color(#colorLiteral(red: 0.039, green: 0.349, blue: 0.831, alpha: 1)) // #0A59D4
    static var mainTxtColor          = Color(#colorLiteral(red: 0.596, green: 0.776, blue: 0.906, alpha: 1)) // #98C6E7
    static var mainLightColor        = Color(#colorLiteral(red: 0.220, green: 0.271, blue: 0.310, alpha: 1)) // #38454F
    static var mainColor             = Color(#colorLiteral(red: 0.122, green: 0.188, blue: 0.235, alpha: 1)) // #1F303C
    static var mainGray              = Color(#colorLiteral(red: 0.353, green: 0.376, blue: 0.443, alpha: 1)) // #5A6071
    static var mainYellow            = Color(#colorLiteral(red: 0.945, green: 0.745, blue: 0.282, alpha: 1)) // #F1BE48
    static var mainRed               = Color(#colorLiteral(red: 1.000, green: 0.345, blue: 0.278, alpha: 1)) // #FF5847
    
    static var backgroundColor: Color {
        switch AppearanceMode.current {
        case .light:
            return Color.white
        case .dark:
            return Color.black
        }
    }
}

extension UIColor {
    
    static var editColor             = #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)  //0A59D4
    static var addColor              = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)  //0A59D4
    static var deleteColor           = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)  //0A59D4
    static var mainBlueColor         = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)  //0A59D4
    static var mainTxtColor          = #colorLiteral(red: 0.1756211619, green: 0.5514567086, blue: 0.7638746319, alpha: 1)  //98C6E7
    static var mainBGColor           = #colorLiteral(red: 0.8533408605, green: 0.9960435564, blue: 0.9997980137, alpha: 1)  //98C6E7
    static var mainColorw            = #colorLiteral(red: 0.7333333333, green: 0.737254902, blue: 0.7450980392, alpha: 1)  //0A59D4
    static var mainLightColor        = #colorLiteral(red: 0.2061504722, green: 0.2724969983, blue: 0.314096868, alpha: 1)//38454F
    static var mainColor             = #colorLiteral(red: 0.118264921, green: 0.189347744, blue: 0.2359016538, alpha: 1)  // #1F303C
    static var mainGray              = #colorLiteral(red: 0.3529411765, green: 0.3764705882, blue: 0.4431372549, alpha: 1) // #5A6071
    static var mainYellow            = #colorLiteral(red: 0.9450980392, green: 0.7450980392, blue: 0.2823529412, alpha: 1) // #F1BE48
    static var mainRed               = #colorLiteral(red: 0.9985015988, green: 0.3468284607, blue: 0.2801859975, alpha: 1) //#FF5847
    static var mainTabBarColor       = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1) //#FF5847
    
    static var backgroundColor: UIColor {
        switch AppearanceMode.current {
        case .light:
            return UIColor.white
        case .dark:
            return UIColor.black
        }
    }
}


enum AppearanceMode: String {
    case light = "Light Mode"
    case dark = "Dark Mode"
    
    static var current: AppearanceMode {
        guard let appearanceMode = UserDefaults.standard.string(forKey: "") else {
            print("AppearanceMode is nil.")
            return .light
        }
        return AppearanceMode(rawValue: appearanceMode) ?? .light
    }
}
