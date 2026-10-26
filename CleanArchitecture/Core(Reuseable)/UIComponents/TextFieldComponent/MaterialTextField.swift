//
//  MaterialTextField.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/22/26.
//

import SwiftUI

struct MaterialTextField: View {
    let title: String
    @Binding var text: String
    var helperText: String? = nil
    var errorText: String? = nil

    @FocusState private var isFocused: Bool

    private var isFloating: Bool { isFocused || !text.isEmpty }
    private var color: Color {
        errorText != nil ? .red : (isFocused ? .blue : .gray)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(color, lineWidth: (isFocused || errorText != nil) ? 2 : 1)

                TextField("", text: $text)
                    .focused($isFocused)
                    .padding(.horizontal, 16)

                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(color)
                    .padding(.horizontal, 4)
                    .background(Color.appBackground)
                    .scaleEffect(isFloating ? 0.75 : 1, anchor: .leading)
                    .offset(x: 12, y: isFloating ? -28 : 0)
                    .allowsHitTesting(false)
            }
            .frame(height: 56)
            .contentShape(Rectangle())
            .onTapGesture { isFocused = true }
            .animation(.easeOut(duration: 0.18), value: isFloating)
            .animation(.easeOut(duration: 0.18), value: isFocused)
            
            if let message = errorText ?? helperText {
                   Text(message)
                       .font(.caption)
                       .foregroundColor(errorText != nil ? .red : .gray)
                       .padding(.horizontal, 16)
                       .id(message)   // new text = new view, so it animates when switching helper <-> error
                       .transition(
                           .opacity.combined(with: .offset(y: -6))
                       )
               }

//            if let message = errorText ?? helperText {
//                Text(message)
//                    .font(.caption)
//                    .foregroundColor(errorText != nil ? .red : .gray)
//                    .padding(.horizontal, 16)
//            }
        }
        .animation(.easeOut(duration: 0.2), value: errorText)
        .animation(.easeOut(duration: 0.2), value: helperText)
    }
}

// Usage
//struct DemoView: View {
//    @State private var email = ""
//    var body: some View {
//        ZStack{
//            Color.appBackground.ignoresSafeArea()
//            VStack{
//                Spacer()
//                MaterialTextField(title: "Email",
//                                  text: $email,
//                                  errorText: email.isValidEmail || email.isEmpty ? nil : "Invalid email")
////                .focused(.constant(true))
//                
//                    .padding()
//                
//                Spacer()
//                
//                
//                BaseButton("Dismiss Keyboard", type: .plain) {
//               
//                }
//
//                
//                BaseButton("Dismiss Keyboard", type: .soft) {
//               
//                }
//              
//                
//                BaseButton("Dismiss Keyboard", type: .outline) {
//               
//                }
//                .disabled(true)
//
//                
//                BaseButton("Dismiss Keyboard") {
//               
//                }
//                .padding(.bottom, 100)
//            }
//        }
//        .dismissKeyboardOnTap()
//    }
//}





