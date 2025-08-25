import SwiftUI

struct CreateUserView: View {
    @StateObject var viewModel: CreateUserViewModel
    @EnvironmentObject private var router: NavigationRouter
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Section("Personal Information") {
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
                Button("Create User") {
                    Task {
                        if await viewModel.createUser() {
                            dismiss()
                        }
                    }
                }
                .disabled(!viewModel.isFormValid)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Create User")
        .navigationBarTitleDisplayMode(.inline)
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
            Text(viewModel.successMessage ?? "User created successfully")
        }
    }
}