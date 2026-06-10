import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var themeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let accent = UIColor(named: "accentColor") ?? .systemGreen
        let dynamicColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .white : accent
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
        
        setupUI()
    }
    
    private func setupUI() {
        themeButton.layer.cornerRadius = 12
        updateThemeButtonTitle()
    }

    @IBAction func themeButtonTapped() {
        guard let windowScene = view.window?.windowScene,
              let window = windowScene.windows.first else { return }
        
        let currentStyle = window.overrideUserInterfaceStyle
        let newStyle: UIUserInterfaceStyle
        
        if currentStyle == .unspecified {
            newStyle = traitCollection.userInterfaceStyle == .dark ? .light : .dark
        } else {
            newStyle = currentStyle == .dark ? .light : .dark
        }
        
        UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromTop, animations: {
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
