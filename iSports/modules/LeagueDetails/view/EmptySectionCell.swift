//
//  Untitled.swift
//  iSports
//
//  Created by JETSMobileLabMini9 on 09/06/2026.
//

import UIKit

// MARK: - EmptySectionCell
class EmptySectionCell: UICollectionViewCell {
    static let reuseIdentifier = "EmptySectionCell"

    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor       = UIColor(named: "accentColor")?.withAlphaComponent(0.45)
        iv.contentMode     = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let messageLabel: UILabel = {
        let l = UILabel()
        l.font          = .systemFont(ofSize: 14, weight: .medium)
        l.textColor     = UIColor(named: "SecondaryText") ?? .secondaryLabel
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let containerStack: UIStackView = {
        let sv = UIStackView()
        sv.axis      = .vertical
        sv.alignment = .center
        sv.spacing   = 10
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor   = UIColor(named: "CardBackground")?.withAlphaComponent(0.55)
            ?? UIColor.secondarySystemGroupedBackground
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true

        // Subtle border
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(named: "accentColor")?.withAlphaComponent(0.15).cgColor

        containerStack.addArrangedSubview(iconView)
        containerStack.addArrangedSubview(messageLabel)
        contentView.addSubview(containerStack)

        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 46),
            iconView.heightAnchor.constraint(equalToConstant: 46),
            containerStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            containerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(icon: String, message: String) {
        iconView.image    = UIImage(systemName: icon,
                                   withConfiguration: UIImage.SymbolConfiguration(pointSize: 36, weight: .thin))
        messageLabel.text = message
    }
}
