extension API {
    struct getFriends: APIRequest {
        typealias ResultValue = [User]
        var parameters: [String : String]
        
        let userId: UserId
    }
}

extension API {
    struct getPosts: APIRequest {
        typealias ResultValue = ([Post], [User])
        var parameters: [String : String]
        
        let userId: UserId
    }
}


extension API {
    struct login: APIRequest {
        typealias ResultValue = User
        var parameters: [String : String]
        
        let email: String
        let password: String
        
        init(email: String, password: String) {
            self.parameters = [:]
            self.email = email
            self.password = password
        }
    }
}

extension API {
    struct checkAuth: APIRequest {
        typealias ResultValue = User
        var parameters: [String : String]
        
        init() {
            self.parameters = [:]
        }
    }
}
