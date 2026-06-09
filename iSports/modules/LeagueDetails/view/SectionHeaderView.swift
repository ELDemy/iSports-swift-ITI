//
//  Untitled.swift
//  iSports
//
//  Created by JETSMobileLabMini9 on 09/06/2026.
//
import UIKit

// MARK: - SectionHeaderView
class SectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeaderView"

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 20, weight: .bold)
        l.textColor = UIColor(named: "accentColor")
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let countBadge: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 11, weight: .semibold)
        l.textColor = .white
        l.textAlignment = .center
        l.backgroundColor = UIColor(named: "accentColor")
        l.layer.cornerRadius = 10
        l.layer.masksToBounds = true
        l.translatesAutoresizingMaskIntoConstraints = false
        l.isHidden = true
        return l
    }()

    private let separator: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(named: "accentColor")?.withAlphaComponent(
            0.25
        )
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor =
            UIColor(named: "ViewBackground") ?? .systemGroupedBackground

        addSubview(titleLabel)
        addSubview(countBadge)
        addSubview(separator)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            titleLabel.bottomAnchor.constraint(
                equalTo: separator.topAnchor,
                constant: -6
            ),

            countBadge.leadingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor,
                constant: 8
            ),
            countBadge.centerYAnchor.constraint(
                equalTo: titleLabel.centerYAnchor
            ),
            countBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 22),
            countBadge.heightAnchor.constraint(equalToConstant: 20),

            separator.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            separator.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),
            separator.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -2
            ),
            separator.heightAnchor.constraint(equalToConstant: 1.5),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, count: Int?) {
        titleLabel.text = title
        if let count {
            countBadge.text = " \(count) "
            countBadge.isHidden = false
        } else {
            countBadge.isHidden = true
        }
    }
}
