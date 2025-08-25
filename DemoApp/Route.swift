enum Route: Hashable, Identifiable {
    case userDetail(userId: Int)
    case createUser
    case userSettings(userId: Int)
    case userEdit(userId: Int)
    
    var id: String {
        switch self {
        case .userDetail(let userId):
            return "userDetail_\(userId)"
        case .createUser:
            return "createUser"
        case .userSettings(let userId):
            return "userSettings_\(userId)"
        case .userEdit(let userId):
            return "userEdit_\(userId)"
        }
    }
}