import SwiftUI

struct UserSettingsView: View {
    let userId: Int
    @EnvironmentObject private var router: NavigationRouter
    
    var body: some View {
        List {
            Section("Navigation") {
                Button("Pop to User List (2 levels)") {
                    router.pop(2)
                }
                
                Button("Pop to Root") {
                    router.popToRoot()
                }
                
                Button("Navigate to Edit") {
                    router.navigate(to: .userEdit(userId: userId))
                }
            }
            
            Section("Appearance") {
                Toggle("Dark Mode", isOn: .constant(false))
                Toggle("Notifications", isOn: .constant(true))
            }
            
            Section("Account") {
                Button("Change Password") { }
                Button("Privacy Settings") { }
                Button("Delete Account", role: .destructive) { }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}