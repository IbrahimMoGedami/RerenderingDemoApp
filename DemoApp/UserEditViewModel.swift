import Foundation

@MainActor
class UserEditViewModel: ObservableObject {
    @Published var user: User?
    @Published var name = ""
    @Published var username = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var website = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showingError = false
    @Published var successMessage: String?
    @Published var showingSuccess = false
    
    private let repository: UserRepositoryProtocol
    private let userId: Int
    
    init(userId: Int, repository: UserRepositoryProtocol = UserRepository()) {
        self.userId = userId
        self.repository = repository
    }
    
    var isFormValid: Bool {
        !name.isEmpty && !username.isEmpty && !email.isEmpty && email.contains("@")
    }
    
    func loadUser() async {
        isLoading = true
        errorMessage = nil
        
        do {
            user = try await repository.getUser(id: userId)
            if let user = user {
                name = user.name
                username = user.username
                email = user.email
                phone = user.phone
                website = user.website
            }
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    func updateUser() async -> Bool {
        guard isFormValid, let existingUser = user else { return false }
        
        isLoading = true
        errorMessage = nil
        
        let updatedUser = User(
            id: userId,
            name: name,
            username: username,
            email: email,
            phone: phone,
            website: website,
            address: existingUser.address,
            company: existingUser.company
        )
        
        do {
            _ = try await repository.updateUser(id: userId, user: updatedUser)
            successMessage = "User updated successfully!"
            showingSuccess = true
            isLoading = false
            return true
        } catch {
            handleError(error)
            isLoading = false
            return false
        }
    }
    
    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showingError = true
    }
}