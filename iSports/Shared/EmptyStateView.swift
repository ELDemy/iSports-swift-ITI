//
//  EmptyStateView.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 07/05/2026.
//
import UIKit
import Lottie

class EmptyStateView: UIView {
    
    private var animationView: LottieAnimationView!
    private var messageLabel: UILabel!
    
    init(message: String, animationName: String) {
        super.init(frame: .zero)
        setupUI(message: message, animationName: animationName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(message: String, animationName: String) {
        animationView = LottieAnimationView(name: animationName)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        animationView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(animationView)
        
        messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .gray
        messageLabel.font = .systemFont(ofSize: 18, weight: .medium)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -40),
            animationView.widthAnchor.constraint(equalToConstant: 150),
            animationView.heightAnchor.constraint(equalToConstant: 150),
            
            messageLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
        
        animationView.play()
    }
}
