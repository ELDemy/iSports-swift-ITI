//
//  SettingsViewProtocol.swift
//  iSports
//
//  Created by JETSMobileLabMini10 on 10/06/2026.
//

import UIKit

protocol SettingsViewProtocol: AnyObject {
    func updateThemeButton(
        title: String,
        iconName: String,
        foregroundColor: UIColor
    )

    func applyTheme(_ style: UIUserInterfaceStyle)
}
