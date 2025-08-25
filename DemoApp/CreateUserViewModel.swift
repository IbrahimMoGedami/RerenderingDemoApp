import Foundation

@MainActor
class CreateUserViewModel: ObservableObject {
    
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
    
    init(repository: UserRepositoryProtocol = UserRepository()) {
        self.repository = repository
    }
    
    var isFormValid: Bool {
        !name.isEmpty && !username.isEmpty && !email.isEmpty && email.contains("@")
    }
    
    func createUser() async -> Bool {
        guard isFormValid else { return false }
        
        isLoading = true
        errorMessage = nil
        
        let newUser = User(
            id: Int.random(in: 1000...9999),
            name: name,
            username: username,
            email: email,
            phone: phone,
            website: website,
            address: Address(
                street: "",
                suite: "",
                city: "",
                zipcode: "",
                geo: Geo(lat: "0", lng: "0")
            ),
            company: Company(
                name: "",
                catchPhrase: "",
                bs: ""
            )
        )
        
        do {
            _ = try await repository.addUser(user: newUser)
            successMessage = "User created successfully!"
            showingSuccess = true
            clearForm()
            isLoading = false
            return true
        } catch {
            handleError(error)
            isLoading = false
            return false
        }
    }
    
    private func clearForm() {
        name = ""
        username = ""
        email = ""
        phone = ""
        website = ""
    }
    
    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showingError = true
    }
}
