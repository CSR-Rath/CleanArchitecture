//
//  CustomButtonType.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import SwiftUI

enum CustomButtonType {
    case filled
    case outline
    case soft
    case plain
    case custom
}

struct CustomButtonStyle<CustomContent: View>: ButtonStyle {
    
    @Environment(\.isEnabled) private var isEnabled
    
    let type: CustomButtonType
    let txtColor: Color // txt and bg color
    
    var height: CGFloat
    var cornerRadius: CGFloat
    var fontSize: CGFloat
    var fontWeight: Font.Weight
    
    // Custom content view builder closure
    let customView: ((Configuration) -> CustomContent)?
    
    init(
        type: CustomButtonType = .filled,
        color: Color = .primary,
        height: CGFloat = 50,
        cornerRadius: CGFloat = 25,
        fontSize: CGFloat = 16,
        fontWeight: Font.Weight = .semibold,
        @ViewBuilder customView: @escaping (Configuration) -> CustomContent
    ) {
        self.type = type
        self.txtColor = color
        self.height = height
        self.cornerRadius = cornerRadius
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.customView = customView
    }
    
    // Convenience initializer when customView is NOT used
    init(
        type: CustomButtonType = .filled,
        color: Color = .primary,
        height: CGFloat = 50,
        cornerRadius: CGFloat = 25,
        fontSize: CGFloat = 16,
        fontWeight: Font.Weight = .semibold
    ) where CustomContent == EmptyView {
        self.type = type
        self.txtColor = color
        self.height = height
        self.cornerRadius = cornerRadius
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.customView = nil
    }
    
    func makeBody(configuration: Configuration) -> some View {
        Group {
            switch type {
            case .filled:
                filledButton(configuration: configuration)
                
            case .outline:
                outlineButton(configuration: configuration)
                
            case .soft:
                softButton(configuration: configuration)
                
            case .plain:
                plainButton(configuration: configuration)
                
            case .custom:
                if let customView = customView {
                    customView(configuration)
                } else {
                    baseLabel(configuration: configuration)
                }
            }
        }
        .opacity(buttonOpacity(isPressed: configuration.isPressed))
        .scaleEffect(configuration.isPressed && isEnabled ? 0.97 : 1)
        .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
        .animation(.easeInOut(duration: 0.15), value: isEnabled)
    }
    
    private func filledButton(configuration: Configuration) -> some View {
        baseLabel(configuration: configuration)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(isEnabled ? txtColor : txtColor.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .contentShape(Rectangle())
    }
    
    private func outlineButton(configuration: Configuration) -> some View {
        baseLabel(configuration: configuration)
            .foregroundColor(isEnabled ? txtColor : txtColor.opacity(0.5))
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(isEnabled ? txtColor : txtColor.opacity(0.5), lineWidth: 1.5)
                    .padding(0.5)
                //use padding prevent cut stroke or boarder horizontal
            )
            .contentShape(Rectangle())
    }
    
    private func softButton(configuration: Configuration) -> some View {
        baseLabel(configuration: configuration)
            .foregroundColor(isEnabled ? txtColor : txtColor.opacity(0.5))
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(isEnabled ? txtColor.opacity(0.15) : txtColor.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .contentShape(Rectangle())
    }
    
    private func plainButton(configuration: Configuration) -> some View {
        baseLabel(configuration: configuration)
            .foregroundColor(isEnabled ? txtColor : txtColor.opacity(0.5))
            .contentShape(Rectangle())
    }
    
    private func baseLabel(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: fontSize, weight: fontWeight))
    }
    
    private func buttonOpacity(isPressed: Bool) -> CGFloat {
        if !isEnabled {
            return 0.50
        }
        
        return isPressed ? 0.7 : 1
    }
}
