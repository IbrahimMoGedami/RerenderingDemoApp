import SwiftUI

struct UserEditView: View {
    
    @StateObject var viewModel: UserEditViewModel
    @EnvironmentObject private var router: NavigationRouter
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Section("Edit Information") {
                TextField("Name", text: $viewModel.name)
                TextField("Username", text: $viewModel.username)
                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                TextField("Phone", text: $viewModel.phone)
                    .keyboardType(.phonePad)
                TextField("Website", text: $viewModel.website)
                    .autocapitalization(.none)
                    .keyboardType(.URL)
            }
            
            Section {
                Button("Update User") {
                    Task {
                        if await viewModel.updateUser() {
                            dismiss()
                        }
                    }
                }
                .disabled(!viewModel.isFormValid)
                .frame(maxWidth: .infinity)
            }
            
            Section("Navigation") {
                Button("Pop to Settings (1 level)") {
                    router.navigateBack()
                }
                
                Button("Pop to User Detail (2 levels)") {
                    router.pop(2)
                }
                
                Button("Pop to User List (3 levels)") {
                    router.pop(3)
                }
                
                Text("Tap here to pop 2 levels")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .onTapPop(2, router: router)
            }
        }
        .navigationTitle("Edit User")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadUser()
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            }
        }
        .alert("Error", isPresented: $viewModel.showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "Unknown error")
        }
        .alert("Success", isPresented: $viewModel.showingSuccess) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.successMessage ?? "User updated successfully")
        }
    }
}
