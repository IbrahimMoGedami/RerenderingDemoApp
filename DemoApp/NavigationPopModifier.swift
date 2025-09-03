import SwiftUI

struct NavigationPopModifier: ViewModifier {
    let router: NavigationRouter
    let popCount: Int?
    let popToRoot: Bool
    
    init(router: NavigationRouter, popCount: Int? = nil, popToRoot: Bool = false) {
        self.router = router
        self.popCount = popCount
        self.popToRoot = popToRoot
    }
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                TapGesture().onEnded {
                    performNavigation()
                }
            )
    }
    
    private func performNavigation() {
        if popToRoot {
            router.popToRoot()
        } else if let popCount = popCount {
            router.pop(popCount)
        }
    }
}

extension View {
    
    func onTapPop(_ count: Int, router: NavigationRouter) -> some View {
        self.modifier(NavigationPopModifier(router: router, popCount: count))
    }
    
    func onTapPopToRoot(router: NavigationRouter) -> some View {
        self.modifier(NavigationPopModifier(router: router, popToRoot: true))
    }

}
