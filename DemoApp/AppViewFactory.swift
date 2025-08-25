import SwiftUI

//protocol ViewFactory {
//    
//    associatedtype ViewType: View
//    @ViewBuilder func makeView(for route: Route) -> ViewType
//    
//}
//
//@MainActor
//class AppViewFactory: ViewFactory {


class AppViewFactory {
    
    @ViewBuilder
    @MainActor
    func makeView(for route: Route) -> some View {
        switch route {
        case .userDetail(let userId):
            UserDetailView(viewModel: UserDetailViewModel(userId: userId))
        case .createUser:
            CreateUserView(viewModel: CreateUserViewModel())
        case .userSettings(let userId):
            UserSettingsView(userId: userId)
        case .userEdit(let userId):
            UserEditView(viewModel: UserEditViewModel(userId: userId))
        }
    }

}
