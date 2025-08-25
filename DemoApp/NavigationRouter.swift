import SwiftUI

class NavigationRouter: ObservableObject {
    
    @Published var path = NavigationPath()
    private var routeHistory: [Route] = []
    
    // MARK: - Navigation Methods
    func navigate(to route: Route) {
        path.append(route)
        routeHistory.append(route)
    }
    
    func navigateBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
        if !routeHistory.isEmpty {
            routeHistory.removeLast()
        }
    }
    
    func navigateToRoot() {
        path.removeLast(path.count)
        routeHistory.removeAll()
    }
    
    func pop(_ count: Int) {
        guard count > 0 && count <= path.count else { return }
        path.removeLast(count)
        if routeHistory.count >= count {
            routeHistory.removeLast(count)
        }
    }
    
    func popToRoot() {
        navigateToRoot()
    }
    
    // MARK: - Route Access
    var currentRoute: Route? {
        routeHistory.last
    }
    
    var routes: [Route] {
        routeHistory
    }
    
    func containsRoute(where condition: (Route) -> Bool) -> Bool {
        routeHistory.contains(where: condition)
    }
    
    // MARK: - Advanced Navigation
    func popTo(_ condition: (Route) -> Bool) {
        guard let targetIndex = routeHistory.lastIndex(where: condition) else { return }
        
        let popCount = routeHistory.count - targetIndex - 1
        if popCount > 0 {
            path.removeLast(popCount)
            routeHistory.removeLast(popCount)
        }
    }
    
    func popToUserList() {
        popTo { route in
            if case .userDetail = route { return true }
            return false
        }
    }

}
