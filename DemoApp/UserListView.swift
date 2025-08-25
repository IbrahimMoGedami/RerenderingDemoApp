import SwiftUI

struct UserListView: View {
    @StateObject private var viewModel = UserListViewModel()
    @StateObject private var router = NavigationRouter()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack {
                if viewModel.isLoading && viewModel.users.isEmpty {
                    ProgressView("Loading users...")
                } else {
                    List {
                        ForEach(viewModel.users) { user in
                            NavigationLink(value: Route.userDetail(userId: user.id)) {
                                UserRowView(user: user)
                            }
                        }
                        .onDelete { indexSet in
                            Task {
                                await viewModel.deleteUser(at: indexSet)
                            }
                        }
                    }
                    .refreshable {
                        await viewModel.refresh()
                    }
                }
            }
            .navigationTitle("Users")
            .navigationDestination(for: Route.self) { route in
                AppViewFactory().makeView(for: route)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add", systemImage: "plus") {
                        router.navigate(to: .createUser)
                    }
                }
            }
            .alert("Error", isPresented: $viewModel.showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error")
            }
        }
        .environmentObject(router)
        .task {
            await viewModel.loadUsers()
        }
    }
}

struct UserRowView: View {
    let user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(user.name)
                .font(.headline)
            Text(user.email)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(user.phone)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}