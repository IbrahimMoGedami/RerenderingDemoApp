protocol UserRepositoryProtocol {
    func getUsers() async throws -> [User]
    func getUser(id: Int) async throws -> User
    func addUser(user: User) async throws -> User
    func updateUser(id: Int, user: User) async throws -> User
    func deleteUser(id: Int) async throws
}

class UserRepository: UserRepositoryProtocol {
    private let dataSource: UserDataSourceProtocol
    
    init(dataSource: UserDataSourceProtocol = UserDataSource()) {
        self.dataSource = dataSource
    }
    
    func getUsers() async throws -> [User] {
        try await dataSource.fetchUsers()
    }
    
    func getUser(id: Int) async throws -> User {
        try await dataSource.fetchUser(id: id)
    }
    
    func addUser(user: User) async throws -> User {
        try await dataSource.createUser(user: user)
    }
    
    func updateUser(id: Int, user: User) async throws -> User {
        try await dataSource.updateUser(id: id, user: user)
    }
    
    func deleteUser(id: Int) async throws {
        try await dataSource.deleteUser(id: id)
    }
}