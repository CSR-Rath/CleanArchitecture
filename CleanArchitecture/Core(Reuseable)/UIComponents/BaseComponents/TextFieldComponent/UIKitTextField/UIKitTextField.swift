import SwiftUI
import UIKit

struct UIKitTextField: UIViewRepresentable {
    @Binding var text: String
    @Binding var isFirstResponder: Bool
    
    var isValid: Bool = true
    var placeholder: String
    var maxLength: Int = 40
    var isPreventingMultipleSpaces: Bool = true

    var leftIcon: FieldIcon? = nil
    var rightIcon: FieldIcon? = nil

    var keyboardType: UIKeyboardType = .default
    var returnKeyType: UIReturnKeyType = .default
    var autocapitalization: UITextAutocapitalizationType = .sentences
    var font: UIFont = .systemFont(ofSize: 16)
    var textColor: UIColor = .label
    var showDoneToolbar: Bool = true

    var onEditingBegan: (() -> Void)?
    var onDidChange: (() -> Void)?
    var onEditingEnded: (() -> Void)?
    var onCommit: (() -> Void)?

    func makeUIView(context: Context) -> BorderedTextField {
        let textField = BorderedTextField()
        textField.delegate = context.coordinator
        textField.addTarget(
            context.coordinator,
            action: #selector(Coordinator.textChanged(_:)),
            for: .editingChanged
        )
        context.coordinator.textField = textField

        if showDoneToolbar {
            textField.inputAccessoryView = context.coordinator.makeToolbar()
        }

        configure(textField, coordinator: context.coordinator)
        return textField
    }

    func updateUIView(_ uiView: BorderedTextField, context: Context) {
        let coordinator = context.coordinator
        coordinator.parent = self

        configure(uiView, coordinator: coordinator)

        if uiView.text != text, uiView.markedTextRange == nil {
            uiView.text = text
        }

        if isFirstResponder != coordinator.lastRequestedFocus {
            coordinator.lastRequestedFocus = isFirstResponder
            DispatchQueue.main.async {
                if isFirstResponder {
                    uiView.becomeFirstResponder()
                } else {
                    uiView.resignFirstResponder()
                }
            }
        }
    }

    private func configure(_ textField: BorderedTextField, coordinator: Coordinator) {
        textField.isValid = isValid
        textField.placeholder = placeholder
        textField.font = font
        textField.textColor = textColor
        textField.autocapitalizationType = autocapitalization

        if textField.keyboardType != keyboardType { textField.keyboardType = keyboardType }
        if textField.returnKeyType != returnKeyType { textField.returnKeyType = returnKeyType }

        // The closure reads from `coordinator.parent`, so it always calls the latest action
        textField.setIcon(leftIcon, side: .left) { [weak coordinator] in
            coordinator?.parent.leftIcon?.action?()
        }
        textField.setIcon(rightIcon, side: .right) { [weak coordinator] in
            coordinator?.parent.rightIcon?.action?()
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    // MARK: - Coordinator
    final class Coordinator: NSObject, UITextFieldDelegate {
        var parent: UIKitTextField
        weak var textField: UITextField?
        var lastRequestedFocus: Bool

        init(_ parent: UIKitTextField) {
            self.parent = parent
            self.lastRequestedFocus = parent.isFirstResponder
        }

        func makeToolbar() -> UIToolbar {
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            toolbar.items = [
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
            ]
            return toolbar
        }

        @objc func textChanged(_ textField: UITextField) {
            parent.text = textField.text ?? ""
            parent.onDidChange?()
        }

        @objc func doneTapped() {
            textField?.resignFirstResponder()
            parent.onCommit?()
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            lastRequestedFocus = true
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                if !self.parent.isFirstResponder { self.parent.isFirstResponder = true }
                self.parent.onEditingBegan?()
            }
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            lastRequestedFocus = false
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                if self.parent.isFirstResponder { self.parent.isFirstResponder = false }
                self.parent.onEditingEnded?()
            }
        }

        func textField(
            _ textField: UITextField,
            shouldChangeCharactersIn range: NSRange,
            replacementString string: String
        ) -> Bool {
            if textField.markedTextRange != nil { return true }

            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updated = currentText.replacingCharacters(in: stringRange, with: string)

            if updated.count > parent.maxLength { return false }

            if parent.isPreventingMultipleSpaces,
               updated.hasPrefix(" ") || updated.contains("  ") {
                return false
            }
            return true
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            parent.onCommit?()
            return true
        }
    }
}

// MARK: - Demo
struct DemoUITextField: View {
    @State private var text = ""
    @State private var isFocused = false
    @State private var isValid = true
    @State private var isFirstResponder: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Output: \(text)")
                .font(.headline)

            UIKitTextField(
                text: $text,
                isFirstResponder: $isFirstResponder,
                isValid: isValid,
                placeholder: "Search...",
                leftIcon: FieldIcon(systemName: "magnifyingglass"){
                    isFirstResponder = true
                },
                rightIcon: text.isEmpty ? nil : FieldIcon(systemName: "xmark.circle.fill") {
                    text = ""
                   
                    print("Click icon rightIcon")
                },
                returnKeyType: .done,
                showDoneToolbar: false,
                onCommit: { print("Committed: \(text)") }
            )
            .frame(height: 54)

            // Right icon only
            UIKitTextField(
                text: $text,
                isFirstResponder: .constant(false),
                isValid: isValid,
                placeholder: "Scan or type...",
                rightIcon: FieldIcon(systemName: "qrcode.viewfinder", tint: .systemBlue) {
                    print("Scan tapped")
                },
                showDoneToolbar: false
            )
            .frame(height: 60)

            HStack {
                Button(isFocused ? "Dismiss Focus" : "Focus Programmatically") {
                    isFocused.toggle()
                }
                .buttonStyle(.borderedProminent)

                Button(isValid ? "Mark Invalid" : "Mark Valid") {
                    isValid.toggle()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
}

#Preview {
    DemoUITextField()
}
