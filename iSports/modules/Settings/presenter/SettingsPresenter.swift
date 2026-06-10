//
//  SettingsPresenter.swift
//  iSports
//
//  Created by JETSMobileLabMini10 on 10/06/2026.
//

import UIKit

final class SettingsPresenter: SettingsPresenterProtocol {

    weak var view: SettingsViewProtocol?

    init(view: SettingsViewProtocol) {
        self.view = view
    }

    func viewDidLoad() {
        updateThemeUI()
    }

    func themeButtonTapped() {

        let currentTheme =
            UserDefaults.standard.string(forKey: "AppTheme") ?? "Light"

        let newStyle: UIUserInterfaceStyle =
            currentTheme == "Dark" ? .light : .dark

        UserDefaults.standard.set(
            newStyle == .dark ? "Dark" : "Light",
            forKey: "AppTheme"
        )

        view?.applyTheme(newStyle)

        updateThemeUI(style: newStyle)
    }

    private func updateThemeUI(
        style: UIUserInterfaceStyle? = nil
    ) {

        let currentStyle: UIUserInterfaceStyle

        if let style {
            currentStyle = style
        } else {

            let savedTheme =
                UserDefaults.standard.string(forKey: "AppTheme") ?? "Light"

            currentStyle =
                savedTheme == "Dark" ? .dark : .light
        }

        let title =
            currentStyle == .dark
            ? " Light Mode"
            : " Dark Mode"

        let iconName =
            currentStyle == .dark
            ? "sun.max.fill"
            : "moon.fill"

        let foregroundColor: UIColor =
            currentStyle == .dark
            ? .black
            : .white

        view?.updateThemeButton(
            title: title,
            iconName: iconName,
            foregroundColor: foregroundColor
        )
    }
}


