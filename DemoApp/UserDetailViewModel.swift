import Foundation

@MainActor
class UserDetailViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showingError = false
    
    private let repository: UserRepositoryProtocol
    private let userId: Int
    
    init(userId: Int, repository: UserRepositoryProtocol = UserRepository()) {
        self.userId = userId
        self.repository = repository
    }
    
    func loadUser() async {
        isLoading = true
        errorMessage = nil
        
        do {
            user = try await repository.getUser(id: userId)
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showingError = true
    }
}