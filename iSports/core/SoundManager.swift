//
//  SoundManager.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 07/05/2026.
//

import Foundation
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    private var audioPlayer: AVAudioPlayer?
    
    private init() {}
    
    func playSound(_ sound: (name: String, ext: String)) {
        let isMuted = UserDefaults.standard.bool(forKey: Constants.Defaults.soundKey)
        
        guard !isMuted else { return }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            guard let url = Bundle.main.url(forResource: sound.name, withExtension: sound.ext) else {
                print("Sound file not found: \(sound.name).\(sound.ext)")
                return
            }
            
            do {
                self?.audioPlayer = try AVAudioPlayer(contentsOf: url)
                self?.audioPlayer?.prepareToPlay()
                self?.audioPlayer?.play()
            } catch {
                print("Failed to initialize audio player: \(error.localizedDescription)")
            }
        }
    }
}
