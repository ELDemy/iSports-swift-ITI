import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var themeButton: UIButton!
    var presenter: SettingsPresenterProtocol!

       override func viewDidLoad() {
           super.viewDidLoad()
           self.title = L10n.settings.localized
           presenter = SettingsPresenter(view: self)

           configureNavigationBar()

           themeButton.layer.cornerRadius = 12

           presenter.viewDidLoad()
       }

    @IBAction func themeButtonTapped() {
        presenter.themeButtonTapped()
    }

}
extension SettingsViewController: SettingsViewProtocol {

    func updateThemeButton(
        title: String,
        iconName: String,
        foregroundColor: UIColor
    ) {

        if var config = themeButton.configuration {

            config.title = title
            config.image = UIImage(systemName: iconName)
            config.baseForegroundColor = foregroundColor

            themeButton.configuration = config

        } else {

            themeButton.setTitle(title, for: .normal)
            themeButton.setImage(
                UIImage(systemName: iconName),
                for: .normal
            )

            themeButton.setTitleColor(
                foregroundColor,
                for: .normal
            )

            themeButton.tintColor = foregroundColor
        }
    }

    func applyTheme(_ style: UIUserInterfaceStyle) {

        guard let windowScene = view.window?.windowScene,
              let window = windowScene.windows.first
        else { return }

        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionFlipFromTop
        ) {
            window.overrideUserInterfaceStyle = style
        }
    }
    private func configureNavigationBar() {

        let accent = UIColor(named: "accentColor") ?? .systemGreen

        let dynamicColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? .white
                : accent
        }

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground

        appearance.titleTextAttributes = [
            .foregroundColor: dynamicColor,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = dynamicColor
    }
}
