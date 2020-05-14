// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/05/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

#if !os(tvOS) && canImport(UIKit)

public struct UIKitShim<Content> where Content: View {
    let view: Content
    
    public func onTapGesture(perform action: @escaping () -> Void) -> some View {
        return view.onTapGesture(perform: action)
    }
    
    public func contextMenu<MenuItems>(menuItems: () -> MenuItems) -> some View where MenuItems : View {
        return view.contextMenu(menuItems: menuItems)
    }
}

#endif
