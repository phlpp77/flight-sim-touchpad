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
    public var serviceActivated = false
    private var soundEffect: AVAudioPlayer?
    private var control: Time_Control = Time_Control(0)
    
    public func tockSound() {
        let path = Bundle.main.path(forResource: "tock.mp3", ofType:nil)!
        playSound(path: path)
    }
    
    public func atcSound() {
        let path = Bundle.main.path(forResource: "atc.mp3", ofType:nil)!
        playSound(path: path)
    }
    
    public func successSound() {
        let path = Bundle.main.path(forResource: "success.mp3", ofType:nil)!
        playSound(path: path)
    }
    
    public func connectSound() {
        let path = Bundle.main.path(forResource: "connect.mp3", ofType:nil)!
        playSound(path: path)
    }
    
    public func disconnectSound() {
        let path = Bundle.main.path(forResource: "disconnect.mp3", ofType:nil)!
        playSound(path: path)
    }
    
    public func speakText(_ text: String) {
        let speechSynthesizer = AVSpeechSynthesizer()
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(speechUtterance)
    }
    
    private func playSound(path: String) {
        if serviceActivated {
            let url = URL(fileURLWithPath: path)
            do {
                
                // start an async timer so the maximum is 10 sound effects per second (= 0.1 seconds)
                if control.can_send {
                    control = Time_Control(0.1)
                    control.start()
                    soundEffect = try AVAudioPlayer(contentsOf: url)
                    print("[SoundService] Play sound")
                    soundEffect?.play()
                }
                
            } catch {
                print("[SoundService] Could not load file \(error.localizedDescription)")
            }
        }
    }
}
