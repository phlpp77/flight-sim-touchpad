//
//  SoundService.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 08.07.22.
//

import Foundation
import AVFoundation

class SoundService {
    static let shared = SoundService()
    private var soundEffect: AVAudioPlayer?
    
    public func tockSound() {
        let path = Bundle.main.path(forResource: "tock.mp3", ofType:nil)!
        playSound(path: path)
    }
    
    public func atcSound() {
        let path = Bundle.main.path(forResource: "atc.mp3", ofType:nil)!
        playSound(path: path)
    }
    
    private func playSound(path: String) {
        let url = URL(fileURLWithPath: path)
        do {
            soundEffect = try AVAudioPlayer(contentsOf: url)
            print("[SoundService] Play sound \(url)")
            soundEffect?.play()
        } catch {
            print("[SoundService] Could not load file \(error.localizedDescription)")
        }
    }
}
