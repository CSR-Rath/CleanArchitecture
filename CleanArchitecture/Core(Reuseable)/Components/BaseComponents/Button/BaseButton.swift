//
//  BaseButton.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//


import SwiftUI

enum IconPosition: String {
    case left
    case right
}

struct IconModel {
    let iconName: String
    let spacing: CGFloat
    let option: IconPosition
    
    init(iconName: String, spacing: CGFloat = 10, option: IconPosition = .left) {
        self.iconName = iconName
        self.spacing = spacing
        self.option = option
    }
}

struct BaseButton<CustomContent: View>: View {
    let titleKey: String
    let iconModel: IconModel?
    let type: CustomButtonType
    let color: Color
    let height: CGFloat
    let cornerRadius: CGFloat
    let fontSize: CGFloat
    let fontWeight: Font.Weight
    let isEnabled: Bool
    let action: () -> Void
    
    let customContent: ((ButtonStyleConfiguration) -> CustomContent)?
    
    // General Initializer (Standard Types)
    init(
        _ titleKey: String = "",
        type: CustomButtonType = .filled,
        iconModel: IconModel? = nil,
        color: Color = .orange,
        height: CGFloat = 50,
        cornerRadius: CGFloat = .infinity,
        fontSize: CGFloat = 16,
        fontWeight: Font.Weight = .semibold,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) where CustomContent == EmptyView {
        self.titleKey = titleKey
        self.iconModel = iconModel
        self.type = type
        self.color = color
        self.height = height
        self.cornerRadius = cornerRadius
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.isEnabled = isEnabled
        self.action = action
        self.customContent = nil
    }
    
    // Custom Content Initializer for type == .custom
    init(
        type: CustomButtonType = .custom,
        isEnabled: Bool = true,
        action: @escaping () -> Void,
        @ViewBuilder customContent: @escaping (ButtonStyleConfiguration) -> CustomContent
    ) {
        self.titleKey = ""
        self.iconModel = nil
        self.type = .custom
        self.color = .clear
        self.height = 50
        self.cornerRadius = 0
        self.fontSize = 16
        self.fontWeight = .regular
        self.isEnabled = isEnabled
        self.action = action
        self.customContent = customContent
    }
    
    var body: some View {
        Button(action: action) {
            if let iconModel = iconModel {
                HStack(spacing: iconModel.spacing) {
                    switch iconModel.option {
                    case .left:
                        Image(iconModel.iconName)
                        BaseText(textKey: titleKey, variant: .body)
                    case .right:
                        BaseText(textKey: titleKey, variant: .body)
                        Image(iconModel.iconName)
                    }
                }
            } else if !titleKey.isEmpty {
                Text(titleKey)
            }
        }
        .baseButtonStyle(
            type: type,
            color: color,
            height: height,
            cornerRadius: cornerRadius,
            fontSize: fontSize,
            fontWeight: fontWeight,
            customContent: customContent
        )
        .disabled(!isEnabled)
       
    }
}

private extension View {
    @ViewBuilder
    func baseButtonStyle<CustomContent: View>(
        type: CustomButtonType,
        color: Color,
        height: CGFloat,
        cornerRadius: CGFloat,
        fontSize: CGFloat,
        fontWeight: Font.Weight,
        customContent: ((ButtonStyleConfiguration) -> CustomContent)?
    ) -> some View {
        if let customContent = customContent {
            self.buttonStyle(
                CustomButtonStyle(
                    type: type,
                    color: color,
                    height: height,
                    cornerRadius: cornerRadius,
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    customView: customContent
                )
            )
        } else {
            self.buttonStyle(
                CustomButtonStyle(
                    type: type,
                    color: color,
                    height: height,
                    cornerRadius: cornerRadius,
                    fontSize: fontSize,
                    fontWeight: fontWeight
                )
            )
        }
    }
}

// MARK: Preview & Usage Example

#Preview {
    VStack(spacing: 20) {
        // Standard preset button
      
        BaseButton("Standard Filled", type: .plain) {}
        BaseButton("Standard Filled", type: .soft) {}
        BaseButton("Standard Filled", type: .outline) {}
        BaseButton("Standard Filled", type: .filled) {}
    


        // Completely custom content layout
        BaseButton(type: .custom) {
            print("Custom Tapped")
        } customContent: { config in
            HStack {
                Text("Gradient Custom Button")
                    .fontWeight(.bold)
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(
                LinearGradient(
                    colors: [.purple, .blue],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(Capsule())
            .shadow(color: .purple.opacity(0.4), radius: 8, x: 0, y: 4)
        }
    }
    .padding()
}
