
import UIKit

extension UIView {
    func applySubtlePrimaryGradient(radius: CGFloat = 14) {
        self.layer.sublayers?.filter { $0 is CAGradientLayer && $0.name == "SubtlePrimaryGradient" }.forEach { $0.removeFromSuperlayer() }
        
        let gradient = CAGradientLayer()
        gradient.name = "SubtlePrimaryGradient"
        gradient.frame = self.bounds
        
        let primaryColor = UIColor(named: "AppPrimary") ?? .systemGreen
        
        if traitCollection.userInterfaceStyle == .dark {
            gradient.colors = [
                primaryColor.withAlphaComponent(0.12).cgColor,
                primaryColor.withAlphaComponent(0.02).cgColor
            ]
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 1)
        } else {
            gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor]
        }
        
        gradient.cornerRadius = radius
        self.layer.insertSublayer(gradient, at: 0)
    }
}
