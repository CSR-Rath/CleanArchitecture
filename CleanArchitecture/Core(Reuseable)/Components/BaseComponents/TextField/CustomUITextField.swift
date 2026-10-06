//
//  CustomUITextField.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import SwiftUI
import UIKit


// MARK: - Demo View
struct ProfessionalFormView: View {
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var password: String = ""

    @State private var emailError: String? = nil
    @State private var phoneError: String? = nil
    @State private var passwordError: String? = nil
    @State private var submissionSuccess: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // 1. Email Field
                    FormTextField(
                        title: "Email Address",
                        errorMessage: emailError,
                        text: $email,
                        placeholder: "name@example.com",
                        leadingIcon: UIImage(systemName: "envelope.fill"),
                        keyboardType: .emailAddress,
                        returnKeyType: .next
                    )

                    // 2. Phone Number Field (Max 10 Digits, Numbers Only)
                    FormTextField(
                        title: "Phone Number (Digits Only, Max 10)",
                        errorMessage: phoneError,
                        text: $phone,
                        placeholder: "0123456789",
                        leadingIcon: UIImage(systemName: "phone.fill"),
                        keyboardType: .numberPad,
                        maxLength: 10,
                        allowedRegexPattern: "^[0-9]*$"
                    )

                    // 3. Password Field (Secure Toggle)
                    FormTextField(
                        title: "Password",
                        errorMessage: passwordError,
                        text: $password,
                        placeholder: "Enter password",
                        leadingIcon: UIImage(systemName: "lock.fill"),
                        isSecureTextEntry: true,
                        returnKeyType: .done,
                        onReturnPressed: submitForm
                    )

                    // Submit Button
                    Button(action: submitForm) {
                        Text("Submit Form")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.top, 10)

                    if submissionSuccess {
                        Text("Form Submitted Successfully!")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                            .padding(.top, 8)
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("UIKit BaseTextField Demo")
        }
    }

    private func submitForm() {
        var isValid = true

        // Email Validation
        if !email.contains("@") || !email.contains(".") {
            emailError = "Please enter a valid email address."
            isValid = false
        } else {
            emailError = nil
        }

        // Phone Validation
        if phone.count < 10 {
            phoneError = "Phone number must be exactly 10 digits."
            isValid = false
        } else {
            phoneError = nil
        }

        // Password Validation
        if password.count < 6 {
            passwordError = "Password must be at least 6 characters."
            isValid = false
        } else {
            passwordError = nil
        }

        submissionSuccess = isValid
    }
}

// MARK: - Form Wrapper View
public struct FormTextField: View {
    private let title: String?
    private let errorMessage: String?
    private let baseField: BaseTextField

    public init(
        title: String? = nil,
        errorMessage: String? = nil,
        text: Binding<String>,
        placeholder: String = "",
        leadingIcon: UIImage? = nil,
        isSecureTextEntry: Bool = false,
        keyboardType: UIKeyboardType = .default,
        returnKeyType: UIReturnKeyType = .done,
        maxLength: Int? = nil,
        allowedRegexPattern: String? = nil,
        onReturnPressed: (() -> Void)? = nil
    ) {
        self.title = title
        self.errorMessage = errorMessage
        self.baseField = BaseTextField(
            text: text,
            placeholder: placeholder,
            errorMessage: errorMessage,
            leadingIcon: leadingIcon,
            isSecureTextEntry: isSecureTextEntry,
            keyboardType: keyboardType,
            returnKeyType: returnKeyType,
            maxLength: maxLength,
            allowedRegexPattern: allowedRegexPattern,
            onReturnPressed: onReturnPressed
        )
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let title = title {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }

            baseField
                .frame(height: 48)

            if let errorMessage = errorMessage, !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}

// MARK: - BaseTextField (UIKit -> SwiftUI)
public struct BaseTextField: UIViewRepresentable {
    @Binding private var text: String
    private let placeholder: String
    private let errorMessage: String?
    private let leadingIcon: UIImage?
    private let isSecureTextEntry: Bool
    private let keyboardType: UIKeyboardType
    private let returnKeyType: UIReturnKeyType
    private let maxLength: Int?
    private let allowedRegexPattern: String?
    private var onReturnPressed: (() -> Void)?

    public init(
        text: Binding<String>,
        placeholder: String = "",
        errorMessage: String? = nil,
        leadingIcon: UIImage? = nil,
        isSecureTextEntry: Bool = false,
        keyboardType: UIKeyboardType = .default,
        returnKeyType: UIReturnKeyType = .done,
        maxLength: Int? = nil,
        allowedRegexPattern: String? = nil,
        onReturnPressed: (() -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.errorMessage = errorMessage
        self.leadingIcon = leadingIcon
        self.isSecureTextEntry = isSecureTextEntry
        self.keyboardType = keyboardType
        self.returnKeyType = returnKeyType
        self.maxLength = maxLength
        self.allowedRegexPattern = allowedRegexPattern
        self.onReturnPressed = onReturnPressed
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    public func makeUIView(context: Context) -> CustomUITextField {
        let textField = CustomUITextField(padding: UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12))
        textField.delegate = context.coordinator
        
        textField.addTarget(
            context.coordinator,
            action: #selector(Coordinator.textFieldDidChange(_:)),
            for: .editingChanged
        )

        textField.placeholder = placeholder
        textField.keyboardType = keyboardType
        textField.returnKeyType = returnKeyType
        textField.isSecureTextEntry = isSecureTextEntry
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.systemGray4.cgColor

        return textField
    }

    public func updateUIView(_ uiView: CustomUITextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }

        uiView.isSecureTextEntry = context.coordinator.isPasswordVisible ? false : isSecureTextEntry
        uiView.layer.borderColor = errorMessage != nil
            ? UIColor.systemRed.cgColor
            : (uiView.isFirstResponder ? UIColor.systemBlue.cgColor : UIColor.systemGray4.cgColor)
    }

    private func setupLeadingIcon(for textField: CustomUITextField) {
        guard let icon = leadingIcon else { return }
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let imageView = UIImageView(image: icon.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        container.addSubview(imageView)

        textField.leftView = container
        textField.leftViewMode = .always
    }

    private func setupTrailingControls(for textField: CustomUITextField, context: Context) {
        if isSecureTextEntry {
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            let image = UIImage(systemName: "eye.fill")
            button.setImage(image, for: .normal)
            button.tintColor = .secondaryLabel
            button.addTarget(context.coordinator, action: #selector(Coordinator.togglePasswordVisibility(_:)), for: .touchUpInside)

            textField.rightView = button
            textField.rightViewMode = .always
        } else {
            textField.clearButtonMode = .whileEditing
        }
    }

    public class Coordinator: NSObject, UITextFieldDelegate {
        var parent: BaseTextField
        var isPasswordVisible: Bool = false

        init(parent: BaseTextField) {
            self.parent = parent
        }

        @objc func textFieldDidChange(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }

        @objc func togglePasswordVisibility(_ sender: UIButton) {
            isPasswordVisible.toggle()
            let image = UIImage(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
            sender.setImage(image, for: .normal)
            if let textField = sender.superview as? UITextField {
                textField.isSecureTextEntry = !isPasswordVisible
            }
        }

        public func textFieldDidBeginEditing(_ textField: UITextField) {
            textField.layer.borderColor = parent.errorMessage != nil
                ? UIColor.systemRed.cgColor
                : UIColor.systemBlue.cgColor
        }

        public func textFieldDidEndEditing(_ textField: UITextField) {
            textField.layer.borderColor = parent.errorMessage != nil
                ? UIColor.systemRed.cgColor
                : UIColor.systemGray4.cgColor
        }

        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            parent.onReturnPressed?()
            textField.resignFirstResponder()
            return true
        }

        public func textField(
            _ textField: UITextField,
            shouldChangeCharactersIn range: NSRange,
            replacementString string: String
        ) -> Bool {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            if let maxLength = parent.maxLength, updatedText.count > maxLength {
                return false
            }

            if let pattern = parent.allowedRegexPattern, !string.isEmpty {
                let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
                if !predicate.evaluate(with: string) {
                    return false
                }
            }

            return true
        }
    }
}



public class CustomUITextField: UITextField {
    private var padding: UIEdgeInsets

    init(padding: UIEdgeInsets) {
        self.padding = padding
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Controls text bounds when not editing
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect = bounds.inset(by: padding)
        if let leftView = leftView {
            rect.origin.x += leftView.frame.width + 4 // Extra 4pt spacing after icon
            rect.size.width -= leftView.frame.width + 4
        }
        return rect
    }

    // Controls text bounds while editing
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        var rect = bounds.inset(by: padding)
        if let leftView = leftView {
            rect.origin.x += leftView.frame.width + 4 // Extra 4pt spacing after icon
            rect.size.width -= leftView.frame.width + 4
        }
        return rect
    }

    // Controls placeholder text bounds
    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        var rect = bounds.inset(by: padding)
        if let leftView = leftView {
            rect.origin.x += leftView.frame.width + 4 // Extra 4pt spacing after icon
            rect.size.width -= leftView.frame.width + 4
            leftView.backgroundColor = .red
        }
        return rect
    }

    // Ensures the left view icon has proper padding from the left edge of the border
    override public func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 12 // Spacing from the outer left border
        return rect
    }

    // Ensures the trailing right view has proper padding from the right edge
    override public func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= 12 // Spacing from the outer right border
        return rect
    }
}
