enum UserEndpoint: Endpoint {
    case getUsers
    case getUser(id: Int)
    case createUser(user: User)
    case updateUser(id: Int, user: User)
    case deleteUser(id: Int)
    
    var path: String {
        switch self {
        case .getUsers, .createUser:
            return "/users"
        case .getUser(let id), .updateUser(let id, _), .deleteUser(let id):
            return "/users/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUsers, .getUser:
            return .get
        case .createUser:
            return .post
        case .updateUser:
            return .put
        case .deleteUser:
            return .delete
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .createUser(let user), .updateUser(_, let user):
            return [
                "name": user.name,
                "username": user.username,
                "email": user.email,
                "phone": user.phone,
                "website": user.website,
                "address": [
                    "street": user.address.street,
                    "suite": user.address.suite,
                    "city": user.address.city,
                    "zipcode": user.address.zipcode,
                    "geo": [
                        "lat": user.address.geo.lat,
                        "lng": user.address.geo.lng
                    ]
                ],
                "company": [
                    "name": user.company.name,
                    "catchPhrase": user.company.catchPhrase,
                    "bs": user.company.bs
                ]
            ]
        default:
            return nil
        }
    }
}