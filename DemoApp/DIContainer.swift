class DIContainer {
    
    static let shared = DIContainer()
    
    private init() {}
    
    // Network
    func makeNetworkService() -> NetworkServiceProtocol {
        NetworkService()
    }
    
    // Data Sources
    func makeUserDataSource() -> UserDataSourceProtocol {
        UserDataSource(networkService: makeNetworkService())
    }
    
    // Repositories
    func makeUserRepository() -> UserRepositoryProtocol {
        UserRepository(dataSource: makeUserDataSource())
    }
    
    // ViewModels
    @MainActor
    func makeUserListViewModel() -> UserListViewModel {
        UserListViewModel(repository: makeUserRepository())
    }
    
    @MainActor
    func makeUserDetailViewModel(userId: Int) -> UserDetailViewModel {
        UserDetailViewModel(userId: userId, repository: makeUserRepository())
    }
    
    @MainActor
    func makeCreateUserViewModel() -> CreateUserViewModel {
        CreateUserViewModel(repository: makeUserRepository())
    }
    
    @MainActor
    func makeUserEditViewModel(userId: Int) -> UserEditViewModel {
        UserEditViewModel(userId: userId, repository: makeUserRepository())
    }

}
