//
//  ButtonPressActions.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 12.07.22.
//

import SwiftUI

struct ButtonPressActions: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content.simultaneousGesture(
        DragGesture(minimumDistance: 0)
            .onChanged({ _ in
                onPress()
            })
            .onEnded({ _ in
                onRelease()
            })
        )
    }
}


extension View {
    func pressEvents(onPress: @escaping (() -> Void), onRelease: @escaping (() -> Void)) -> some View {
        modifier(ButtonPressActions(onPress: { onPress() }, onRelease: { onRelease() }))
    }
}
