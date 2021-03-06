//
//  FlightDataViewModel.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 13.04.22.
//

import Foundation
import Combine

class AppearanceViewModel: ObservableObject {
    
    // MARK: Initial setup
    private var state: TouchPadModel
    init(state: TouchPadModel) {
        self.state = state
        self.updateShowTapIndicator()
        self.updateSpeedStepsInFive()
        self.updateHeadingStepsInFive()
        self.updateScreen()
        self.updateSliderSoundEffect()
        self.updateShowTestValueWindow()
        
        // setup the combine subscribers
        setupSubscribers()
    }
    
    // MARK: Combine setup
    private var subscriptions = Set<AnyCancellable>()
    private func setupSubscribers() {
        state.didSetShowTapIndicator
            .sink {
                self.updateShowTapIndicator()
            }
            .store(in: &subscriptions)
        state.didSetSpeedStepsInFive
            .sink {
                self.updateSpeedStepsInFive()
            }
            .store(in: &subscriptions)
        state.didSetHeadingStepsInFive
            .sink {
                self.updateHeadingStepsInFive()
            }
            .store(in: &subscriptions)
        state.didSetScreen
            .sink {
                self.updateScreen()
            }
            .store(in: &subscriptions)
        state.didSetSliderSoundEffect
            .sink {
                self.updateSliderSoundEffect()
            }
            .store(in: &subscriptions)
        state.didSetShowTestValueWindow
            .sink {
                self.updateShowTestValueWindow()
            }
            .store(in: &subscriptions)
        state.didSetMQTTConnection
            .sink {
                self.updateMQTTConnectionIsOpen()
            }
            .store(in: &subscriptions)
    }
    
    // MARK: Vars that are used inside the view
    @Published public var showTapIndicator: Bool!
    @Published public var speedStepsInFive: Bool!
    @Published public var headingStepsInFive: Bool!
    @Published public var screen: Screen = .essential
    @Published public var sliderSoundEffect: Bool!
    @Published public var showTestValueWindow: Bool!
    @Published public var mqttConnectionIsOpen: Bool!
    
    // MARK: Functions/Vars to interact with the state
    public var toggleShowTapIndicator: Bool {
        get {
            self.showTapIndicator
        }
        set {
            state.changeTapIndicator(newValue)
        }
    }
    public var toggleSpeedStepsInFive: Bool {
        get {
            self.speedStepsInFive
        }
        set {
            state.changeSpeedStepsInFive(newValue)
        }
    }
    public var toggleHeadingStepsInFive: Bool {
        get {
            self.headingStepsInFive
        }
        set {
            state.changeHeadingStepsInFive(newValue)
        }
    }
    public var toggleScreen: Screen {
        get {
            self.screen
        }
        set {
            state.changeScreen(newValue)
        }
    }
    public var toggleSliderSoundEffect: Bool {
        get {
            self.sliderSoundEffect
        }
        set {
            state.changeSliderSoundEffect(newValue)
        }
    }
    public var toggleShowTestValueWindow: Bool {
        get {
            self.showTestValueWindow
        }
        set {
            state.changeShowTestValueWindow(newValue)
        }
    }
    
    // MARK: Update functions to be called from state via combine
    private func updateShowTapIndicator() {
        showTapIndicator = state.settings.showTapIndicator
    }
    private func updateSpeedStepsInFive() {
        speedStepsInFive = state.settings.speedStepsInFive
    }
    private func updateHeadingStepsInFive() {
        headingStepsInFive = state.settings.headingStepsInFive
    }
    private func updateScreen() {
        screen = state.settings.screen
    }
    private func updateSliderSoundEffect() {
        sliderSoundEffect = state.settings.sliderSoundEffect
    }
    private func updateShowTestValueWindow() {
        showTestValueWindow = state.settings.showTestValueWindow
    }
    private func updateMQTTConnectionIsOpen() {
        mqttConnectionIsOpen = state.settings.mqttConnectionIsOpen
    }
}
