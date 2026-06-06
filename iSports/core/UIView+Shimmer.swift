import UIKit

extension UIView {
    
    private var shimmerLayerName: String { return "shimmerLayer" }
    
    func startShimmering() {
        stopShimmering() // Ensure we don't add multiple layers
        
        let lightColor = UIColor(white: 1.0, alpha: 0.1).cgColor
        let darkColor = UIColor(white: 0.8, alpha: 0.4).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [darkColor, lightColor, darkColor]
        gradientLayer.frame = CGRect(x: -bounds.size.width, y: 0, width: 3 * bounds.size.width, height: bounds.size.height)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.name = shimmerLayerName
        
        layer.addSublayer(gradientLayer)
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 1.2
        animation.fromValue = -bounds.size.width
        animation.toValue = bounds.size.width
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        
        gradientLayer.add(animation, forKey: "shimmerAnimation")
    }
    
    func stopShimmering() {
        layer.sublayers?.first(where: { $0.name == shimmerLayerName })?.removeFromSuperlayer()
    }
}
