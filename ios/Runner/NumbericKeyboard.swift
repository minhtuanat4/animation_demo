import UIKit

protocol NumericKeyboardDelegate: AnyObject {
    func numericKeyWasTapped(_ key: String)
    func numericBackspaceTapped()
    func numericDoneTapped()
}

final class NumericKeyboard: UIView {
    weak var delegate: NumericKeyboardDelegate?

    private let buttonTitles: [[String]] = [
        ["1","2","3"],
        ["4","5","6"],
        ["7","8","9"],
        ["00","0","⌫"]
    ]

    private let feedback = UIImpactFeedbackGenerator(style: .light)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) { super.init(coder: coder); setupView() }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor { trait in
            trait.userInterfaceStyle == .dark ? .secondarySystemBackground : .systemGray6
        }

        let rowsStack = UIStackView()
        rowsStack.axis = .vertical
        rowsStack.distribution = .fillEqually
        rowsStack.spacing = 8
        rowsStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rowsStack)

        NSLayoutConstraint.activate([
            rowsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            rowsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            rowsStack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            rowsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            heightAnchor.constraint(equalToConstant: 260) // standard keyboard-ish height
        ])

        for row in buttonTitles {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.distribution = .fillEqually
            rowStack.spacing = 8

            for title in row {
                let btn = makeButton(title: title)
                rowStack.addArrangedSubview(btn)
            }
            rowsStack.addArrangedSubview(rowStack)
        }

        // optional bottom row: Done and maybe decimal
        let bottomRow = UIStackView()
        bottomRow.axis = .horizontal
        bottomRow.distribution = .fillEqually
        bottomRow.spacing = 8

        let decimalBtn = makeButton(title: ".")
        let doneBtn = makeButton(title: "Done")
        doneBtn.backgroundColor = .systemBlue
        doneBtn.setTitleColor(.white, for: .normal)
        bottomRow.addArrangedSubview(decimalBtn)
        bottomRow.addArrangedSubview(doneBtn)
        rowsStack.addArrangedSubview(bottomRow)

        // button actions
        addActions()
    }

    private func makeButton(title: String) -> UIButton {
        let b = UIButton(type: .system)
        b.setTitle(title, for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 26, weight: .medium)
        b.backgroundColor = UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(white: 0.18, alpha: 1) : .white
        }
        b.layer.cornerRadius = 8
        b.layer.shadowColor = UIColor.black.withAlphaComponent(0.12).cgColor
        b.layer.shadowOffset = CGSize(width: 0, height: 1)
        b.layer.shadowOpacity = 0.6
        b.layer.shadowRadius = 1.5
        b.translatesAutoresizingMaskIntoConstraints = false
        b.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return b
    }

    private func addActions() {
        for case let btn as UIButton in self.subviewsRecursive() where btn is UIButton {
            guard let title = btn.currentTitle else { continue }
            if title == "⌫" {
                btn.addTarget(self, action: #selector(backspaceTapped), for: .touchUpInside)
            } else if title == "Done" {
                btn.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
            } else {
                btn.addTarget(self, action: #selector(keyTapped(_:)), for: .touchUpInside)
            }
        }
    }

    @objc private func keyTapped(_ sender: UIButton) {
        feedback.impactOccurred()
        guard let key = sender.currentTitle else { return }
        delegate?.numericKeyWasTapped(key)
    }

    @objc private func backspaceTapped() {
        feedback.impactOccurred()
        delegate?.numericBackspaceTapped()
    }

    @objc private func doneTapped() {
        delegate?.numericDoneTapped()
    }
}

private extension UIView {
    // helper to iterate subviews recursively
    func subviewsRecursive() -> [UIView] {
        return subviews + subviews.flatMap { $0.subviewsRecursive() }
    }
}
