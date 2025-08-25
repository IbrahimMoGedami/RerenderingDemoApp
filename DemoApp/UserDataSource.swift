protocol UserDataSourceProtocol {
    func fetchUsers() async throws -> [User]
    func fetchUser(id: Int) async throws -> User
    func createUser(user: User) async throws -> User
    func updateUser(id: Int, user: User) async throws -> User
    func deleteUser(id: Int) async throws
}

class UserDataSource: UserDataSourceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchUsers() async throws -> [User] {
        try await networkService.request(UserEndpoint.getUsers)
    }
    
    func fetchUser(id: Int) async throws -> User {
        try await networkService.request(UserEndpoint.getUser(id: id))
    }
    
    func createUser(user: User) async throws -> User {
        try await networkService.request(UserEndpoint.createUser(user: user))
    }
    
    func updateUser(id: Int, user: User) async throws -> User {
        try await networkService.request(UserEndpoint.updateUser(id: id, user: user))
    }
    
    func deleteUser(id: Int) async throws {
        try await networkService.request(UserEndpoint.deleteUser(id: id))
    }
}