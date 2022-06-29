//
//  StateContainer.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 29.06.22.
//

import Foundation

struct StateContainer {
    let state = TouchPadModel()
    let appearanceVM: AppearanceViewModel
    let verticalSliderVM: VerticalSliderViewModel
    let ringSliderVM = RingSliderViewModel()
    
    init() {
        appearanceVM = AppearanceViewModel(state: state)
        verticalSliderVM = VerticalSliderViewModel(state: state)
    }
}
