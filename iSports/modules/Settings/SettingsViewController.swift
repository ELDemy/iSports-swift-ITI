import UIKit

class SettingsViewController: UIViewController {

    private let themeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "accentColor") ?? .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.title = "Settings"
        
        let accent = UIColor(named: "accentColor") ?? .systemGreen
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [
            .foregroundColor: accent,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = accent
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(themeButton)
        NSLayoutConstraint.activate([
            themeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            themeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            themeButton.widthAnchor.constraint(equalToConstant: 240),
            themeButton.heightAnchor.constraint(equalToConstant: 54)
        ])
        
        themeButton.addTarget(self, action: #selector(themeButtonTapped), for: .touchUpInside)
        updateThemeButtonTitle()
    }

    @objc private func themeButtonTapped() {
        guard let windowScene = view.window?.windowScene,
              let window = windowScene.windows.first else { return }
        
        let currentStyle = window.overrideUserInterfaceStyle
        let newStyle: UIUserInterfaceStyle
        
        if currentStyle == .unspecified {
            newStyle = traitCollection.userInterfaceStyle == .dark ? .light : .dark
        } else {
            newStyle = currentStyle == .dark ? .light : .dark
        }
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.overrideUserInterfaceStyle = newStyle
        }, completion: nil)
        
        UserDefaults.standard.set(newStyle == .dark ? "Dark" : "Light", forKey: "AppTheme")
        updateThemeButtonTitle(for: newStyle)
    }

    private func updateThemeButtonTitle(for style: UIUserInterfaceStyle? = nil) {
        let currentStyle: UIUserInterfaceStyle
        if let style = style {
            currentStyle = style
        } else if let savedTheme = UserDefaults.standard.string(forKey: "AppTheme") {
            currentStyle = savedTheme == "Dark" ? .dark : .light
        } else {
            currentStyle = traitCollection.userInterfaceStyle
        }
        
        let title = currentStyle == .dark ? " Light Mode" : " Dark Mode"
        let iconName = currentStyle == .dark ? "sun.max.fill" : "moon.fill"
        
        themeButton.setTitle(title, for: .normal)
        themeButton.setImage(UIImage(systemName: iconName), for: .normal)
    }
}
