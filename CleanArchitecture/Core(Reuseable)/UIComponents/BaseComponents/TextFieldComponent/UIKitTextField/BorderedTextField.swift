//
//  BorderedTextField.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/9/26.
//

import UIKit

enum BorderState {
    case idle, editing, invalid

    var color: UIColor {
        switch self {
        case .idle:    return .systemGray4
        case .editing: return .systemBlue
        case .invalid: return .systemRed
        }
    }
}

struct FieldIcon {
    var systemName: String
    var tint: UIColor = .secondaryLabel
    var action: (() -> Void)? = nil
}

final class BorderedTextField: UITextField {
    enum Side { case left, right }

    private let edgePadding: CGFloat = 12
    private let iconWidth: CGFloat = 44

    private var leftIconName: String?
    private var rightIconName: String?

    var isValid = true {
        didSet { if oldValue != isValid { updateBorder() } }
    }

    private var borderState: BorderState {
        if !isValid { return .invalid }
        return isFirstResponder ? .editing : .idle
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 1.2
        layer.cornerRadius = 12
        updateBorder()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: Border
    func updateBorder() {
        layer.borderColor = borderState.color.resolvedColor(with: traitCollection).cgColor
    }

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        updateBorder()
        return result
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        updateBorder()
        return result
    }

    override func traitCollectionDidChange(_ previous: UITraitCollection?) {
        super.traitCollectionDidChange(previous)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previous) {
            updateBorder()
        }
    }

    // MARK: Icons
    /// Pass `nil` to remove the icon. The tap handler is only wired when the button is created.
    func setIcon(_ icon: FieldIcon?, side: Side, onTap: @escaping () -> Void) {
        guard let icon else {
            switch side {
            case .left:  leftView = nil;  leftViewMode = .never;  leftIconName = nil
            case .right: rightView = nil; rightViewMode = .never; rightIconName = nil
            }
            return
        }

        let existing = (side == .left ? leftView : rightView) as? UIButton

        // Same icon already showing: just refresh the tint
        if let existing, (side == .left ? leftIconName : rightIconName) == icon.systemName {
            existing.tintColor = icon.tint
            return
        }

        let button = existing ?? makeButton(side: side, onTap: onTap)
        button.setImage(UIImage(systemName: icon.systemName), for: .normal)
        button.tintColor = icon.tint

        switch side {
        case .left:
            leftView = button
            leftViewMode = .always
            leftIconName = icon.systemName
        case .right:
            rightView = button
            rightViewMode = .always
            rightIconName = icon.systemName
        }
    }

    private func makeButton(side: Side, onTap: @escaping () -> Void) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 16)
        // Padding lives inside the button, so the whole area is tappable
        config.contentInsets = side == .left
            ? NSDirectionalEdgeInsets(top: 0, leading: edgePadding, bottom: 0, trailing: 8)
            : NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: edgePadding)

        let button = UIButton(configuration: config, primaryAction: UIAction { _ in onTap() })
        button.frame = CGRect(x: 0, y: 0, width: iconWidth, height: 44)
        return button
    }

    // MARK: Text padding
    // UITextField already offsets its text rects for leftView/rightView,
    // so we only add padding on a side that has no icon.
    private var textInsets: UIEdgeInsets {
        UIEdgeInsets(
            top: 0,
            left: leftView == nil ? edgePadding : 0,
            bottom: 0,
            right: rightView == nil ? edgePadding : 0
        )
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        super.textRect(forBounds: bounds).inset(by: textInsets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        super.editingRect(forBounds: bounds).inset(by: textInsets)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        textRect(forBounds: bounds)   // no extra inset
    }
}
