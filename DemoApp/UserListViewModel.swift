import Foundation

@MainActor
class UserListViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showingError = false
    
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol = UserRepository()) {
        self.repository = repository
    }
    
    func loadUsers() async {
        isLoading = true
        errorMessage = nil
        
        do {
            users = try await repository.getUsers()
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    func refresh() async {
        await loadUsers()
    }
    
    func deleteUser(at offsets: IndexSet) async {
        guard let index = offsets.first else { return }
        let user = users[index]
        
        do {
            try await repository.deleteUser(id: user.id)
            users.remove(at: index)
        } catch {
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showingError = true
    }
}