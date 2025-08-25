import SwiftUI

struct UserDetailView: View {
    @StateObject var viewModel: UserDetailViewModel
    @EnvironmentObject private var router: NavigationRouter
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if viewModel.isLoading {
                    ProgressView("Loading user details...")
                        .frame(maxWidth: .infinity)
                } else if let user = viewModel.user {
                    UserInfoSection(user: user)
                    
                    AddressSection(address: user.address)
                    
                    CompanySection(company: user.company)
                    
                    ActionButtons(userId: user.id, router: router)
                }
            }
            .padding()
        }
        .navigationTitle("User Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Settings", systemImage: "gear") {
                    router.navigate(to: .userSettings(userId: viewModel.user?.id ?? 0))
                }
            }
        }
        .alert("Error", isPresented: $viewModel.showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "Unknown error")
        }
        .task {
            await viewModel.loadUser()
        }
    }
}

struct UserInfoSection: View {
    let user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Contact Information")
                .font(.title2)
                .bold()
            
            InfoRow(label: "Name", value: user.name)
            InfoRow(label: "Username", value: user.username)
            InfoRow(label: "Email", value: user.email)
            InfoRow(label: "Phone", value: user.phone)
            InfoRow(label: "Website", value: user.website)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct AddressSection: View {
    let address: Address
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Address")
                .font(.title2)
                .bold()
            
            InfoRow(label: "Street", value: address.street)
            InfoRow(label: "Suite", value: address.suite)
            InfoRow(label: "City", value: address.city)
            InfoRow(label: "Zipcode", value: address.zipcode)
            InfoRow(label: "Geo", value: "\(address.geo.lat), \(address.geo.lng)")
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct CompanySection: View {
    let company: Company
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Company")
                .font(.title2)
                .bold()
            
            InfoRow(label: "Name", value: company.name)
            InfoRow(label: "Catchphrase", value: company.catchPhrase)
            InfoRow(label: "Business", value: company.bs)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label + ":")
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            Text(value)
            Spacer()
        }
    }
}

struct ActionButtons: View {
    let userId: Int
    let router: NavigationRouter
    
    var body: some View {
        VStack(spacing: 12) {
            Button("Edit User") {
                router.navigate(to: .userEdit(userId: userId))
            }
            .buttonStyle(.borderedProminent)
            
            Button("Pop to Root") {
                router.popToRoot()
            }
            .buttonStyle(.bordered)
            
            Text("Tap to pop 1 level")
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .onTapPop(1, router: router)
        }
        .padding(.top, 20)
    }
}